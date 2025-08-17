@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Markets'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRP_V_PRODUCT_MARKET
  as select from zrp_d_prod_mrkt
{
  key produuid              as ProductUUID,
  key mrktuuid              as ProductMarketUUID,

      case status
        when ' ' then 1
        when 'X' then 3
                 else 0 end as StatusCriticality
}
