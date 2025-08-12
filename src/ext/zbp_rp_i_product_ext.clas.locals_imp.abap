CLASS lhc_product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR Product RESULT result.

    METHODS zz_set_pg_name_translation FOR DETERMINE ON SAVE
      IMPORTING keys FOR Product~zzSetPGNameTranslation.

    METHODS zz_get_pg_name_translation FOR MODIFY
      IMPORTING keys FOR ACTION Product~zzGetPGNameTranslation.

ENDCLASS.

CLASS lhc_product IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD zz_set_pg_name_translation.
    DATA product_group_ids TYPE SORTED TABLE OF zrp_i_product_group WITH UNIQUE KEY ProductGroupID.

    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( ProductGroupID zzTranslationCode )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Optimization of DB select: extract distinct non-initial product group IDs
    product_group_ids = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING ProductGroupID = ProductGroupID EXCEPT * ).
    DELETE product_group_ids WHERE ProductGroupID IS INITIAL.

    IF product_group_ids IS NOT INITIAL.
      " Select product groups
      SELECT FROM zrp_i_product_group
      FIELDS ProductGroupID,
             ProductGroupName
         FOR ALL ENTRIES IN @product_group_ids
       WHERE ProductGroupID = @product_group_ids-ProductGroupID
        INTO TABLE @DATA(product_groups_db).
    ENDIF.

    " Set new values
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY product
             UPDATE
             FIELDS ( zzProductGroupNameTranslated )
               WITH VALUE #( FOR product IN products
                             LET ProductGroupName = VALUE #( product_groups_db[ ProductGroupID = product-ProductGroupID ]-ProductGroupName OPTIONAL )
                              IN ( %tky = product-%tky
                                   zzProductGroupNameTranslated =
                                     zrp_cl_yandex_translation=>translate( lang_code_to = product-zzTranslationCode
                                                                           text         = CONV #( ProductGroupName ) ) ) )
           REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD zz_get_pg_name_translation.
    DATA product_group_ids TYPE SORTED TABLE OF zrp_i_product_group WITH UNIQUE KEY ProductGroupID.

    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( ProductGroupID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Optimization of DB select: extract distinct non-initial product group IDs
    product_group_ids = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING ProductGroupID = ProductGroupID EXCEPT * ).
    DELETE product_group_ids WHERE ProductGroupID IS INITIAL.

    IF product_group_ids IS NOT INITIAL.
      " Select product groups
      SELECT FROM zrp_i_product_group
      FIELDS ProductGroupID,
             ProductGroupName
         FOR ALL ENTRIES IN @product_group_ids
       WHERE ProductGroupID = @product_group_ids-ProductGroupID
        INTO TABLE @DATA(product_groups_db).
    ENDIF.

    SELECT FROM zrp_i_translation_language
    FIELDS LanguageCode
      INTO TABLE @DATA(language_codes).

    LOOP AT products INTO DATA(product).
      DATA(product_group_name) = VALUE #( product_groups_db[ ProductGroupID = product-ProductGroupID ]-ProductGroupName OPTIONAL ).

      LOOP AT language_codes ASSIGNING FIELD-SYMBOL(<language_code>).
        DATA(translated_text) = zrp_cl_yandex_translation=>translate( lang_code_to = <language_code>-LanguageCode
                                                                      text         = CONV #( product_group_name ) ).
        IF translated_text IS NOT INITIAL.
          DATA(msg) = new_message( id       = 'ZRP_MSG'
                                   number   = '013'
                                   severity = if_abap_behv_message=>severity-information
                                   v1       = <language_code>-LanguageCode
                                   v2       = translated_text ).

          INSERT VALUE #( %tky = product-%tky
                          %msg = msg ) INTO TABLE reported-product.
        ENDIF.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
