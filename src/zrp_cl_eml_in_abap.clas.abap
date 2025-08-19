CLASS zrp_cl_eml_in_abap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PRIVATE SECTION.
    DATA out TYPE REF TO if_oo_adt_classrun_out.

    METHODS read.
    METHODS create.

ENDCLASS.

CLASS zrp_cl_eml_in_abap IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    me->out = out.
    "read( ).
    create( ).
  ENDMETHOD.

  METHOD read.
    DATA input TYPE TABLE FOR READ IMPORT zrp_i_product.

    SELECT FROM zrp_i_product
    FIELDS uuid
      INTO TABLE @DATA(products)
        UP TO 5 ROWS.

    input = VALUE #( FOR product IN products ( uuid = product-uuid ) ).

    READ ENTITIES OF zrp_i_product
           ENTITY product
              ALL FIELDS
             WITH input
           RESULT DATA(output).

*     READ ENTITIES OF zrp_i_product
*           ENTITY product
*           FIELDS ( ProductGroupID Price )
*             WITH input
*           RESULT DATA(output).

    out->write( output ).
  ENDMETHOD.

  METHOD create.
    TYPES tt_create_product TYPE TABLE FOR CREATE zrp_i_product\\product.
    TYPES tt_create_market  TYPE TABLE FOR CREATE zrp_i_product\\product\_productmarket.

    TRY.
        DATA(product_cid) = cl_system_uuid=>if_system_uuid_static~create_uuid_c32( ).
      CATCH cx_uuid_error.
    ENDTRY.

    DATA(products) = VALUE tt_create_product( ( %cid              = product_cid
                                                id                = 'New'
                                                Name              = 'New Product'
                                                ProductGroupID    = '1'
                                                PhaseID           = 1
                                                Price             = 100
                                                PriceCurrency     = 'USD'
                                                zzTranslationCode = 'RU' ) ).

    DATA(markets) = VALUE tt_create_market( ( %cid_ref = product_cid
                                              %target  = VALUE #( ( %cid      = 'create_market_1'
                                                                    MarketID  = '1'
                                                                    StartDate = cl_abap_context_info=>get_system_date( ) )
                                                                  ( %cid      = 'create_market_2'
                                                                    MarketID  = '2'
                                                                    StartDate = cl_abap_context_info=>get_system_date( ) ) ) ) ).
    MODIFY ENTITIES OF zrp_i_product
             ENTITY product

             CREATE
             FIELDS ( id
                      Name
                      ProductGroupID
                      PhaseID
                      Price
                      PriceCurrency
                      zzTranslationCode ) WITH products

             CREATE BY \_ProductMarket
             FIELDS ( MarketID
                      StartDate )         WITH markets

             MAPPED DATA(mapped)
             FAILED DATA(failed)
           REPORTED DATA(reported).

    COMMIT ENTITIES RESPONSE OF zrp_i_product
             FAILED DATA(failed_commit)
           REPORTED DATA(reported_commit).

    LOOP AT reported_commit-product INTO DATA(product_commit).
      out->write( product_commit-%msg->if_message~get_longtext( ) ).
    ENDLOOP.
    LOOP AT reported_commit-productmarkets INTO DATA(market_commit).
      out->write( market_commit-%msg->if_message~get_longtext( ) ).
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
