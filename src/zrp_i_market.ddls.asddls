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
      @ObjectModel.text.element: [ 'MarketName' ]
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key mrktid   as MarketID,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      mrktname as MarketName,

      langcode as Language,
      currency as Currency,

      @UI.hidden: true
      imageurl as ImageUrl
}
