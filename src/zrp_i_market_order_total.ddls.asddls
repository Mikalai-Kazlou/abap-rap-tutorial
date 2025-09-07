@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders (Totals)'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZRP_I_MARKET_ORDER_TOTAL
  as select from ZRP_I_MARKET_ORDER
{
  key ProductUUID,
  key ProductMarketUUID,

      @EndUserText.label: 'Total Orders'
      count( distinct OrderUUID )        as TotalOrders,

      @EndUserText.label: 'Total Quantity'
      cast( sum(Quantity) as abap.int4 ) as TotalQuantity,

      @EndUserText.label: 'Total Net Amount'
      @Semantics.amount.currencyCode: 'AmountCurrency'
      sum(NetAmount)                     as TotalNetAmount,

      @EndUserText.label: 'Total Gross Amount'
      @Semantics.amount.currencyCode: 'AmountCurrency'
      sum(GrossAmount)                   as TotalGrossAmount,

      AmountCurrency
}
group by
  ProductUUID,
  ProductMarketUUID,
  AmountCurrency
