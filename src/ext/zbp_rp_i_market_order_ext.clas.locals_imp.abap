CLASS lhc_market_orders DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS zz_set_business_partner_data FOR DETERMINE ON SAVE
      IMPORTING keys FOR MarketOrders~zzSetBusinessPartnerData.

ENDCLASS.

CLASS lhc_market_orders IMPLEMENTATION.
  METHOD zz_set_business_partner_data.
    DATA bp_ids TYPE SORTED TABLE OF zrp_i_market_order WITH UNIQUE KEY zzBusinessPartnerID.

    DATA filter_conditions TYPE if_rap_query_filter=>tt_name_range_pairs.
    DATA sort_elements TYPE if_rap_query_request=>tt_sort_elements.

    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY MarketOrders
           FIELDS ( zzBusinessPartnerID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

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
          business_data      = DATA(bp_list)
      ).
    ENDIF.

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
ENDCLASS.
