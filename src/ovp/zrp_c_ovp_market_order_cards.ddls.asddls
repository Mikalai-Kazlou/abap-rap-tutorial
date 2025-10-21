@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OVP: Cards'
@Metadata.ignorePropagatedAnnotations: true

@UI.chart: [

  { qualifier: 'MarketGrossAmountChart',
    title: 'Market Gross Amount Chart',
    description: 'The chart shows order gross amounts for each market',
    chartType: #DONUT,
    dimensions: ['MarketID'],
    measures: ['GrossAmount'],
    dimensionAttributes: [{ dimension: 'MarketID', role: #CATEGORY }],
    measureAttributes: [{ measure: 'GrossAmount', role: #AXIS_1 }]
  }
]

define view entity ZRP_C_OVP_MARKET_ORDER_CARDS
  as select from ZRP_I_OVP_MARKET_ORDER
{
      @UI.hidden: true
  key ProductUUID,
      @UI.hidden: true
  key ProductMarketUUID,
      @UI.hidden: true
  key OrderUUID,

      ProductGroupID,
      ProductID,
      MarketID,
      DeliveryDate,
      PhaseID,

      OrderID,
      BusinessPartner,

      @Aggregation.default: #SUM
      Quantity,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      NetAmount,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'Currency'
      GrossAmount,

      @UI.hidden: true
      Currency
}
