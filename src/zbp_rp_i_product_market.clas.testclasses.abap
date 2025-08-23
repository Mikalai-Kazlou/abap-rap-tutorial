CLASS ltcl_unit_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_product_market,
      cds_test_environment TYPE REF TO if_cds_test_environment.

    CLASS-METHODS:
      "! Instantiate class under test and setup test double frameworks
      class_setup,

      "! Destroy test environments and test doubles
      class_teardown.

    METHODS:
      "! Reset test doubles
      setup,

      "! Reset transactional buffer
      teardown.

    METHODS test_accept_market FOR TESTING.

ENDCLASS.


CLASS ltcl_unit_tests IMPLEMENTATION.
  METHOD class_setup.
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create( i_for_entity = 'ZRP_I_PRODUCT_MARKET' ).
  ENDMETHOD.

  METHOD class_teardown.
    cds_test_environment->destroy( ).
  ENDMETHOD.

  METHOD setup.
    cds_test_environment->clear_doubles( ).
  ENDMETHOD.

  METHOD teardown.
    ROLLBACK ENTITIES.
  ENDMETHOD.

  METHOD test_accept_market.
    " Declare required table and structures
    DATA result TYPE TABLE FOR ACTION RESULT zrp_i_product\\ProductMarkets~AcceptMarket.

    DATA mapped   TYPE RESPONSE FOR MAPPED   EARLY zrp_i_product.
    DATA failed   TYPE RESPONSE FOR FAILED   EARLY zrp_i_product.
    DATA reported TYPE RESPONSE FOR REPORTED EARLY zrp_i_product.

    DATA exp LIKE result.
    DATA act LIKE result.

    DATA market_mock_data TYPE STANDARD TABLE OF zrp_d_prod_mrkt.

    " Fill in test data
    market_mock_data = VALUE #( ( produuid = '99999999999999999999999999999999' mrktuuid = '11111111111111111111111111111111' status = abap_true )
                                ( produuid = '99999999999999999999999999999999' mrktuuid = '22222222222222222222222222222222' status = abap_false ) ).
    cds_test_environment->insert_test_data( market_mock_data ).

    " Call the method to be tested
    class_under_test->accept_market(
      EXPORTING
        keys     = CORRESPONDING #( market_mock_data MAPPING ProductUUID       = produuid
                                                             ProductMarketUUID = mrktuuid )
      CHANGING
        result   = result
        mapped   = mapped
        failed   = failed
        reported = reported
    ).

    " Check for content in mapped, failed and reported
    cl_abap_unit_assert=>assert_initial( msg = 'mapped' act = mapped ).
    cl_abap_unit_assert=>assert_initial( msg = 'failed' act = failed ).
    cl_abap_unit_assert=>assert_initial( msg = 'reported' act = reported ).

    " Check action result for fields of interest: travel_id, %param-travel_id, %param-overall_status.
    exp = VALUE #( ( ProductUUID        = '99999999999999999999999999999999' ProductMarketUUID        = '11111111111111111111111111111111'
                     %param-ProductUUID = '99999999999999999999999999999999' %param-ProductMarketUUID = '11111111111111111111111111111111' %param-Status = abap_true )
                   ( ProductUUID        = '99999999999999999999999999999999' ProductMarketUUID        = '22222222222222222222222222222222'
                     %param-ProductUUID = '99999999999999999999999999999999' %param-ProductMarketUUID = '22222222222222222222222222222222' %param-Status = abap_true ) ).

    act = CORRESPONDING #( result MAPPING ProductUUID       = ProductUUID
                                          ProductMarketUUID = ProductMarketUUID
                                        ( %param = %param MAPPING ProductUUID       = ProductUUID
                                                                  ProductMarketUUID = ProductMarketUUID
                                                                  Status            = Status
                                                                  EXCEPT * )
                                          EXCEPT * ).

    cl_abap_unit_assert=>assert_equals( msg = 'action result' exp = exp act = act ).

    " Additionally check modified instances
    READ ENTITY zrp_i_product_market
         FIELDS ( ProductUUID ProductMarketUUID Status )
         WITH CORRESPONDING #( market_mock_data MAPPING ProductUUID       = produuid
                                                        ProductMarketUUID = mrktuuid )
         RESULT DATA(read_result).

    act = VALUE #( FOR row IN read_result ( ProductUUID              = row-ProductUUID
                                            ProductMarketUUID        = row-ProductMarketUUID
                                            %param-ProductUUID       = row-ProductUUID
                                            %param-ProductMarketUUID = row-ProductMarketUUID
                                            %param-Status            = row-Status ) ).

    cl_abap_unit_assert=>assert_equals( msg = 'read result' exp = exp act = act ).
  ENDMETHOD.
ENDCLASS.
