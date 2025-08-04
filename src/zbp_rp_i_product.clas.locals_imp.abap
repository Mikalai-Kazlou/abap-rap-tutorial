CLASS lhc_product DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR product RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR product RESULT result.

    METHODS set_initial_phase FOR DETERMINE ON SAVE
      IMPORTING keys FOR product~setinitialphase.

    METHODS validate_product_id FOR VALIDATE ON SAVE
      IMPORTING keys FOR product~validateproductid.

    METHODS validate_product_group FOR VALIDATE ON SAVE
      IMPORTING keys FOR product~validateproductgroup.

    METHODS copy_product FOR MODIFY
      IMPORTING keys FOR ACTION product~copyproduct RESULT result.

    METHODS move_to_next_phase FOR MODIFY
      IMPORTING keys FOR ACTION product~movetonextphase RESULT result.

    METHODS get_next_phase
      IMPORTING VALUE(curr_phase) TYPE zrp_i_phase-phaseid
      RETURNING VALUE(next_phase) TYPE zrp_i_phase-phaseid.

    METHODS set_next_phase_for_products
      CHANGING products TYPE tt_rr_product
               reported TYPE tt_re_product
               failed   TYPE tt_fe_product.

    METHODS is_not_valid_phase
      IMPORTING product       TYPE ts_rr_product
      CHANGING  reported      TYPE tt_re_product
                failed        TYPE tt_fe_product
      RETURNING VALUE(result) TYPE abap_bool.

ENDCLASS.

INTERFACE lif_phase_validator.
  METHODS is_not_valid
    IMPORTING product       TYPE ts_rr_product
    CHANGING  reported      TYPE tt_re_product
              failed        TYPE tt_fe_product
    RETURNING VALUE(result) TYPE abap_bool.
ENDINTERFACE.

CLASS lcl_phase_validator DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS factory
      IMPORTING phase            TYPE zrp_i_phase-phaseid
      RETURNING VALUE(validator) TYPE REF TO lif_phase_validator.
ENDCLASS.

CLASS lcl_phase_validator_dev DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_phase_validator.
ENDCLASS.

CLASS lcl_phase_validator_prd DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_phase_validator.
ENDCLASS.

CLASS lcl_phase_validator_out DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_phase_validator.
ENDCLASS.

CLASS lcl_phase_validator_default DEFINITION.
  PUBLIC SECTION.
    INTERFACES lif_phase_validator.
ENDCLASS.

