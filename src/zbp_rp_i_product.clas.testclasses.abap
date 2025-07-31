CLASS ltcl_unit_tests DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    METHODS:
      _main_test FOR TESTING RAISING cx_static_check.
ENDCLASS.


CLASS ltcl_unit_tests IMPLEMENTATION.

  METHOD _main_test.
    cl_abap_unit_assert=>skip( 'Implement your test here' ).
  ENDMETHOD.

ENDCLASS.
