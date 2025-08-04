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
