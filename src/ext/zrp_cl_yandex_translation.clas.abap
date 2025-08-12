CLASS zrp_cl_yandex_translation DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    CLASS-METHODS translate
      IMPORTING lang_code_from TYPE zrp_lang_code DEFAULT 'en'
                lang_code_to   TYPE zrp_lang_code DEFAULT 'ru'
                text           TYPE string
      RETURNING VALUE(result)  TYPE string.

ENDCLASS.

CLASS zrp_cl_yandex_translation IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    out->write( translate( text = 'Blender' ) ).
  ENDMETHOD.

  METHOD translate.
    DATA json TYPE ts_json.

    DATA(lang_code) = |{ to_lower( lang_code_from ) }-{ to_lower( lang_code_to ) }|.
    DATA(url) = escape( val = |{ base_url }?key={ service_key }&lang={ lang_code }&text={ text }| format = cl_abap_format=>e_url ).

    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_url( url ).
        DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( destination ).

        DATA(request)  = http_client->get_http_request( ).
        DATA(response) = http_client->execute( i_method = if_web_http_client=>get ).

        /ui2/cl_json=>deserialize(
          EXPORTING
            json         = response->get_text( )
            pretty_name  = /ui2/cl_json=>pretty_mode-camel_case
            assoc_arrays = abap_true
          CHANGING
            data         = json ).

      CATCH cx_web_http_client_error
            cx_http_dest_provider_error INTO DATA(error).
        DATA(msg) = error->get_longtext( ).
    ENDTRY.

    CHECK json IS NOT INITIAL.

    TRY.
        result = json-def[ 1 ]-tr[ 1 ]-text.
        result = to_upper( substring( val = result len = 1 ) ) && shift_left( val = result places = 1 ).
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
