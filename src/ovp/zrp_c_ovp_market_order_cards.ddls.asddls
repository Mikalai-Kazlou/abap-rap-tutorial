@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OVP: Cards'
@Metadata.ignorePropagatedAnnotations: false

@UI.chart:
    -- Chart Total Quantity of Orders:
    ---- by Country
[ { qualifier: 'OrdQuanByCountry',
   title: 'By Countrys',
   chartType: #COLUMN,
   dimensions: [ 'MarketName' ],
   measures: [ 'CountByCountry' ],
   dimensionAttributes: [ { dimension: 'MarketName', role: #CATEGORY } ],
   measureAttributes: [ { measure: 'CountByCountry', role: #AXIS_1 } ] },

   ---- by Product Groups
 { qualifier: 'OrdQuanByProdGr',
   title: 'By Product Groups',
   chartType: #COLUMN,
   dimensions: [ 'ProductName' ],
   measures: [ 'CountByProductGroup' ],
   dimensionAttributes: [ { dimension: 'ProductName', role: #CATEGORY } ],
   measureAttributes: [ { measure: 'CountByProductGroup', role: #AXIS_1 } ] },

   -- Chart AVG Income by Countries
 { qualifier: 'AVGIncomeCountry',
   title: 'by Countries',
   chartType: #DONUT,
   dimensions: [ 'MarketName' ],
   measures: [ 'GrossIncomPercentage' ],
   dimensionAttributes: [ { dimension: 'MarketName' } ],
   measureAttributes: [ { measure: 'GrossIncomPercentage', role: #AXIS_1 } ] }
]

@UI.headerInfo: {
  typeName: 'Order',
  typeNamePlural: 'Orders',
  imageUrl: 'IconUrl',
  title: { label: 'Order ID', value: 'OrderID' },
  description: { type: #STANDARD, value: 'PhaseName' }
}

@UI.presentationVariant:
    -- Chart Total Quantity of Orders:
    ---- by Country
[ { qualifier: 'pvOrdQuanByCountry',
   visualizations: [ { type: #AS_CHART, qualifier: 'OrdQuanByCountry' } ],
   sortOrder: [ { by: 'MarketName', direction: #ASC } ] },

   ---- by Product Groups
 { qualifier: 'pvOrdQuanByProdGr',
   visualizations: [ { type: #AS_CHART, qualifier: 'OrdQuanByProdGr' } ],
   sortOrder: [ { by: 'ProductName', direction: #ASC } ] },

   -- Chart AVG Income by Countries
 { qualifier: 'pvAVGIncomeCountry',
   visualizations: [ { type: #AS_CHART, qualifier: 'AVGIncomeCountry' } ],
   sortOrder: [ { by: 'MarketName',          direction: #ASC  },
                { by: 'GrossIncomPercentage', direction: #DESC } ] },

   -- ListCard Orders List
 { qualifier: 'pvOrdersList',
   visualizations: [ { type: #AS_LINEITEM, qualifier: 'OrdersList' } ],
   sortOrder: [ { by: 'GrossIncomPercentage', direction: #DESC },
                { by: 'OrderID',              direction: #ASC  } ] }
]

define view entity ZRP_C_OVP_MARKET_ORDER_CARDS
  as select from ZRP_I_OVP_MARKET_ORDER

{
      @UI.facet: [
        { isSummary: true,
          qualifier: 'StackOrdersList',
          label: 'StackOrdersListGenInf',
          type: #FIELDGROUP_REFERENCE,
          targetQualifier: 'StackOrdersListGenInf' },

        { isSummary: true,
          qualifier: 'StackOrdersList',
          label: 'StackOrdersListFD',
          type: #FIELDGROUP_REFERENCE,
          targetQualifier: 'StackOrdersListFD' }
      ]

      @UI.hidden: true
  key ProductUUID,

      @UI.hidden: true
  key ProductMarketUUID,

      @UI.hidden: true
  key OrderUUID,

      @UI.dataPoint.title: 'Order ID'
      @UI.identification: [ { qualifier: 'FaceSide',
                              position: 10,
                              label: 'Product ID',
                              semanticObjectAction: 'manage',
                              type: #FOR_INTENT_BASED_NAVIGATION } ]
      @UI.lineItem: [ { qualifier: 'OrdersList', type: #AS_DATAPOINT, position: 20, importance: #HIGH } ]
      OrderID,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListGenInf', position: 10, label: 'Product Name' } ]
      @UI.identification: [ { qualifier: 'FlipSide',
                              semanticObjectAction: 'manage',
                              type: #FOR_INTENT_BASED_NAVIGATION,
                              position: 10 } ]
      @UI.lineItem: [ { qualifier: 'OrdersList', position: 10, importance: #HIGH } ]
      ProductName,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListGenInf', label: 'Market', position: 20 } ]
      @UI.lineItem: [ { qualifier: 'OrdersList', position: 20, importance: #HIGH } ]
      MarketName,

      @Aggregation.default: #SUM
      @EndUserText.label: 'Quantity by Countrys'
      @UI.dataPoint: { qualifier: 'dpOrdQuanByCountry',
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 10,
                                                 toleranceRangeLowValue: 15 } }
      CountByCountry,

      @Aggregation.default: #SUM
      @EndUserText.label: 'Quantity by Product Groups'
      @UI.dataPoint: { qualifier: 'dpOrdQuanByProdGr',
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 10,
                                                 toleranceRangeLowValue: 15 } }
      CountByProductGroup,

      PhaseName,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListGenInf', position: 30, label: 'Year of Issue' } ]
      CalendarYear,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListGenInf', position: 40, label: 'Delivery' } ]
      DeliveryDate,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListFD', position: 10, label: 'Quantity, pieces' } ]
      Quantity,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListFD', position: 20, label: 'Net Amount' } ]
      NetAmount,

      @UI.fieldGroup: [ { qualifier: 'StackOrdersListFD', position: 30, label: 'Gross Amount' } ]
      GrossAmount,

      @UI.dataPoint.valueFormat: { numberOfFractionalDigits: 2, scaleFactor: 1000000 }
      @UI.fieldGroup: [ { qualifier: 'StackOrdersListFD', position: 40, label: 'Gross Income' } ]
      @UI.lineItem: [ { qualifier: 'OrdersList', position: 10, type: #AS_DATAPOINT, importance: #HIGH } ]
      GrossIncom,

      AmountCurrency,

      @Aggregation.default: #AVG
      @EndUserText.label: 'Average Gross Income Percentage'
      @Semantics.quantity.unitOfMeasure: 'Percentage'
      @UI.dataPoint: { qualifier: 'dpAVGIncomeCountry',
                       valueFormat.numberOfFractionalDigits: 1,
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 25,
                                                 toleranceRangeLowValue: 30 },
                       trendCalculation: { referenceValue: 'TargetGrossIncomPercentage',
                                           downDifference: 0,
                                           upDifference: 0 } }
      @UI.fieldGroup: [ { qualifier: 'StackOrdersListFD', position: 50, label: 'Gross Income Percentage' } ]
      GrossIncomPercentage,

      Percentage,

      @Semantics.quantity.unitOfMeasure: 'Percentage'
      TargetGrossIncomPercentage,

      @Semantics.quantity.unitOfMeasure: 'Percentage'
      @UI.dataPoint.criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                              deviationRangeLowValue: 40,
                                              toleranceRangeLowValue: 50 }
      @UI.lineItem: [ { qualifier: 'OrdersList', position: 10, importance: #HIGH, type: #AS_DATAPOINT } ]
      GrossIncomPercentageList,

      @Aggregation.default: #MAX
      @Semantics.quantity.unitOfMeasure: 'Percentage'
      @UI.dataPoint: { qualifier: 'dpAVGIncomeCountryList',
                       valueFormat.numberOfFractionalDigits: 1,
                       criticalityCalculation: { improvementDirection: #MAXIMIZE,
                                                 deviationRangeLowValue: 40,
                                                 toleranceRangeLowValue: 50 },
                       trendCalculation: { referenceValue: 'TargetGrIncPercKPI', downDifference: 0, upDifference: 0 } }
      GrIncPercKPI,


      @Semantics.quantity.unitOfMeasure: 'Percentage'
      TargetGrIncPercKPI,

      @UI.identification: [ { type: #WITH_URL,
                              qualifier: 'FlipSide',
                              label: 'EPAM Global',
                              url: 'WebAddress',
                              position: 20 } ]

      'https://www.epam.com/'    as WebAddress,

      @UI.identification: [ { type: #WITH_URL,
                              qualifier: 'FlipSide',
                              label: 'EPAM BY',
                              url: 'WebAddress2',
                              position: 30 } ]

      'https://careers.epam.by/' as WebAddress2,

      'sap-icon://order-status'  as IconUrl
}
