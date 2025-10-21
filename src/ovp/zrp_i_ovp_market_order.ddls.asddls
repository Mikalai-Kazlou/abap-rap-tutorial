@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OVP: Market Orders'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZRP_I_OVP_MARKET_ORDER
  as select from ZRP_I_MARKET_ORDER
{
  key ProductUUID,
  key ProductMarketUUID,
  key OrderUUID,

      _Product.ID             as ProductID,
      _Product.ProductGroupID as ProductGroupID,
      _Product.PhaseID        as PhaseID,
      _ProductMarket.MarketID as MarketID,
      OrderID,

      DeliveryDate,

      Quantity,
      @Semantics.amount.currencyCode: 'Currency'
      NetAmount,
      @Semantics.amount.currencyCode: 'Currency'
      GrossAmount,
      AmountCurrency          as Currency,

      zzBusinessPartner       as BusinessPartner,

      _Product,
      _ProductMarket
}
