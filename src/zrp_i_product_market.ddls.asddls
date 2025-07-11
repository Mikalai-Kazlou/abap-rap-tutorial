@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Markets'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRP_I_PRODUCT_MARKET
  as select from zrp_d_prod_mrkt

  association to parent ZRP_I_PRODUCT      as _Product
    on _Product.UUID = $projection.ProductUUID

  composition [0..*] of ZRP_I_MARKET_ORDER as _MarketOrder

  association to ZRP_I_MARKET              as _Market
    on _Market.MarketID = $projection.MarketID

{
  key produuid       as ProductUUID,
  key mrktuuid       as ProductMarketUUID,
      mrktid         as MarketID,
      isocode        as ISOCode,
      status         as Status,
      startdate      as StartDate,
      enddate        as EndDate,
      @Semantics.user.createdBy: true
      createdby      as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      createdon      as CreatedOn,
      @Semantics.user.lastChangedBy: true
      changedby      as ChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      changedon      as ChangedOn,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      localchangedon as LocalChangedOn,

      /* Associations */
      _Product,
      _MarketOrder,

      _Market
}
