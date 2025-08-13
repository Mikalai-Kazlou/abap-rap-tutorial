" Yandex Dictionary API
" https://yandex.ru/dev/tech-only/doc/dg/ru/reference/lookup

CONSTANTS base_url TYPE string VALUE `https://dictionary.yandex.net/api/v1/dicservice.json/lookup`.

CONSTANTS service_key_part1 TYPE string VALUE `dict.1.1.20250619T132603Z`.
CONSTANTS service_key_part2 TYPE string VALUE `2f3b075ebc82de57`.
CONSTANTS service_key_part3 TYPE string VALUE `fbb8c417f4e64730e4aa0dfda2e51aaefe1b779c`.

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
