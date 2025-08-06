CLASS lhc_market_order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS set_order_id FOR DETERMINE ON SAVE
      IMPORTING keys FOR marketorders~setorderid.

    METHODS set_calendar_year FOR DETERMINE ON MODIFY
      IMPORTING keys FOR marketorders~setcalendaryear.

    METHODS recalculate_total_amount FOR MODIFY
      IMPORTING keys FOR ACTION marketorders~recalculatetotalamount.

    METHODS calculate_total_amount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR marketorders~calculatetotalamount.

    METHODS validate_delivery_date FOR VALIDATE ON SAVE
      IMPORTING keys FOR marketorders~validatedeliverydate.

ENDCLASS.

CLASS lhc_market_order IMPLEMENTATION.
  METHOD set_order_id.
    DATA market_order TYPE STRUCTURE FOR READ RESULT zrp_i_market_order.
    DATA max_id TYPE zrp_i_market_order-OrderID.

    READ ENTITIES OF zrp_i_product IN LOCAL MODE

           ENTITY ProductMarkets BY \_MarketOrder
           FIELDS ( OrderID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders_all)

           ENTITY MarketOrders
           FIELDS ( OrderID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

    IF market_orders_all IS NOT INITIAL.
      SORT market_orders_all BY orderid DESCENDING.
      max_id = market_orders_all[ 1 ]-OrderID.
    ENDIF.

    LOOP AT market_orders ASSIGNING FIELD-SYMBOL(<market_order>).
      <market_order>-OrderID = max_id + 1.
      max_id = <market_order>-OrderID.
    ENDLOOP.

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY MarketOrders
             UPDATE
             FIELDS ( OrderID )
               WITH VALUE #( FOR order IN market_orders
                               ( %tky    = order-%tky
                                 OrderID = order-OrderID ) )
           REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD set_calendar_year.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY MarketOrders
           FIELDS ( DeliveryDate )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

    LOOP AT market_orders ASSIGNING FIELD-SYMBOL(<market_order>).
      <market_order>-CalendarYear = <market_order>-DeliveryDate(4).
    ENDLOOP.

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY MarketOrders
             UPDATE
             FIELDS ( CalendarYear )
               WITH VALUE #( FOR order IN market_orders
                               ( %tky         = order-%tky
                                 CalendarYear = order-CalendarYear ) )
           REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

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
            EXECUTE RecalculateTotalAmount
               FROM CORRESPONDING #( keys )
           REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.

  METHOD validate_delivery_date.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE

           ENTITY MarketOrders BY \_ProductMarket
           FIELDS ( StartDate EndDate )
             WITH CORRESPONDING #( keys )
           RESULT DATA(product_markets)

           ENTITY MarketOrders
           FIELDS ( DeliveryDate )
             WITH CORRESPONDING #( keys )
           RESULT DATA(market_orders).

    LOOP AT market_orders ASSIGNING FIELD-SYMBOL(<market_orders>).
      INSERT VALUE #( %tky        = <market_orders>-%tky
                      %state_area = 'validateDeliveryDate' ) INTO TABLE reported-marketorders.

      DATA(product_market) = VALUE #( product_markets[ KEY id COMPONENTS %is_draft         = <market_orders>-%is_draft
                                                                         ProductUUID       = <market_orders>-ProductUUID
                                                                         ProductMarketUUID = <market_orders>-ProductMarketUUID ] OPTIONAL ).
      MESSAGE e011(zrp_msg) INTO DATA(msg).
      DATA(is_delivery_date_valid) = xsdbool( <market_orders>-DeliveryDate > product_market-StartDate ).

      IF product_market-EndDate IS NOT INITIAL.
        MESSAGE e012(zrp_msg) INTO msg.
        is_delivery_date_valid = xsdbool( is_delivery_date_valid = abap_true
                                          AND <market_orders>-DeliveryDate <= product_market-EndDate ).
      ENDIF.

      IF is_delivery_date_valid = abap_false.
        INSERT VALUE #( %tky                  = <market_orders>-%tky
                        %state_area           = 'validateDeliveryDate'
                        %element-DeliveryDate = if_abap_behv=>mk-on
                        %msg                  = new_message_with_text( text = msg )
                        %path                 = VALUE #( product        = CORRESPONDING #( <market_orders>-%tky MAPPING uuid = ProductUUID )
                                                         productmarkets = CORRESPONDING #( <market_orders>-%tky MAPPING productuuid       = ProductUUID
                                                                                                                        productmarketuuid = ProductMarketUUID ) )
                      ) INTO TABLE reported-marketorders.

        INSERT VALUE #( %tky = <market_orders>-%tky ) INTO TABLE failed-marketorders.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
