CONSTANTS:
  BEGIN OF phases,
    planning    TYPE zrp_i_phase-phaseid VALUE 1,
    development TYPE zrp_i_phase-phaseid VALUE 2,
    production  TYPE zrp_i_phase-phaseid VALUE 3,
    out         TYPE zrp_i_phase-phaseid VALUE 4,
  END OF phases.

TYPES ts_rr_product TYPE STRUCTURE FOR READ RESULT zrp_i_product\\product.

TYPES tt_rr_product TYPE TABLE FOR READ RESULT     zrp_i_product\\product.
TYPES tt_re_product TYPE TABLE FOR REPORTED EARLY  zrp_i_product\\product.
TYPES tt_fe_product TYPE TABLE FOR FAILED EARLY    zrp_i_product\\product.

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
