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

      @EndUserText.label: 'Product'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PRODUCT_VH', element: 'Name' } } ]
      @UI.selectionField: [ { position: 10 } ]
      ProductName,

      @EndUserText.label: 'Market'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_MARKET_VH', element: 'MarketName' } } ]
      @UI.selectionField: [ { position: 20 } ]
      MarketName,

      @Consumption.filter: { selectionType: #INTERVAL, multipleSelections: false }
      @UI.selectionField: [ { position: 30 } ]
      DeliveryDate,

      @EndUserText.label: 'Gross Incom'
      @UI.selectionField: [ { position: 40 } ]
      GrossIncom,

      @UI.selectionField: [ { position: 50 } ]
      AmountCurrency,

      @EndUserText.label: 'Phase'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PHASE', element: 'PhaseText' } } ]
      @UI.selectionField: [ { position: 60 } ]
      PhaseName
}
