"! <strong>Useful link:</strong> https://help.sap.com/docs/abap-cloud/abap-rap/developing-test-class-for-managed-flight-reference-scenario
"!
CLASS ltcl_unit_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.


  PRIVATE SECTION.
    CLASS-DATA:
      class_under_test     TYPE REF TO lhc_product,
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

    METHODS:
      validate_prod_group_empty    FOR TESTING,
      validate_prod_group_existing FOR TESTING,
      validate_prod_group_missing  FOR TESTING.

ENDCLASS.


CLASS ltcl_unit_tests IMPLEMENTATION.
  METHOD class_setup.
    CREATE OBJECT class_under_test FOR TESTING.
    cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds( i_for_entities = VALUE #( ( i_for_entity = 'ZRP_I_PRODUCT' )
                                                                                                       ( i_for_entity = 'ZRP_I_PRODUCT_GROUP' ) ) ).
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

  METHOD validate_prod_group_empty.
    " Declare required structures
    DATA failed   TYPE RESPONSE FOR FAILED LATE zrp_i_product.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  zrp_i_product.

    " Fill in test data
    DATA product_mock_data TYPE STANDARD TABLE OF zrp_d_product.
    product_mock_data = VALUE #( ( produuid = '99999999999999999999999999999999' pgid = '' ) ).
    cds_test_environment->insert_test_data( product_mock_data ).

    DATA product_group_mock_data TYPE STANDARD TABLE OF zrp_d_prod_group.
    product_group_mock_data = VALUE #( ( pgid = '100' ) ).
    cds_test_environment->insert_test_data( product_group_mock_data ).

    " Call method to be tested
    class_under_test->validate_product_group(
      EXPORTING
        keys     = CORRESPONDING #( product_mock_data MAPPING uuid = produuid )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check for content in failed and reported
    cl_abap_unit_assert=>assert_initial( act = failed
                                         msg = 'lines in failed-product' ).

    cl_abap_unit_assert=>assert_initial( act = reported
                                         msg = 'lines in reported-product' ).
  ENDMETHOD.

  METHOD validate_prod_group_existing.
    " Declare required structures
    DATA failed   TYPE RESPONSE FOR FAILED LATE zrp_i_product.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  zrp_i_product.

    " Fill in test data
    DATA product_mock_data TYPE STANDARD TABLE OF zrp_d_product.
    product_mock_data = VALUE #( ( produuid = '99999999999999999999999999999999' pgid = '100' ) ).
    cds_test_environment->insert_test_data( product_mock_data ).

    DATA product_group_mock_data TYPE STANDARD TABLE OF zrp_d_prod_group.
    product_group_mock_data = VALUE #( ( pgid = '100' ) ).
    cds_test_environment->insert_test_data( product_group_mock_data ).

    " Call method to be tested
    class_under_test->validate_product_group(
      EXPORTING
        keys     = CORRESPONDING #( product_mock_data MAPPING uuid = produuid )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check for content in failed and reported
    cl_abap_unit_assert=>assert_initial( act = failed
                                         msg = 'lines in failed-product' ).

    " Check number of returned instances in reported-product
    cl_abap_unit_assert=>assert_equals( act = lines( reported-product )
                                        exp = 1
                                        msg = 'lines in reported-product' ).

    " Check travel id in reported-product
    cl_abap_unit_assert=>assert_equals( act = reported-product[ 1 ]-uuid
                                        exp = '99999999999999999999999999999999'
                                        msg = 'UUID in reported-product' ).

    " Check marked field in reported-product
    cl_abap_unit_assert=>assert_equals( act = reported-product[ 1 ]-%element-productgroupid
                                        exp = if_abap_behv=>mk-off
                                        msg = 'field Product Group ID in reported-product' ).

    " Check message reference in reported-product
    cl_abap_unit_assert=>assert_not_bound( act = reported-product[ 1 ]-%msg
                                           msg = 'message reference in reported-product' ).
  ENDMETHOD.

  METHOD validate_prod_group_missing.
    " Declare required structures
    DATA failed   TYPE RESPONSE FOR FAILED LATE zrp_i_product.
    DATA reported TYPE RESPONSE FOR REPORTED LATE  zrp_i_product.

    " Fill in test data
    DATA product_mock_data TYPE STANDARD TABLE OF zrp_d_product.
    product_mock_data = VALUE #( ( produuid = '99999999999999999999999999999999' pgid = '999' ) ).
    cds_test_environment->insert_test_data( product_mock_data ).

    DATA product_group_mock_data TYPE STANDARD TABLE OF zrp_d_prod_group.
    product_group_mock_data = VALUE #( ( pgid = '100' ) ).
    cds_test_environment->insert_test_data( product_group_mock_data ).

    " Call method to be tested
    class_under_test->validate_product_group(
      EXPORTING
        keys     = CORRESPONDING #( product_mock_data MAPPING uuid = produuid )
      CHANGING
        failed   = failed
        reported = reported
    ).

    " Check number of returned instances in failed-product
    cl_abap_unit_assert=>assert_equals( act = lines( failed-product )
                                        exp = 1
                                        msg = 'lines in failed-product' ).

    " Check travel id in failed-product
    cl_abap_unit_assert=>assert_equals( act = failed-product[ 1 ]-uuid
                                        exp = '99999999999999999999999999999999'
                                        msg = 'UUID in failed-product' ).

    " Check number of returned instances in reported-product
    cl_abap_unit_assert=>assert_equals( act = lines( reported-product )
                                        exp = 2
                                        msg = 'lines in reported-product' ).

    " Check travel id in reported-product
    cl_abap_unit_assert=>assert_equals( act = reported-product[ 2 ]-uuid
                                        exp = '99999999999999999999999999999999'
                                        msg = 'UUID in reported-product' ).

    " Check marked field in reported-product
    cl_abap_unit_assert=>assert_equals( act = reported-product[ 2 ]-%element-productgroupid
                                        exp = if_abap_behv=>mk-on
                                        msg = 'field Product Group ID in reported-product' ).

    " Check message reference in reported-product
    cl_abap_unit_assert=>assert_bound( act = reported-product[ 2 ]-%msg
                                       msg = 'message reference in reported-product' ).
  ENDMETHOD.
ENDCLASS.