CLASS lhc_product IMPLEMENTATION.
  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD set_initial_phase.
    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( phaseid )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Remove all product instance data with defined phase
    DELETE products WHERE phaseid IS NOT INITIAL.
    IF products IS INITIAL.
      RETURN.
    ENDIF.

    " Set default phase
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY product
             UPDATE
             FIELDS ( phaseid )
               WITH VALUE #( FOR product IN products
                               ( %tky    = product-%tky
                                 phaseid = phases-planning ) )
           REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).
  ENDMETHOD.

  METHOD validate_product_id.
    DATA product_ids TYPE SORTED TABLE OF zrp_d_product WITH UNIQUE KEY prodid.

    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( uuid id )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Optimization of DB select: extract distinct non-initial product IDs
    product_ids = CORRESPONDING #( products DISCARDING DUPLICATES MAPPING prodid = id EXCEPT * ).
    DELETE product_ids WHERE prodid IS INITIAL.

    IF product_ids IS NOT INITIAL.
      " Check if product ID exist
      SELECT FROM zrp_d_product
      FIELDS produuid,
             prodid
         FOR ALL ENTRIES IN @product_ids
       WHERE prodid = @product_ids-prodid
        INTO TABLE @DATA(products_db).
    ENDIF.

    " Raise message for existing Product ID
    LOOP AT products INTO DATA(product).
      " Clear state messages that might exist
      INSERT VALUE #( %tky        = product-%tky
                      %state_area = 'validateProductID' ) INTO TABLE reported-product.

      IF product-id IS NOT INITIAL.
        DATA(existing_product_uuid) = VALUE #( products_db[ prodid = product-id ]-produuid OPTIONAL ).

        IF existing_product_uuid <> product-uuid.
          INSERT VALUE #( %tky        = product-%tky
                          %state_area = 'validateProductID'
                          %element-id = if_abap_behv=>mk-on
                          %msg        = NEW zcm_rp_messages( severity   = if_abap_behv_message=>severity-error
                                                             textid     = zcm_rp_messages=>product_already_exists
                                                             product_id = product-id ) ) INTO TABLE reported-product.

          INSERT VALUE #( %tky = product-%tky ) INTO TABLE failed-product.
        ENDIF.

        CLEAR existing_product_uuid.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD validate_product_group.
    DATA product_group_ids TYPE RANGE OF zrp_pg_id.

    " Read relevant product instance data
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( ProductGroupID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    " Optimization of DB select: extract distinct non-initial product IDs
    product_group_ids = VALUE #( FOR product IN products
                                   WHERE ( ProductGroupID IS NOT INITIAL )
                                     ( sign = 'I' option = 'EQ' low = product-ProductGroupID ) ).

    IF product_group_ids IS INITIAL.
      RETURN.
    ENDIF.

    " Check if product group ID exist
    SELECT FROM zrp_i_product_group
    FIELDS ProductGroupID
     WHERE ProductGroupID IN @product_group_ids
      INTO TABLE @DATA(product_groups_db).

    " Raise message if Product Group ID is not exist
    LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).
      " Clear state messages that might exist
      APPEND VALUE #( %tky        = <product>-%tky
                      %state_area = 'validateProductGroupID' ) TO reported-product.

      IF <product>-ProductGroupID IS NOT INITIAL
        AND NOT line_exists( product_groups_db[ ProductGroupID = <product>-ProductGroupID ] ).

        DATA(msg) = new_message( id       = 'ZRP_MSG'
                                 number   = '002'
                                 severity = if_abap_behv_message=>severity-error
                                 v1       = <product>-ProductGroupID ).

        INSERT VALUE #( %tky                    = <product>-%tky
                        %state_area             = 'validateProductGroupID'
                        %element-productgroupid = if_abap_behv=>mk-on
                        %msg                    = msg ) INTO TABLE reported-product.

        INSERT VALUE #( %tky = <product>-%tky ) INTO TABLE failed-product.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD copy_product.
    DATA new_products TYPE TABLE FOR CREATE zrp_i_product.

    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
              ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).
      <product>-id      = keys[ KEY id COMPONENTS %tky = <product>-%tky ]-%param-productid.
      <product>-phaseid = phases-planning.
    ENDLOOP.

    new_products = CORRESPONDING #( products EXCEPT uuid createdby createdon changedby changedon ).

    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY product
             CREATE
               AUTO FILL CID
                SET FIELDS WITH new_products
             MAPPED mapped
             FAILED failed
           REPORTED reported.

    READ ENTITY IN LOCAL MODE zrp_i_product
            ALL FIELDS
           WITH CORRESPONDING #( mapped-product )
         RESULT DATA(products_db)
         FAILED failed.

    result = VALUE #( FOR <product_db> IN products_db INDEX INTO index
                        ( %cid_ref = keys[ index ]-%cid_ref
                          %tky     = keys[ index ]-%tky
                          %param   = CORRESPONDING #( <product_db> ) ) ).
  ENDMETHOD.

  METHOD move_to_next_phase.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
           FIELDS ( PhaseID )
             WITH CORRESPONDING #( keys )
           RESULT DATA(products).

    set_next_phase_for_products( CHANGING products = products
                                          failed   = failed-product
                                          reported = reported-product ).

    DELETE products WHERE PhaseID IS INITIAL.

    " Set the new Phase ID
    MODIFY ENTITIES OF zrp_i_product IN LOCAL MODE
             ENTITY product
             UPDATE
             FIELDS ( PhaseID )
               WITH VALUE #( FOR product IN products
                               ( %tky    = product-%tky
                                 PhaseID = product-PhaseID ) )
             FAILED DATA(failed_update)
           REPORTED DATA(reported_update).

    INSERT LINES OF failed_update-product   INTO TABLE failed-product.
    INSERT LINES OF reported_update-product INTO TABLE reported-product.

    " Fill the response table
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY product
              ALL FIELDS
             WITH CORRESPONDING #( keys )
           RESULT products.

    result = VALUE #( FOR product IN products
                        ( %tky   = product-%tky
                          %param = CORRESPONDING #( product ) ) ).
  ENDMETHOD.

  METHOD get_next_phase.
    next_phase = SWITCH #( curr_phase WHEN phases-planning    THEN phases-development
                                      WHEN phases-development THEN phases-production
                                      WHEN phases-production  THEN phases-out
                                      WHEN phases-out         THEN phases-planning ). "for reverse action
  ENDMETHOD.

  METHOD set_next_phase_for_products.
    LOOP AT products ASSIGNING FIELD-SYMBOL(<product>).
      <product>-PhaseID = get_next_phase( <product>-PhaseID ).

      IF is_not_valid_phase( EXPORTING product  = <product>
                              CHANGING reported = reported
                                       failed   = failed ).
        CLEAR <product>-PhaseID.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD is_not_valid_phase.
    DATA(validator) = lcl_phase_validator=>factory( product-PhaseID ).
    result = validator->is_not_valid( EXPORTING product  = product
                                       CHANGING reported = reported
                                                failed   = failed ).
  ENDMETHOD.
