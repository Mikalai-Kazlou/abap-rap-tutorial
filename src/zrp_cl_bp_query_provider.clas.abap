CLASS zrp_cl_bp_query_provider DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zrp_cl_bp_query_provider IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lt_business_data   TYPE TABLE OF zrp_sc_business_partner=>tys_sepm_i_business_partner_et.
    DATA ls_proxy_model_key TYPE /iwbep/if_cp_runtime_types=>ty_s_proxy_model_key.

    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_url( i_url = sc_service_url ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( lo_destination ).
        lo_http_client->get_http_request( )->set_authorization_basic(
            i_username = |S{ sc_user(2) }{ sc_user+5(4) }{ sc_user+12(4) }|
            i_password = |w{ sc_pass(2) }{ sc_pass+5(8) }{ sc_pass+15(5) }{ sc_pass+23(5) }| ).

        ls_proxy_model_key = VALUE #( proxy_model_id      = sc_proxy_model_id
                                      proxy_model_version = '0001'
                                      repository_id       = 'DEFAULT' ).

        DATA(lo_client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                                    is_proxy_model_key       = ls_proxy_model_key
                                    io_http_client           = lo_http_client
                                    iv_relative_service_root = sc_service_root ).

        DATA(lo_request) = lo_client_proxy->create_resource_for_entity_set( 'SEPM_I_BUSINESS_PARTNER_E' )->create_request_for_read( ).
        lo_request->set_top( 90 )->set_skip( 0 ).

        DATA(lo_response) = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

      CATCH /iwbep/cx_cp_remote
            /iwbep/cx_gateway
            cx_web_http_client_error
            cx_http_dest_provider_error INTO DATA(lo_error).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(msg) = lo_error->get_text( ).
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
