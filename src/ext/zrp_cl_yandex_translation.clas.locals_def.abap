CONSTANTS base_url TYPE string VALUE ``.
CONSTANTS service_key TYPE string VALUE ``.

TYPES:
  BEGIN OF ts_tr,
    text TYPE string,
    pos  TYPE string,
  END OF ts_tr.

TYPES tt_tr TYPE STANDARD TABLE OF ts_tr WITH EMPTY KEY.

TYPES:
  BEGIN OF ts_def,
    text TYPE string,
    pos  TYPE string,
    ts   TYPE string,
    tr   TYPE tt_tr,
  END OF ts_def.

TYPES tt_def TYPE STANDARD TABLE OF ts_def WITH EMPTY KEY.

TYPES:
  BEGIN OF ts_json,
    head TYPE string,
    def  TYPE tt_def,
  END OF   ts_json.
