CLASS lhc_market_orders DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    TYPES tt_rr_market_orders TYPE TABLE FOR READ RESULT zrp_i_product\\marketorders.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR MarketOrders RESULT result.

    METHODS zz_set_business_partner_data FOR DETERMINE ON SAVE
      IMPORTING keys FOR MarketOrders~zzSetBusinessPartnerData.

    METHODS zz_validate_bp_id FOR VALIDATE ON SAVE
      IMPORTING keys FOR MarketOrders~zzValidateBusinessPartnerID.

    METHODS get_bps_by_market_orders
      IMPORTING market_orders  TYPE tt_rr_market_orders
      RETURNING VALUE(bp_list) TYPE zrp_sc_business_partner=>tyt_sepm_i_business_partner_et.

ENDCLASS.

CLASS lhc_market_orders IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD zz_set_business_partner_data.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY MarketOrders
           FIELDS ( zzBusinessPartnerID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

    DATA(bp_list) = get_bps_by_market_orders( market_orders ).

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY MarketOrders
             UPDATE
             FIELDS ( zzBusinessPartner
                      zzBusinessPartnerEmail
                      zzBusinessPartnerPhone )

               WITH VALUE #( FOR market_order IN market_orders
                             LET bp = VALUE #( bp_list[ business_partner = market_order-zzBusinessPartnerID ] DEFAULT VALUE #(  ) )
                              IN ( %tky = market_order-%tky
                                   zzBusinessPartner      = bp-company_name
                                   zzBusinessPartnerEmail = bp-email_address
                                   zzBusinessPartnerPhone = bp-phone_number ) )

           REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD zz_validate_bp_id.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY MarketOrders
           FIELDS ( zzBusinessPartnerID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

    DATA(bp_list) = get_bps_by_market_orders( market_orders ).

    LOOP AT market_orders ASSIGNING FIELD-SYMBOL(<market_order>).
      INSERT VALUE #( %tky        = <market_order>-%tky
                      %state_area = 'validateBusinessPartnerID' ) INTO TABLE reported-marketorders.

      IF NOT line_exists( bp_list[ business_partner = <market_order>-zzBusinessPartnerID ] ).
        MESSAGE e014(zrp_msg) INTO DATA(msg) WITH <market_order>-zzBusinessPartnerID.

        INSERT VALUE #( %tky                         = <market_order>-%tky
                        %state_area                  = 'validateBusinessPartnerID'
                        %element-zzBusinessPartnerID = if_abap_behv=>mk-on
                        %msg                         = new_message_with_text( text = msg )
                        %path                        = VALUE #( product        = CORRESPONDING #( <market_order>-%tky MAPPING uuid = ProductUUID )
                                                                productmarkets = CORRESPONDING #( <market_order>-%tky MAPPING productuuid       = ProductUUID
                                                                                                                              productmarketuuid = ProductMarketUUID ) )
                      ) INTO TABLE reported-marketorders.

        INSERT VALUE #( %tky = <market_order>-%tky ) INTO TABLE failed-marketorders.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD get_bps_by_market_orders.
    DATA bp_ids TYPE SORTED TABLE OF zrp_i_market_order WITH UNIQUE KEY zzBusinessPartnerID.

    DATA filter_conditions TYPE if_rap_query_filter=>tt_name_range_pairs.
    DATA sort_elements TYPE if_rap_query_request=>tt_sort_elements.

    bp_ids = CORRESPONDING #( market_orders DISCARDING DUPLICATES MAPPING zzBusinessPartnerID = zzBusinessPartnerID EXCEPT * ).
    DELETE bp_ids WHERE zzBusinessPartnerID IS INITIAL.

    IF bp_ids IS NOT INITIAL.
      filter_conditions = VALUE #( ( name = 'BUSINESS_PARTNER'
                                     range = VALUE #( FOR bp_id IN bp_ids
                                                        ( sign = 'I' option = 'EQ' low = bp_id-zzBusinessPartnerID ) ) ) ).

      sort_elements = VALUE #( ( element_name = 'BUSINESS_PARTNER' ) ).

      zrp_cl_bp_query_provider=>get_business_partner_list(
        EXPORTING
          filter_conditions  = filter_conditions
          sort_elements      = sort_elements
          is_data_requested  = abap_true
          is_count_requested = abap_false
        IMPORTING
          business_data      = bp_list ).

    ENDIF.
  ENDMETHOD.

ENDCLASS.
