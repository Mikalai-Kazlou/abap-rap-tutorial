@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Markets (Virtual fields)'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZRP_I_PRODUCT_MARKET_V
  as select from ZRP_I_PRODUCT_MARKET
{
  key ProductUUID,
  key ProductMarketUUID,

      case Status
        when ' ' then 1
        when 'X' then 3
                 else 0
      end as StatusCriticality
}
