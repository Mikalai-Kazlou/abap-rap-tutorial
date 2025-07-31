CLASS lhc_zr_rp_product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING
        REQUEST requested_authorizations FOR Product RESULT result.

    METHODS checks_semantic_keys FOR VALIDATE ON SAVE
      IMPORTING keys FOR Product~checkSemanticKeys.

ENDCLASS.


CLASS lhc_zr_rp_product IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD checks_semantic_keys.
    READ ENTITIES OF zr_rp_product IN LOCAL MODE
           ENTITY Product
           FIELDS ( Uuid Id )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).
      " Clear state messages that might exist
      APPEND VALUE #( %tky        = <product>-%tky
                      %state_area = 'checkSemanticKeys' ) TO reported-product.

      SELECT FROM zrpaproduct
      FIELDS uuid
       WHERE id = @<product>-id
         AND uuid <> @<product>-uuid

      UNION ALL

      SELECT FROM zrpdproduct
      FIELDS uuid
       WHERE id = @<product>-id
         AND uuid <> @<product>-uuid

      INTO TABLE @DATA(products_db).

      IF products_db IS NOT INITIAL.
        DATA(msg) = new_message_with_text( severity = if_abap_behv_message=>severity-error
                                           text     = `The Product ID already exists` ).

        INSERT VALUE #( %tky        = <product>-%tky
                        %state_area = 'checkSemanticKeys'
                        %msg        = msg
                        %element-id = if_abap_behv=>mk-on ) INTO TABLE reported-product.

        INSERT VALUE #( %tky = <product>-%tky ) INTO TABLE failed-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
