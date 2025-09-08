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
  as select from ZRP_I_MARKET_ORDER_CONVERTED
{
  key ProductUUID,
  key ProductMarketUUID,

      @EndUserText.label: 'Total Orders'
      count( distinct OrderUUID ) as TotalOrders,

      @EndUserText.label: 'Total Quantity'
      sum(Quantity)               as TotalQuantity,

      @EndUserText.label: 'Total Net Amount'
      @Semantics.amount.currencyCode: 'Currency'
      sum(NetAmountConverted)     as TotalNetAmount,

      @EndUserText.label: 'Total Gross Amount'
      @Semantics.amount.currencyCode: 'Currency'
      sum(GrossAmountConverted)   as TotalGrossAmount,

      MarketCurrency              as Currency
}
group by
  ProductUUID,
  ProductMarketUUID,
  MarketCurrency
