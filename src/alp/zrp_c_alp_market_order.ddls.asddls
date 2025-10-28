@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ALP for Market Orders'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true

define view entity ZRP_C_ALP_MARKET_ORDER
  as select from ZRP_I_ALP_MARKET_ORDER

{
  key ProductUUID,
  key ProductMarketUUID,
  key OrderUUID,

      OrderID,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PRODUCT_GROUP', element: 'ProductGroupName' } } ]
      ProductGroupName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PRODUCT_VH', element: 'Name' } } ]
      ProductName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_MARKET_VH', element: 'MarketName' } } ]
      MarketName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PHASE', element: 'PhaseText' } } ]
      PhaseName,

      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      DeliveryDate,

      @Aggregation.default: #SUM
      Quantity,

      @Aggregation.default: #SUM
      NetAmount,

      @Aggregation.default: #SUM
      GrossAmount,

      @Aggregation.default: #SUM
      OrderCount,

      @Aggregation.default: #SUM
      GrossIncom,

      @Aggregation.default: #AVG
      GrossIncomAvg,

      @Aggregation.default: #MAX
      GrossIncomMax,

      @Aggregation.default: #MIN
      GrossIncomMin,

      KPITargGrossAmount,
      KPITargGrossIncome,
      AmountCurrency,

      /* Associations */
      _Product,
      _ProductMarket
}
