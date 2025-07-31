"! <p class="shorttext synchronized" lang="en">Test class</p>
CLASS zrp_cl_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CLASS-DATA name TYPE string.

    CLASS-METHODS class_constructor.

    "! <p class="shorttext synchronized" lang="en"><em>Get</em> attribute</p>
    "! @parameter r_result | <p class="shorttext synchronized" lang="en">Result</p>
    METHODS get_attribute RETURNING VALUE(r_result) TYPE i.

    "! <p class="shorttext synchronized" lang="en"><em>Set</em> attribute</p>
    "! You can add ABAP Doc for a method and its signature using a quick fix. Once you have declared the method, press Ctrl + 1<br/>
    "! to open the possible quick fixes, and choose Add ABAP Doc. The editor then generates the corresponding documentation.
    "! Link: {@link if_oo_adt_classrun}
    "! @parameter i_attribute | <p class="shorttext synchronized" lang="en">Attribute value</p>
    METHODS set_attribute IMPORTING i_attribute     TYPE i.

  PRIVATE SECTION.
    DATA attribute TYPE i.

    METHODS check_string_functions   IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS check_abap_sql_functions IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS check_primitive_code     IMPORTING out TYPE REF TO if_oo_adt_classrun_out.
    METHODS check_internal_tables    IMPORTING out TYPE REF TO if_oo_adt_classrun_out.

ENDCLASS.


CLASS zrp_cl_test IMPLEMENTATION.
  METHOD class_constructor.
    name = `Undefined`.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    "check_primitive_code( out ).
    "check_string_functions( out ).
    "check_abap_sql_functions( out ).
    check_internal_tables( out ).
  ENDMETHOD.

  METHOD get_attribute.
    r_result = attribute.
  ENDMETHOD.

  METHOD set_attribute.
    attribute = i_attribute.
  ENDMETHOD.

  METHOD check_primitive_code.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA numbers TYPE TABLE OF i.
    DATA date_1 TYPE d VALUE '20250101'.
    DATA date_2 TYPE d VALUE '20250131'.

    DATA(a1) = 5 / 10.
    DATA(a2) = date_2 - date_1.

    out->write( TEXT-001 ).
    out->write( 'How are you?'(002) ).

    DO 50 TIMES.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(a) = 1.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(b) = 2.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(c) = 3.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(d) = 4.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(e) = 5.
      " TODO: variable is assigned but never used (ABAP cleaner)
      DATA(f) = 6.

      INSERT sy-index INTO TABLE numbers.

      IF sy-index > 30.
        EXIT.
      ENDIF.
    ENDDO.

    SELECT * FROM zrp_i_product
      INTO TABLE @DATA(products).

    attribute = 2.

  ENDMETHOD.

  METHOD check_string_functions.
    DATA text TYPE string VALUE ` ##SAP BTP,   ABAP Environment  `.

* Change Case of characters
**********************************************************************
    out->write( |TO_UPPER         = {   to_upper(  text ) } | ).
    out->write( |TO_LOWER         = {   to_lower(  text ) } | ).
    out->write( |TO_MIXED         = {   to_mixed(  text ) } | ).
    out->write( |FROM_MIXED       = { from_mixed(  text ) } | ).


* Change order of characters
**********************************************************************
    out->write( |REVERSE             = {  reverse( text ) } | ).
    out->write( |SHIFT_LEFT  (places)= {  shift_left(  val = text places   = 3  ) } | ).
    out->write( |SHIFT_RIGHT (places)= {  shift_right( val = text places   = 3  ) } | ).
    out->write( |SHIFT_LEFT  (circ)  = {  shift_left(  val = text circular = 3  ) } | ).
    out->write( |SHIFT_RIGHT (circ)  = {  shift_right( val = text circular = 3  ) } | ).


* Extract a Substring
**********************************************************************
    out->write( |SUBSTRING       = {  substring(        val = text off = 4 len = 10 ) } | ).
    out->write( |SUBSTRING_FROM  = {  substring_from(   val = text sub = 'ABAP'     ) } | ).
    out->write( |SUBSTRING_AFTER = {  substring_after(  val = text sub = 'ABAP'     ) } | ).
    out->write( |SUBSTRING_TO    = {  substring_to(     val = text sub = 'ABAP'     ) } | ).
    out->write( |SUBSTRING_BEFORE= {  substring_before( val = text sub = 'ABAP'     ) } | ).


* Condense, REPEAT and Segment
**********************************************************************
    out->write( |CONDENSE         = {   condense( val = text ) } | ).
    out->write( |REPEAT           = {   repeat(   val = text occ = 2 ) } | ).

    out->write( |SEGMENT1         = {   segment(  val = text sep = ',' index = 1 ) } |  ).
    out->write( |SEGMENT2         = {   segment(  val = text sep = ',' index = 2 ) } |  ).
  ENDMETHOD.

  METHOD check_abap_sql_functions.
    DATA source_currency TYPE c LENGTH 5 VALUE 'EUR'.
    DATA target_currency TYPE c LENGTH 5 VALUE 'USD'.

    DATA(today) = cl_abap_context_info=>get_system_date( ).

    SELECT SINGLE
      FROM zrp_i_product
    FIELDS currency_conversion(
             amount             = CAST( 1000 AS DEC( 15, 2 ) ),
             source_currency    = @source_currency,
             target_currency    = @target_currency,
             exchange_rate_date = @today,
             on_error           = @sql_currency_conversion=>c_on_error-set_to_null ) AS price,

             left(      'Text', 1 )    AS left,
             substring( 'Text', 1, 1 ) AS substring,

             @( substring( val = 'Text' off = 0 len = 1 ) ) AS substring_abap

      INTO @DATA(converted_price).

    out->write( converted_price ).
  ENDMETHOD.

  METHOD check_internal_tables.
    TYPES: BEGIN OF ts_table,
             col1 TYPE c LENGTH 5,
             col2 TYPE n LENGTH 5,
             col3 TYPE i,
           END OF ts_table.
    TYPES: tt_table TYPE STANDARD TABLE OF ts_table WITH NON-UNIQUE KEY col1.

    DATA itab TYPE tt_table.
    DATA itab_reduce TYPE tt_table.
    DATA itab_keys TYPE SORTED TABLE OF ts_table WITH NON-UNIQUE KEY col1 col2
                                                 WITH NON-UNIQUE SORTED KEY sk_sorted COMPONENTS col2.

    itab = VALUE #( ( col1 = '1' col2 = '11' col3 = 1 )
                    ( col1 = '2' col2 = '22' col3 = 2 )
                    ( col1 = '4' col2 = '44' col3 = 4 )
                    ( col1 = '4' col2 = '44' col3 = 4 )
                    ( col1 = '2' col2 = '22' col3 = 3 ) ).
    SORT itab.
    DELETE ADJACENT DUPLICATES FROM itab. "COMPARING ALL FIELDS.
    out->write( itab ).

    itab_reduce = REDUCE #( INIT it_reduce TYPE tt_table
                                 count = 1
                             FOR <line> IN itab WHERE ( col3 < 3 )
                             LET key = <line>-col1 && <line>-col2 IN
                            NEXT it_reduce = VALUE #( BASE it_reduce ( <line> ) )
                                 count += 1
                          ).

    out->write( itab_reduce ).
  ENDMETHOD.

ENDCLASS.
