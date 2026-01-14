"! <p class="shorttext synchronized" lang="en">Console application</p>
CLASS zrp_cl_console_application DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    "! <p class="shorttext synchronized" lang="en">Get attribute</p>
    "!
    "! You can add ABAP Doc for a method and its signature using a quick fix. Once you have declared the method, press <strong>Ctrl + 1</strong><br/>
    "! to open the possible quick fixes, and choose Add ABAP Doc. The editor then generates the corresponding documentation.<br/>
    "! <h2>Links to:</h2>
    "! <ul>
    "!  <li>interface: {@link if_oo_adt_classrun}</li>
    "!  <li>method: {@link .METH:print_separator}</li>
    "!  <li>data: {@link .DATA:out}</li>
    "! </ul>
    "!
    "! @parameter r_result | <p class="shorttext" lang="en">Returning value</p>
    "!
    METHODS get_attribute RETURNING VALUE(r_result) TYPE i.

    "! <p class="shorttext synchronized" lang="en">Set attribute</p>
    "!
    "! You can add ABAP Doc for a method and its signature using a quick fix. Once you have declared the method, press <strong>Ctrl + 1</strong><br/>
    "! to open the possible quick fixes, and choose Add ABAP Doc. The editor then generates the corresponding documentation.<br/>
    "! Link: {@link if_oo_adt_classrun}
    "!
    "! @parameter i_input | <p class="shorttext" lang="en">Input value</p>
    "!
    METHODS set_attribute IMPORTING i_input TYPE i.

  PRIVATE SECTION.
    DATA out TYPE REF TO if_oo_adt_classrun_out.

    METHODS check_soap_service.
    METHODS check_primitive_code.
    METHODS check_string_functions.
    METHODS check_abap_sql_functions.
    METHODS check_internal_tables.
    METHODS check_utclong.
    METHODS check_conversions.

    METHODS print_separator.

ENDCLASS.

CLASS zrp_cl_console_application IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    me->out = out.

    out->write( 'Exercises:'(001) ).
    print_separator( ).

    check_soap_service( ).
    print_separator( ).

    check_primitive_code( ).
    print_separator( ).

    check_string_functions( ).
    print_separator( ).

    check_abap_sql_functions( ).
    print_separator( ).

    check_internal_tables( ).
    print_separator( ).

    check_utclong( ).
    print_separator( ).

    check_conversions( ).
    print_separator( ).

  ENDMETHOD.

  METHOD check_soap_service.
    TRY.
        DATA(destination) = cl_soap_destination_provider=>create_by_url( i_url = `http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso` ).

        DATA(proxy) = NEW zrp_sc_co_country_info_service( destination = destination ).
        proxy->country_isocode( EXPORTING input  = VALUE #( s_country_name = 'Japan' )
                                IMPORTING output = DATA(response) ).

        DATA(iso_code) = response-country_isocode_result.
        out->write( iso_code ).

      CATCH cx_ai_system_fault
            cx_soap_destination_error INTO DATA(exception).
        DATA(message) = exception->if_message~get_text( ).
    ENDTRY.
  ENDMETHOD.

  METHOD check_primitive_code.
    DATA numbers TYPE TABLE OF i.

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

    out->write( |23 DIV 4 = { 23 DIV 4 }| ).
    out->write( |23 MOD 4 = { 23 MOD 4 }| ).
    print_separator( ).

    SELECT FROM zrp_i_product
    FIELDS *
      INTO TABLE @DATA(products).

    TYPES:
      BEGIN OF ts_average_price,
        price_sum TYPE zrp_i_product-price,
        price_avg TYPE zrp_i_product-price,
      END OF ts_average_price.

    DATA average_price TYPE ts_average_price.
    average_price = REDUCE #( INIT avg_price TYPE ts_average_price
                                   count = 1
                               FOR product IN products
                              NEXT avg_price-price_sum = avg_price-price_sum + product-price
                                   avg_price-price_avg = avg_price-price_sum / count
                                   count += 1 ).
    out->write( average_price ).
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

             left( 'Text', 1 )                              AS left_sql,
             substring( 'Text', 1, 1 )                      AS substring_sql,
             @( substring( val = 'Text' off = 0 len = 1 ) ) AS substring_abap

      INTO @DATA(converted_price).

    out->write( converted_price ).
  ENDMETHOD.

  METHOD check_internal_tables.
    TYPES: BEGIN OF ts_table,
             col1 TYPE c LENGTH 5,
             col2 TYPE n LENGTH 5,
             col3 TYPE i,
             col4 TYPE i,
           END OF ts_table.
    TYPES: tt_table TYPE STANDARD TABLE OF ts_table WITH NON-UNIQUE KEY col1.

    DATA itab TYPE tt_table.
    DATA itab_search TYPE tt_table.
    DATA itab_keys TYPE SORTED TABLE OF ts_table WITH NON-UNIQUE KEY col1 col2
                                                 WITH NON-UNIQUE SORTED KEY sk_sorted COMPONENTS col2
                                                 WITH     UNIQUE HASHED KEY sk_hashed COMPONENTS col4.

    itab = VALUE #( ( col1 = '1' col2 = '11' col3 = 1 col4 = 10 )
                    ( col1 = '2' col2 = '22' col3 = 2 col4 = 20 )
                    ( col1 = '4' col2 = '44' col3 = 4 col4 = 30 )
                    ( col1 = '4' col2 = '44' col3 = 4 col4 = 40 )
                    ( col1 = '2' col2 = '22' col3 = 3 col4 = 50 ) ).
    SORT itab.
    DELETE ADJACENT DUPLICATES FROM itab. "COMPARING ALL FIELDS.
    out->write( itab ).
    print_separator( ).

    itab_keys = itab.
    IF line_exists( itab_keys[ KEY sk_hashed COMPONENTS col4 = 30 ] ).
      out->write( `The line is found` ).
    ENDIF.
    print_separator( ).

    itab_search = VALUE #( FOR <key> IN itab_keys
                           USING KEY sk_sorted
                           WHERE ( col2 = '44' )
                           ( <key> ) ).

    out->write( itab_search ).
  ENDMETHOD.

  METHOD check_string_functions.
    DATA text TYPE string VALUE ` ##SAP BTP,   ABAP Environment  `.
    out->write( |INITIAL              = { text } | ).

