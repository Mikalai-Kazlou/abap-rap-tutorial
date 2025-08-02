CONSTANTS:
  BEGIN OF phases,
    planning    TYPE zrp_d_phase-phaseid VALUE 1,
    development TYPE zrp_d_phase-phaseid VALUE 2,
    production  TYPE zrp_d_phase-phaseid VALUE 3,
    out         TYPE zrp_d_phase-phaseid VALUE 4,
  END OF phases.

CONSTANTS country_info_service_url TYPE string VALUE `http://webservices.oorsprong.org/websamples.countryinfo/CountryInfoService.wso`.

TYPES ts_product_read_result TYPE STRUCTURE FOR READ RESULT zrp_i_product\\product.
TYPES tt_product_read_result TYPE TABLE FOR READ RESULT     zrp_i_product\\product.
TYPES tt_product_reported    TYPE TABLE FOR REPORTED EARLY  zrp_i_product\\product.
TYPES tt_product_failed      TYPE TABLE FOR FAILED EARLY    zrp_i_product\\product.
