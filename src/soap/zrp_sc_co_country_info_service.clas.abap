class ZRP_SC_CO_COUNTRY_INFO_SERVICE definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods LIST_OF_LANGUAGES_BY_NAME
    importing
      !INPUT type ZRP_SC_LIST_OF_LANGUAGES_BY_N1
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_LANGUAGES_BY_NA
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_LANGUAGES_BY_CODE
    importing
      !INPUT type ZRP_SC_LIST_OF_LANGUAGES_BY_C1
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_LANGUAGES_BY_CO
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CURRENCIES_BY_NAME
    importing
      !INPUT type ZRP_SC_LIST_OF_CURRENCIES_BY_1
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_CURRENCIES_BY_N
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CURRENCIES_BY_CODE
    importing
      !INPUT type ZRP_SC_LIST_OF_CURRENCIES_BY_2
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_CURRENCIES_BY_C
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_GROUPED
    importing
      !INPUT type ZRP_SC_LIST_OF_COUNTRY_NAMES_1
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_COUNTRY_NAMES_G
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_BY_NAME
    importing
      !INPUT type ZRP_SC_LIST_OF_COUNTRY_NAMES_2
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_COUNTRY_NAMES_B
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_COUNTRY_NAMES_BY_CODE
    importing
      !INPUT type ZRP_SC_LIST_OF_COUNTRY_NAMES_4
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_COUNTRY_NAMES_3
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CONTINENTS_BY_NAME
    importing
      !INPUT type ZRP_SC_LIST_OF_CONTINENTS_BY_1
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_CONTINENTS_BY_N
    raising
      CX_AI_SYSTEM_FAULT .
  methods LIST_OF_CONTINENTS_BY_CODE
    importing
      !INPUT type ZRP_SC_LIST_OF_CONTINENTS_BY_2
    exporting
      !OUTPUT type ZRP_SC_LIST_OF_CONTINENTS_BY_C
    raising
      CX_AI_SYSTEM_FAULT .
  methods LANGUAGE_NAME
    importing
      !INPUT type ZRP_SC_LANGUAGE_NAME_SOAP_REQU
    exporting
      !OUTPUT type ZRP_SC_LANGUAGE_NAME_SOAP_RESP
    raising
      CX_AI_SYSTEM_FAULT .
  methods LANGUAGE_ISOCODE
    importing
      !INPUT type ZRP_SC_LANGUAGE_ISOCODE_SOAP_1
    exporting
      !OUTPUT type ZRP_SC_LANGUAGE_ISOCODE_SOAP_R
    raising
      CX_AI_SYSTEM_FAULT .
  methods FULL_COUNTRY_INFO_ALL_COUNTRIE
    importing
      !INPUT type ZRP_SC_FULL_COUNTRY_INFO_ALL_1
    exporting
      !OUTPUT type ZRP_SC_FULL_COUNTRY_INFO_ALL_C
    raising
      CX_AI_SYSTEM_FAULT .
  methods FULL_COUNTRY_INFO
    importing
      !INPUT type ZRP_SC_FULL_COUNTRY_INFO_SOAP1
    exporting
      !OUTPUT type ZRP_SC_FULL_COUNTRY_INFO_SOAP
    raising
      CX_AI_SYSTEM_FAULT .
  methods CURRENCY_NAME
    importing
      !INPUT type ZRP_SC_CURRENCY_NAME_SOAP_REQU
    exporting
      !OUTPUT type ZRP_SC_CURRENCY_NAME_SOAP_RESP
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_NAME
    importing
      !INPUT type ZRP_SC_COUNTRY_NAME_SOAP_REQUE
    exporting
      !OUTPUT type ZRP_SC_COUNTRY_NAME_SOAP_RESPO
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_ISOCODE
    importing
      !INPUT type ZRP_SC_COUNTRY_ISOCODE_SOAP_R1
    exporting
      !OUTPUT type ZRP_SC_COUNTRY_ISOCODE_SOAP_RE
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_INT_PHONE_CODE
    importing
      !INPUT type ZRP_SC_COUNTRY_INT_PHONE_CODE1
    exporting
      !OUTPUT type ZRP_SC_COUNTRY_INT_PHONE_CODE
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_FLAG
    importing
      !INPUT type ZRP_SC_COUNTRY_FLAG_SOAP_REQUE
    exporting
      !OUTPUT type ZRP_SC_COUNTRY_FLAG_SOAP_RESPO
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRY_CURRENCY
    importing
      !INPUT type ZRP_SC_COUNTRY_CURRENCY_SOAP_1
    exporting
      !OUTPUT type ZRP_SC_COUNTRY_CURRENCY_SOAP_R
    raising
      CX_AI_SYSTEM_FAULT .
  methods COUNTRIES_USING_CURRENCY
    importing
      !INPUT type ZRP_SC_COUNTRIES_USING_CURREN1
    exporting
      !OUTPUT type ZRP_SC_COUNTRIES_USING_CURRENC
    raising
      CX_AI_SYSTEM_FAULT .
  methods CONSTRUCTOR
    importing
      !DESTINATION type ref to IF_PROXY_DESTINATION optional
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    preferred parameter LOGICAL_PORT_NAME
    raising
      CX_AI_SYSTEM_FAULT .
  methods CAPITAL_CITY
    importing
      !INPUT type ZRP_SC_CAPITAL_CITY_SOAP_REQUE
    exporting
      !OUTPUT type ZRP_SC_CAPITAL_CITY_SOAP_RESPO
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZRP_SC_CO_COUNTRY_INFO_SERVICE IMPLEMENTATION.


  method CAPITAL_CITY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CAPITAL_CITY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZRP_SC_CO_COUNTRY_INFO_SERVICE'
    logical_port_name   = logical_port_name
    destination         = destination
  ).

  endmethod.


  method COUNTRIES_USING_CURRENCY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRIES_USING_CURRENCY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_CURRENCY.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_CURRENCY'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_FLAG.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_FLAG'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_INT_PHONE_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_INT_PHONE_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_ISOCODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_ISOCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method COUNTRY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'COUNTRY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method CURRENCY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'CURRENCY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method FULL_COUNTRY_INFO.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FULL_COUNTRY_INFO'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method FULL_COUNTRY_INFO_ALL_COUNTRIE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'FULL_COUNTRY_INFO_ALL_COUNTRIE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LANGUAGE_ISOCODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LANGUAGE_ISOCODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LANGUAGE_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LANGUAGE_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CONTINENTS_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CONTINENTS_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CONTINENTS_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CONTINENTS_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_COUNTRY_NAMES_GROUPED.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_COUNTRY_NAMES_GROUPED'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CURRENCIES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CURRENCIES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_CURRENCIES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_CURRENCIES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_LANGUAGES_BY_CODE.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_LANGUAGES_BY_CODE'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.


  method LIST_OF_LANGUAGES_BY_NAME.

  data(lt_parmbind) = value abap_parmbind_tab(
    ( name = 'INPUT' kind = '0' value = ref #( INPUT ) )
    ( name = 'OUTPUT' kind = '1' value = ref #( OUTPUT ) )
  ).
  if_proxy_client~execute(
    exporting
      method_name = 'LIST_OF_LANGUAGES_BY_NAME'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
