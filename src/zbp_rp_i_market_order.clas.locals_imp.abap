CLASS lhc_market_order DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS recalculate_total_amount FOR MODIFY
      IMPORTING keys FOR ACTION marketorders~recalculatetotalamount.

    METHODS calculate_total_amount FOR DETERMINE ON MODIFY
      IMPORTING keys FOR marketorders~calculatetotalamount.

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
            EXECUTE RecalculateTotalAmount
               FROM CORRESPONDING #( keys )
           REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).
  ENDMETHOD.
ENDCLASS.
