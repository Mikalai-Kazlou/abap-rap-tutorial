CLASS zbp_rp_i_product_market DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zrp_i_product.
  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF market_statuses,
        accepted TYPE abap_bool VALUE abap_true,
        rejected TYPE abap_bool VALUE abap_false,
      END OF market_statuses.

    TYPES ts_rr_market TYPE STRUCTURE FOR READ RESULT zrp_i_product\\product\_productmarket.

    CLASS-METHODS is_market_finished
      IMPORTING market        TYPE ts_rr_market
      RETURNING VALUE(result) TYPE abap_bool.

ENDCLASS.

CLASS zbp_rp_i_product_market IMPLEMENTATION.
  METHOD is_market_finished.
    DATA(today) = cl_abap_context_info=>get_system_date( ).
    result = xsdbool( market-enddate <= today ).
  ENDMETHOD.
ENDCLASS.
