@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OVP: Global Filters'
@Metadata.ignorePropagatedAnnotations: false

define view entity ZRP_C_OVP_MARKET_ORDER_FILTERS
  as select from ZRP_I_OVP_MARKET_ORDER

{
      @UI.hidden: true
  key ProductUUID,

      @UI.hidden: true
  key ProductMarketUUID,

      @UI.hidden: true
  key OrderUUID,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PRODUCT', element: 'Name' } } ]
      @UI.selectionField: [ { position: 10 } ]
      ProductName,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_MARKET', element: 'MarketName' } } ]
      @UI.selectionField: [ { position: 20 } ]
      MarketName,

      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @UI.selectionField: [ { position: 30 } ]
      DeliveryDate,

      @UI.selectionField: [ { position: 40 } ]
      @Semantics.amount.currencyCode: 'AmountCurrency'
      GrossIncom,
      AmountCurrency,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PHASE', element: 'PhaseText' } } ]
      @UI.selectionField: [ { position: 50 } ]
      PhaseName
}