* Change Case of characters
**********************************************************************
    out->write( |TO_UPPER             = {   to_upper( text ) }| ).
    out->write( |TO_LOWER             = {   to_lower( text ) }| ).
    out->write( |TO_MIXED             = {   to_mixed( text ) }| ).
    out->write( |FROM_MIXED           = { from_mixed( text ) }| ).


* Change order of characters
**********************************************************************
    out->write( |REVERSE              = { reverse( text ) }| ).
    out->write( |SHIFT_LEFT  (places) = { shift_left(  val = text places   = 3 ) }| ).
    out->write( |SHIFT_RIGHT (places) = { shift_right( val = text places   = 3 ) }| ).
    out->write( |SHIFT_LEFT  (circ)   = { shift_left(  val = text circular = 3 ) }| ).
    out->write( |SHIFT_RIGHT (circ)   = { shift_right( val = text circular = 3 ) }| ).


* Extract a Substring
**********************************************************************
    out->write( |SUBSTRING            = { substring(        val = text off = 4 len = 10 ) }| ).
    out->write( |SUBSTRING_FROM       = { substring_from(   val = text sub = 'ABAP'     ) }| ).
    out->write( |SUBSTRING_AFTER      = { substring_after(  val = text sub = 'ABAP'     ) }| ).
    out->write( |SUBSTRING_TO         = { substring_to(     val = text sub = 'ABAP'     ) }| ).
    out->write( |SUBSTRING_BEFORE     = { substring_before( val = text sub = 'ABAP'     ) }| ).


* Condense, REPEAT and Segment
**********************************************************************
    out->write( |CONDENSE             = { condense( val = text ) }| ).
    out->write( |REPEAT               = { repeat(   val = text occ = 2 ) }| ).

    out->write( |SEGMENT1             = { segment(  val = text sep = ',' index = 1 ) }| ).
    out->write( |SEGMENT2             = { segment(  val = text sep = ',' index = 2 ) }| ).
  ENDMETHOD.

  METHOD check_utclong.
    DATA timestamp1 TYPE utclong.
    DATA timestamp2 TYPE utclong.
    DATA difference TYPE decfloat34.

    DATA date_user TYPE d.
    DATA time_user TYPE t.

    timestamp1 = utclong_current( ).
    out->write( |Current UTC time { timestamp1 }| ).

    timestamp2 = utclong_add( val = timestamp1 days = 7 hours = 2 minutes = 56 ).
    out->write( |Added 7 days to current UTC time { timestamp2 }| ).

    difference = utclong_diff( high = timestamp2 low = timestamp1 ).
    out->write( |Difference between timestamps in seconds: { difference }| ).
    out->write( |Difference between timestamps in days: { difference / 3600 / 24 }| ).

    TRY.
        CONVERT UTCLONG utclong_current( )
           INTO DATE date_user
                TIME time_user
                TIME ZONE cl_abap_context_info=>get_user_time_zone( ).
      CATCH cx_abap_context_info_error.
        out->write( `Conversion error!` ).
    ENDTRY.

    out->write( |UTC timestamp split into date (type D) and time (type T )| ).
    out->write( |according to the user's time zone (cl_abap_context_info=>get_user_time_zone( ) ).| ).
    out->write( |{ date_user DATE = USER }, { time_user TIME = USER }| ).

    TRY.
        CONVERT DATE cl_abap_context_info=>get_system_date( )
                TIME cl_abap_context_info=>get_system_time( )
                TIME ZONE cl_abap_context_info=>get_user_time_zone( )
           INTO UTCLONG DATA(timestamp).
      CATCH cx_abap_context_info_error.
        out->write( `Conversion error!` ).
    ENDTRY.

    out->write( |Converted current UTC time { timestamp }| ).
  ENDMETHOD.

  METHOD check_conversions.
    DATA date    TYPE d.
    DATA numbers TYPE n LENGTH 10.
    DATA chars   TYPE c LENGTH 10.

    chars = '4F55HJ4K'.
    numbers = chars. "0000004554 - only numbers in the result
    out->write( numbers ).

    DATA(str_date) = `01.01.2025`.
    TRY.
        date = EXACT #( |{ str_date+6(4) }{ str_date+3(2) }{ str_date(2) }| ).
        out->write( date ).
      CATCH cx_sy_conversion_error.
        out->write( `Conversion error!` ).
    ENDTRY.

    TRY.
        date = EXACT #( '20221232' ).
      CATCH cx_sy_conversion_error.
        out->write( |2022-12-32 is not a valid date. EXACT triggered an exception| ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_attribute.
  ENDMETHOD.

  METHOD set_attribute.
  ENDMETHOD.

  METHOD print_separator.
    out->write( `-----------------------------` ).
  ENDMETHOD.
ENDCLASS.
