@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Markets'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define view entity ZRP_I_OVP_MARKET
  as select from zrp_d_market
{
      @ObjectModel.text.element: ['MarketName']
  key mrktid   as MarketID,

      @Semantics.text: true
      mrktname as MarketName,

      langcode as Language,
      currency as Currency,

      @UI.hidden: true
      imageurl as ImageUrl
}
