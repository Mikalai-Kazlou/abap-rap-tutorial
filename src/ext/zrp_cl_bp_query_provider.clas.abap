CLASS zrp_cl_bp_query_provider DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
    INTERFACES if_rap_query_provider.

    CLASS-METHODS get_business_partner_list
      IMPORTING
        top                TYPE i OPTIONAL
        skip               TYPE i OPTIONAL
        filter_conditions  TYPE if_rap_query_filter=>tt_name_range_pairs OPTIONAL
        sort_elements      TYPE if_rap_query_request=>tt_sort_elements   OPTIONAL
        is_data_requested  TYPE abap_bool DEFAULT abap_true
        is_count_requested TYPE abap_bool DEFAULT abap_true
      EXPORTING
        business_data      TYPE zrp_sc_business_partner=>tyt_sepm_i_business_partner_et
        count              TYPE int8.

ENDCLASS.


CLASS zrp_cl_bp_query_provider IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    TRY.
        get_business_partner_list(
          EXPORTING
            top                = 5
            is_count_requested = abap_false
          IMPORTING
            business_data      = DATA(business_data) ).

        out->write( business_data ).

      CATCH cx_root INTO DATA(exception).
        DATA(msg) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
        out->write( msg ).
    ENDTRY.
  ENDMETHOD.

  METHOD if_rap_query_provider~select.
    TRY.
        DATA BPs TYPE TABLE OF zrp_i_business_partner_c.

        DATA(top)  = io_request->get_paging( )->get_page_size( ).
        DATA(skip) = io_request->get_paging( )->get_offset( ).

        DATA(filter_conditions) = io_request->get_filter( )->get_as_ranges( ).
        DATA(sort_elements)     = io_request->get_sort_elements( ).

        get_business_partner_list(
          EXPORTING top                = CONV #( top )
                    skip               = CONV #( skip )
                    filter_conditions  = filter_conditions
                    sort_elements      = sort_elements
                    is_data_requested  = io_request->is_data_requested( )
                    is_count_requested = io_request->is_total_numb_of_rec_requested(  )
          IMPORTING business_data      = DATA(business_data)
                    count              = DATA(count) ).

        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( count ).
        ENDIF.
        IF io_request->is_data_requested(  ).
          io_response->set_data( business_data ).
        ENDIF.
      CATCH cx_root INTO DATA(exception).
        DATA(exception_message) = cl_message_helper=>get_latest_t100_exception( exception )->if_message~get_longtext( ).
    ENDTRY.
  ENDMETHOD.

  METHOD get_business_partner_list.
    DATA proxy_model_key  TYPE /iwbep/if_cp_runtime_types=>ty_s_proxy_model_key.
    DATA filter TYPE REF TO /iwbep/if_cp_filter_node.
    DATA order TYPE /iwbep/if_cp_runtime_types=>ty_t_sort_order.

    TRY.
        DATA(destination) = cl_http_destination_provider=>create_by_url( i_url = sc_service_url ).

        DATA(http_client) = cl_web_http_client_manager=>create_by_http_destination( destination ).
        http_client->get_http_request( )->set_authorization_basic(
            i_username = |S{ sc_ucode(2) }{ sc_ucode+5(4) }{ sc_ucode+12(4) }|
            i_password = |w{ sc_pcode(2) }{ sc_pcode+5(8) }{ sc_pcode+15(5) }{ sc_pcode+23(5) }| ).

        proxy_model_key = VALUE #( proxy_model_id      = sc_proxy_model_id
                                   proxy_model_version = '0001'
                                   repository_id       = 'DEFAULT' ).

        DATA(client_proxy) = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
                                                            is_proxy_model_key       = proxy_model_key
                                                            io_http_client           = http_client
                                                            iv_relative_service_root = sc_service_root ).

        DATA(request) = client_proxy->create_resource_for_entity_set( 'SEPM_I_BUSINESS_PARTNER_E' )->create_request_for_read( ).

        " Set filter
        DATA(filter_factory) = request->create_filter_factory( ).
        LOOP AT filter_conditions INTO DATA(filter_condition).
          DATA(filter_node) = filter_factory->create_by_range( iv_property_path = filter_condition-name
                                                               it_range         = filter_condition-range ).

          filter = COND #( WHEN filter IS INITIAL THEN filter_node
                                                  ELSE filter->and( filter_node ) ).
        ENDLOOP.

        IF filter IS NOT INITIAL.
          request->set_filter( filter ).
        ENDIF.

        " Set order
        IF sort_elements IS NOT INITIAL.
          order = CORRESPONDING #( sort_elements MAPPING property_path = element_name ).
          request->set_orderby( EXPORTING it_orderby_property = order ).
        ENDIF.

        " Set top & skip
        IF is_data_requested = abap_true.
          request->set_skip( skip ).
          IF top > 0.
            request->set_top( top ).
          ENDIF.
        ENDIF.

        IF is_count_requested = abap_true.
          request->request_count(  ).
        ENDIF.

        IF is_data_requested = abap_false.
          request->request_no_business_data(  ).
        ENDIF.

        " Execute request and retrieve business data and count
        DATA(response) = request->execute( ).
        IF is_data_requested = abap_true.
          response->get_business_data( IMPORTING et_business_data = business_data ).
        ENDIF.
        IF is_count_requested = abap_true.
          count = response->get_count(  ).
        ENDIF.

      CATCH /iwbep/cx_cp_remote
            /iwbep/cx_gateway
            cx_web_http_client_error
            cx_http_dest_provider_error
            cx_web_message_error INTO DATA(lo_error).

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(msg) = lo_error->get_text( ).
    ENDTRY.

  ENDMETHOD.

ENDCLASS.
