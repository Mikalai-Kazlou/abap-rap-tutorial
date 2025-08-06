@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AbapCatalog.extensibility: {
  extensible: true,
  allowNewDatasources: false,
  dataSources: ['MarketOrder']
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders (Extention)'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZRP_E_MARKET_ORDER
  as select from zrp_d_mrkt_order as MarketOrder
{
  key produuid  as ProductUUID,
  key mrktuuid  as ProductMarketUUID,
  key orderuuid as OrderUUID

}
