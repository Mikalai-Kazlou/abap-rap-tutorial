@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OVP: Global Filters'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZRP_C_OVP_MARKET_ORDER_FILTERS
  as select from ZRP_I_OVP_MARKET_ORDER
{
      @UI.selectionField: [{ position: 10 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRP_I_PRODUCT_GROUP', element: 'ProductGroupID' } }]
  key ProductGroupID,

      @UI.selectionField: [{ position: 20 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRP_I_PRODUCT', element: 'ID' } }]
  key ProductID,

      @UI.selectionField: [{ position: 30 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRP_I_PRODUCT_MARKET', element: 'MarketID' } }]
  key MarketID,

      @UI.selectionField: [{ position: 40 }]
      @Consumption.filter: { multipleSelections: false, selectionType: #INTERVAL }
  key DeliveryDate,

      @UI.selectionField: [{ position: 50 }]
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZRP_I_PHASE', element: 'PhaseID' } }]
  key PhaseID
}
