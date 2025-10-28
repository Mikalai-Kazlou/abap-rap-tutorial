@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Markets'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Analytics.dataCategory: #DIMENSION

define view entity ZRP_I_ALP_PRODUCT_MARKET
  as select from zrp_d_prod_mrkt

  association [0..1] to ZRP_I_ALP_MARKET as _Market
    on _Market.MarketID = $projection.MarketID

{
  key produuid  as ProductUUID,
  key mrktuuid  as ProductMarketUUID,
      mrktid    as MarketID,
      isocode   as ISOCode,
      status    as Status,
      startdate as StartDate,
      enddate   as EndDate,

      /* Associations */
      _Market
}
