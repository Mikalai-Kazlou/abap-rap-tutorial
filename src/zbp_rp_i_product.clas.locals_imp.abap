
CLASS lhc_product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF phases,
        planning    TYPE zrp_d_phase-phaseid VALUE 1,
        development TYPE zrp_d_phase-phaseid VALUE 2,
        production  TYPE zrp_d_phase-phaseid VALUE 3,
        phase_out   TYPE zrp_d_phase-phaseid VALUE 4,
      END OF phases.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR product RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR product RESULT result.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR product RESULT result.

    METHODS set_initial_phase FOR DETERMINE ON SAVE
      IMPORTING keys FOR product~setinitialphase.

    METHODS validate_product_group FOR VALIDATE ON SAVE
      IMPORTING keys FOR product~validateproductgroup.

    METHODS validate_product_id FOR VALIDATE ON SAVE
      IMPORTING keys FOR product~validateproductid.

    METHODS copy_product FOR MODIFY
      IMPORTING keys FOR ACTION product~copyproduct RESULT result.

ENDCLASS.


CLASS lhc_product_market DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS:
      BEGIN OF market_statuses,
        accepted TYPE abap_bool VALUE abap_true,
        rejected TYPE abap_bool VALUE abap_false,
      END OF market_statuses.

    CONSTANTS country_info_service_url TYPE string VALUE `http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso`.

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

    METHODS get_iso_code_external
      IMPORTING country_name    TYPE string
      RETURNING VALUE(iso_code) TYPE string.

ENDCLASS.


CLASS lhc_market_order DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS recalculate_total_amount FOR MODIFY
      IMPORTING keys FOR ACTION marketorders~recalculatetotalamount.

    METHODS calculate_total_amount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR marketorders~calculatetotalamount.

ENDCLASS.


CLASS lhc_product IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD set_initial_phase.
    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( phaseid )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Remove all product instance data with defined phase
    DELETE products WHERE phaseid IS NOT INITIAL.
    IF products IS INITIAL.
      RETURN.
    ENDIF.

    " Set default phase
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY product
             UPDATE
             FIELDS ( phaseid )
               WITH VALUE #( FOR product IN products
                             ( %tky    = product-%tky
                               phaseid = phases-planning ) )
           REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validate_product_group.
  ENDMETHOD.

  METHOD validate_product_id.
    DATA product_ids TYPE SORTED TABLE OF zrp_d_product WITH UNIQUE KEY prodid.

    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( id )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Optimization of DB select: extract distinct non-initial product IDs
    product_ids = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING prodid = id EXCEPT * ).
    DELETE product_ids WHERE prodid IS INITIAL.

    IF product_ids IS NOT INITIAL.
      " Check if product ID exist
      SELECT FROM zrp_d_product
      FIELDS prodid
         FOR ALL ENTRIES IN @product_ids
       WHERE prodid = @product_ids-prodid
        INTO TABLE @DATA(products_db).
    ENDIF.

    " Raise message for existing Product ID
    LOOP AT products INTO DATA(product).
      " Clear state messages that might exist
      APPEND VALUE #( %tky        = product-%tky
                      %state_area = 'validateProductID' ) TO reported-product.

      IF product-id IS NOT INITIAL AND line_exists( products_db[ prodid = product-id ] ).
        APPEND VALUE #( %tky = product-%tky ) TO failed-product.

        APPEND VALUE #( %tky        = product-%tky
                        %state_area = 'validateProductID'
                        %element-id = if_abap_behv=>mk-on
                        %msg        = NEW zcm_rp_messages( severity   = if_abap_behv_message=>severity-error
                                                           textid     = zcm_rp_messages=>product_already_exists
                                                           product_id = product-id ) ) TO reported-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD copy_product.
    DATA new_products TYPE TABLE FOR CREATE zrp_i_product.

    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
              ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).
      <product>-id      = keys[ KEY id COMPONENTS %tky = <product>-%tky ]-%param-productid.
      <product>-phaseid = phases-planning.
    ENDLOOP.

    new_products = CORRESPONDING #( products EXCEPT uuid createdby createdon changedby changedon ).

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY product
             CREATE
               AUTO FILL CID
                SET FIELDS WITH new_products
             MAPPED mapped
             FAILED failed
           REPORTED reported.

    READ ENTITY IN LOCAL MODE zrp_i_product
            ALL FIELDS WITH CORRESPONDING #( mapped-product )
         RESULT DATA(products_db)
         FAILED failed.

    result = VALUE #( FOR <product_db> IN products_db INDEX INTO index
                      ( %cid_ref = keys[ index ]-%cid_ref
                        %tky     = keys[ index ]-%tky
                        %param   = CORRESPONDING #( <product_db> ) ) ).
  ENDMETHOD.
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
               LET is_accepted = COND #( WHEN product_market-status = market_statuses-accepted
                                         THEN if_abap_behv=>fc-o-disabled
                                         ELSE if_abap_behv=>fc-o-enabled  )
                   is_rejected = COND #( WHEN product_market-status = market_statuses-rejected
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
                               status = market_statuses-accepted ) )
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
                               status = market_statuses-rejected ) )
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

    market_range = VALUE #( FOR <product_market> IN product_markets ( sign = 'I' option = 'EQ' low = <product_market>-MarketID ) ).
    DELETE ADJACENT DUPLICATES FROM market_range.

    SELECT FROM zrp_i_market
    FIELDS MarketID, MarketName
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
ENDCLASS.


CLASS lhc_market_order IMPLEMENTATION.
  METHOD recalculate_total_amount.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE

           ENTITY marketorders BY \_Product
           FIELDS ( price pricecurrency taxrate )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products)

           ENTITY marketorders
           FIELDS ( quantity )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

    LOOP AT market_orders ASSIGNING FIELD-SYMBOL(<market_order>).
      DATA(product) = products[ KEY entity COMPONENTS uuid = <market_order>-ProductUUID ].

      <market_order>-AmountCurrency = product-PriceCurrency.
      <market_order>-NetAmount      = <market_order>-Quantity * product-Price.
      <market_order>-GrossAmount    = <market_order>-NetAmount + ( <market_order>-NetAmount * product-TaxRate / 100 ).
    ENDLOOP.

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY marketorders
             UPDATE
             FIELDS ( netamount grossamount amountcurrency )
               WITH CORRESPONDING #( market_orders )
             FAILED failed
           REPORTED reported.

  ENDMETHOD.

  METHOD calculate_total_amount.
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY marketorders
            EXECUTE recalculateTotalAmount
               FROM CORRESPONDING #( keys )
           REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.
ENDCLASS.
