@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders (Charts)'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

// Useful link: https://help.sap.com/docs/ABAP_PLATFORM_NEW/fc4c71aa50014fd1b43721701471913d/c7f12219d533404f8fad96aa68fa4ba6.html

@UI.chart: [

  { qualifier: 'OrderQuantityChart',
    title: 'Order Quantity Chart',
    description: 'The chart shows order quantity for each delivery date',
    chartType: #BAR,
    dimensions: [ 'DeliveryDate' ],
    measures: [ 'Quantity' ],
    dimensionAttributes: [ { dimension: 'DeliveryDate', role: #CATEGORY } ],
    measureAttributes: [ { measure: 'Quantity', role: #AXIS_1 } ]
  },
  { qualifier: 'OrderAmountChart',
    title: 'Order Amount Chart',
    description: 'The chart shows order amounts for each delivery date',
    chartType: #BAR,
    dimensions: [ 'DeliveryDate' ],
    measures: [ 'NetAmount', 'GrossAmount' ],
    dimensionAttributes: [ { dimension: 'DeliveryDate', role: #CATEGORY } ],
    measureAttributes: [ { measure: 'NetAmount',   role: #AXIS_1 },
                         { measure: 'GrossAmount', role: #AXIS_2 } ]
  },
  { qualifier: 'MarketQuantityChart',
    title: 'Market Amount Chart',
    description: 'The chart shows order quantity for each market',
    chartType: #DONUT,
    dimensions: [ 'ProductMarketUUID' ],
    measures: [ 'Quantity' ],
    dimensionAttributes: [ { dimension: 'ProductMarketUUID', role: #CATEGORY } ],
    measureAttributes: [ { measure: 'Quantity', role: #AXIS_1 }  ]
  },
  { qualifier: 'MarketAmountChart',
    title: 'Market Amount Chart',
    description: 'The chart shows order amounts for each market',
    chartType: #BAR,
    dimensions: [ 'ProductMarketUUID' ],
    measures: [ 'NetAmount', 'GrossAmount' ],
    dimensionAttributes: [ { dimension: 'ProductMarketUUID', role: #CATEGORY } ],
    measureAttributes: [ { measure: 'NetAmount',   role: #AXIS_1 },
                         { measure: 'GrossAmount', role: #AXIS_2 } ]
  }
]

define view entity ZRP_I_MARKET_ORDER_CHART
  as select from ZRP_I_MARKET_ORDER_CONVERTED
{
      @UI.hidden: true
  key ProductUUID,

      @EndUserText.label: 'Market'
      @ObjectModel.text.element: ['MarketName']
      @UI.textArrangement: #TEXT_ONLY
  key ProductMarketUUID,

      @EndUserText.label: 'Market Order'
      @ObjectModel.text.element: ['OrderID']
      @UI.textArrangement: #TEXT_ONLY
  key OrderUUID,

      OrderID,
      DeliveryDate,
      MarketName,

      @Aggregation.default: #SUM
      Quantity,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'OrderCurrency'
      NetAmount,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'OrderCurrency'
      GrossAmount,

      @UI.hidden: true
      OrderCurrency
}
