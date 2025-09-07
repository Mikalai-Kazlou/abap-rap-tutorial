@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders (Charts)'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@UI.chart: [

  { qualifier: 'OrderQuantityChart',
    title: 'Order Quantity Chart',
    description: 'The chart shows quantity of orders for each delivery date',
    chartType: #BAR,
    dimensions: [ 'DeliveryDate' ],
    measures: [ 'Quantity' ],
    dimensionAttributes: [ { dimension: 'DeliveryDate', role: #CATEGORY } ],
    measureAttributes: [ { measure: 'Quantity', role: #AXIS_1 } ]
  },
  { qualifier: 'OrderAmountChart',
    title: 'Order Amount Chart',
    description: 'The chart shows amount of orders for each delivery date',
    chartType: #BAR,
    dimensions: [ 'DeliveryDate' ],
    measures: [ 'NetAmount', 'GrossAmount' ],
    dimensionAttributes: [ { dimension: 'DeliveryDate', role: #CATEGORY } ],
    measureAttributes: [ { measure: 'NetAmount',   role: #AXIS_1 },
                         { measure: 'GrossAmount', role: #AXIS_2 } ]
  }
]

define view entity ZRP_I_MARKET_ORDER_CHART
  as select from ZRP_I_MARKET_ORDER
{
      @UI.hidden: true
  key ProductUUID,
      @UI.hidden: true
  key ProductMarketUUID,

      @EndUserText.label: 'Market Order ID'
      @ObjectModel.text.element: ['OrderID']
      @UI.textArrangement: #TEXT_ONLY
  key OrderUUID,

      OrderID,
      DeliveryDate,

      @Aggregation.default: #SUM
      Quantity,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'AmountCurrency'
      NetAmount,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'AmountCurrency'
      GrossAmount,

      AmountCurrency
}
