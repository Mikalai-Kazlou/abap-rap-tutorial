@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Currencies'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRP_I_CURRENCY
  as select from I_Currency
{
  key Currency,

      _Text[ Language = 'E' ].CurrencyName as CurrencyName,

      @UI.hidden: true
      Decimals,

      CurrencyISOCode,
      AlternativeCurrencyKey,

      @UI.hidden: true
      IsPrimaryCurrencyForISOCrcy,

      /* Associations */
      _Text
}
