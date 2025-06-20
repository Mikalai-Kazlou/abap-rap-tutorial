@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Markets'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true

define view entity ZRP_I_MARKET
  as select from zrp_d_market
{
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key mrktid   as MarketID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      mrktname as MarketName,
      langcode as Language,

      @UI.hidden: true
      imageurl as ImageUrl
}
