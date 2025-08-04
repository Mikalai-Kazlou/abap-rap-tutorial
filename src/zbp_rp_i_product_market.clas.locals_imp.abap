CLASS lhc_product_market DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR productmarkets RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR productmarkets RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR productmarkets RESULT result.

    METHODS accept_market FOR MODIFY
      IMPORTING keys FOR ACTION productmarkets~acceptmarket RESULT result.

    METHODS reject_market FOR MODIFY
      IMPORTING keys FOR ACTION productmarkets~rejectmarket RESULT result.

    METHODS set_iso_code FOR DETERMINE ON SAVE
      IMPORTING keys FOR productmarkets~setisocode.

    METHODS validate_market_id FOR VALIDATE ON SAVE
      IMPORTING keys FOR productmarkets~validatemarketid.

    METHODS get_iso_code_external
      IMPORTING country_name    TYPE string
      RETURNING VALUE(iso_code) TYPE string.

ENDCLASS.

CLASS lhc_product_market IMPLEMENTATION.
  METHOD get_instance_features.
    " Read the market status
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY productmarkets
           FIELDS ( status )
             WITH CORRESPONDING #( keys )
           RESULT DATA(product_markets)
           FAILED failed.

    result =
      VALUE #( FOR product_market IN product_markets
               LET is_accepted = COND #( WHEN product_market-status = zbp_rp_i_product_market=>market_statuses-accepted
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled  )
                   is_rejected = COND #( WHEN product_market-status = zbp_rp_i_product_market=>market_statuses-rejected
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled )
                IN
                   ( %tky                 = product_market-%tky
                     %action-acceptmarket = is_accepted
                     %action-rejectmarket = is_rejected ) ).
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD accept_market.
    " Set the new overall status
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY productmarkets
             UPDATE
             FIELDS ( status )
               WITH VALUE #( FOR key IN keys
                               ( %tky   = key-%tky
                                 status = zbp_rp_i_product_market=>market_statuses-accepted ) )
             FAILED failed
           REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY productmarkets
              ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(product_markets).

    result = VALUE #( FOR product_market IN product_markets
                        ( %tky   = product_market-%tky
                          %param = CORRESPONDING #( product_market ) ) ).
  ENDMETHOD.

  METHOD reject_market.
    " Set the new overall status
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY productmarkets
             UPDATE
             FIELDS ( status )
               WITH VALUE #( FOR key IN keys
                               ( %tky   = key-%tky
                                 status = zbp_rp_i_product_market=>market_statuses-rejected ) )
             FAILED failed
           REPORTED reported.

    " Fill the response table
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY productmarkets
              ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(product_markets).

    result = VALUE #( FOR product_market IN product_markets
                        ( %tky   = product_market-%tky
                          %param = CORRESPONDING #( product_market ) ) ).
  ENDMETHOD.

  METHOD set_iso_code.
    DATA market_range TYPE RANGE OF zrp_market_id.
    DATA product_markets_update TYPE TABLE FOR UPDATE zrp_i_product_market.

    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY ProductMarkets
           FIELDS ( MarketID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(product_markets).

    market_range = VALUE #( FOR <product_market> IN product_markets
                                sign = 'I' option = 'EQ' ( low = <product_market>-MarketID ) ).
    SORT market_range.
    DELETE ADJACENT DUPLICATES FROM market_range.

    SELECT FROM zrp_i_market
    FIELDS MarketID,
           MarketName
     WHERE MarketID IN @market_range
      INTO TABLE @DATA(makret_names).

    LOOP AT product_markets INTO DATA(product_market).
      DATA(country_name) = VALUE #( makret_names[ MarketID = product_market-MarketID ]-MarketName OPTIONAL ).
      DATA(iso_code) = get_iso_code_external( country_name = CONV #( country_name ) ).

      IF iso_code <> product_market-ISOCode.
        INSERT CORRESPONDING #( product_market ) INTO TABLE product_markets_update ASSIGNING FIELD-SYMBOL(<product_market_update>).
        <product_market_update>-ISOCode = iso_code.
      ENDIF.
    ENDLOOP.

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY productmarkets
             UPDATE
             FIELDS ( ISOCode )
               WITH product_markets_update
             FAILED DATA(modify_failed)
           REPORTED DATA(modify_reported).

    reported = CORRESPONDING #( DEEP modify_reported ).
  ENDMETHOD.

  METHOD get_iso_code_external.
    CHECK country_name IS NOT INITIAL.

    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = country_info_service_url ).

        DATA(proxy) = NEW zrp_sc_co_country_info_service( destination = destination ).
        proxy->country_isocode( EXPORTING input  = VALUE #( s_country_name = country_name )
                                IMPORTING output = DATA(response) ).

        iso_code = response-country_isocode_result.

      CATCH cx_ai_system_fault
            cx_soap_destination_error INTO DATA(exception).
        DATA(message) = exception->if_message~get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD validate_market_id.
    DATA market_ids TYPE SORTED TABLE OF zrp_d_market WITH UNIQUE KEY mrktid.

    " Read relevant product market instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY ProductMarkets
           FIELDS ( MarketID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(markets).

    " Optimization of DB select: extract distinct non-initial Product Markets IDs
    market_ids = CORRESPONDING #( markets DISCARDING DUPLICATES MAPPING mrktid = MarketID EXCEPT * ).
    DELETE market_ids WHERE mrktid IS INITIAL.

    IF market_ids IS NOT INITIAL.
      " Check if product market ID exist
      SELECT FROM zrp_d_market
      FIELDS mrktid
         FOR ALL ENTRIES IN @market_ids
       WHERE mrktid = @market_ids-mrktid
        INTO TABLE @DATA(markets_db).
    ENDIF.

    " Raise message for existing Product Market ID
    LOOP AT markets INTO DATA(market).
      " Clear state messages that might exist
      INSERT VALUE #( %tky        = market-%tky
                      %state_area = 'validateMarketID' ) INTO TABLE reported-productmarkets.

      IF NOT line_exists( markets_db[ mrktid = market-MarketID ] ).
        DATA(msg) = new_message( id       = 'ZRP_MSG'
                                 number   = '007'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = market-MarketID ).

        INSERT VALUE #( %tky              = market-%tky
                        %state_area       = 'validateMarketID'
                        %element-MarketID = if_abap_behv=>mk-on
                        %msg              = msg
                        %path             = VALUE #( product-%is_draft = market-%tky-%is_draft
                                                     product-uuid      = market-%tky-ProductUUID ) ) INTO TABLE reported-productmarkets.

        INSERT VALUE #( %tky = market-%tky ) INTO TABLE failed-productmarkets.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