ENDCLASS.

CLASS lcl_phase_validator IMPLEMENTATION.
  METHOD factory.
    CASE phase.
      WHEN phases-development. validator = NEW lcl_phase_validator_dev( ).
      WHEN phases-production.  validator = NEW lcl_phase_validator_prd( ).
      WHEN phases-out.         validator = NEW lcl_phase_validator_out( ).
      WHEN OTHERS.             validator = NEW lcl_phase_validator_default( ).
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_phase_validator_dev IMPLEMENTATION.
  METHOD lif_phase_validator~is_not_valid.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY Product BY \_ProductMarket
           FIELDS ( MarketID )
             WITH VALUE #( ( %tky = product-%tky ) )
           RESULT DATA(product_markets).

    IF product_markets IS INITIAL.
      INSERT VALUE #( %tky = product-%tky ) INTO TABLE failed.

      INSERT LINES OF VALUE tt_re_product( %tky             = product-%tky
                                           %state_area      = 'validateNextPhase'
                                           %element-phaseid = if_abap_behv=>mk-on

                                ( %msg = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-error
                                                              textid   = zcm_rp_messages=>movement_not_possible ) )
                                ( %msg = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-error
                                                              textid   = zcm_rp_messages=>markets_not_found     ) ) ) INTO TABLE reported.
      result = abap_true.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_phase_validator_prd IMPLEMENTATION.
  METHOD lif_phase_validator~is_not_valid.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY Product BY \_ProductMarket
           FIELDS ( MarketID Status )
             WITH VALUE #( ( %tky = product-%tky ) )
           RESULT DATA(product_markets).

    IF NOT line_exists( product_markets[ Status = zbp_rp_i_product_market=>market_statuses-accepted ] ).
      INSERT VALUE #( %tky = product-%tky ) INTO TABLE failed.

      INSERT LINES OF VALUE tt_re_product( %tky             = product-%tky
                                           %state_area      = 'validateNextPhase'
                                           %element-phaseid = if_abap_behv=>mk-on

                                ( %msg = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-error
                                                              textid   = zcm_rp_messages=>movement_not_possible ) )
                                ( %msg = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-error
                                                              textid   = zcm_rp_messages=>markets_not_accepted  ) ) ) INTO TABLE reported.
      result = abap_true.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_phase_validator_out IMPLEMENTATION.
  METHOD lif_phase_validator~is_not_valid.
    READ ENTITIES OF zrp_i_product IN LOCAL MODE
           ENTITY Product BY \_ProductMarket
           FIELDS ( MarketID EndDate )
             WITH VALUE #( ( %tky = product-%tky ) )
           RESULT DATA(product_markets).

    LOOP AT product_markets ASSIGNING FIELD-SYMBOL(<product_market>).
      IF NOT zbp_rp_i_product_market=>is_market_finished( <product_market> ).
        INSERT VALUE #( %tky = product-%tky ) INTO TABLE failed.

        INSERT LINES OF VALUE tt_re_product( %tky             = product-%tky
                                             %state_area      = 'validateNextPhase'
                                             %element-phaseid = if_abap_behv=>mk-on

                                ( %msg = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-error
                                                              textid   = zcm_rp_messages=>movement_not_possible ) )
                                ( %msg = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-error
                                                              textid   = zcm_rp_messages=>markets_not_finished  ) ) ) INTO TABLE reported.
        result = abap_true.
        RETURN.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_phase_validator_default IMPLEMENTATION.
  METHOD lif_phase_validator~is_not_valid.
    INSERT VALUE #( %tky = product-%tky ) INTO TABLE failed.

    INSERT VALUE #( %tky             = product-%tky
                    %state_area      = 'validateNextPhase'
                    %element-phaseid = if_abap_behv=>mk-on
                    %msg             = NEW zcm_rp_messages( severity = if_abap_behv_message=>severity-warning
                                                            textid   = zcm_rp_messages=>movement_not_possible ) ) INTO TABLE reported.
    result = abap_true.
  ENDMETHOD.
ENDCLASS.
