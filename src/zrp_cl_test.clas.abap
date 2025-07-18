CLASS zrp_cl_test DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CLASS-DATA name TYPE string.

    CLASS-METHODS class_constructor.

    METHODS constructor   IMPORTING i_attribute     TYPE i.
    METHODS get_attribute RETURNING VALUE(r_result) TYPE i.
    METHODS set_attribute IMPORTING i_attribute     TYPE i.

  PRIVATE SECTION.
    DATA attribute TYPE i.

ENDCLASS.


CLASS zrp_cl_test IMPLEMENTATION.
  METHOD class_constructor.
    name = `Undefined`.
  ENDMETHOD.

  METHOD constructor.
    attribute = i_attribute.
  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.
    " TODO: variable is assigned but never used (ABAP cleaner)
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

    attribute = 2.
  ENDMETHOD.

  METHOD get_attribute.
    r_result = attribute.
  ENDMETHOD.

  METHOD set_attribute.
    attribute = i_attribute.
  ENDMETHOD.
ENDCLASS.
