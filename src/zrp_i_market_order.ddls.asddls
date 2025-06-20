@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRP_I_MARKET_ORDER
  as select from zrp_d_mrkt_order

  association to ZRP_I_PRODUCT               as _Product
    on _Product.UUID = $projection.ProductUUID

  association to parent ZRP_I_PRODUCT_MARKET as _ProductMarket
    on  _ProductMarket.ProductUUID       = $projection.ProductUUID
    and _ProductMarket.ProductMarketUUID = $projection.ProductMarketUUID

{
  key produuid       as ProductUUID,
  key mrktuuid       as ProductMarketUUID,
  key orderuuid      as OrderUUID,
      orderid        as OrderID,
      quantity       as Quantity,
      calendaryear   as CalendarYear,
      deliverydate   as DeliveryDate,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      netamount      as NetAmount,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      grossamount    as GrossAmount,
      amountcurr     as AmountCurrency,
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
      _ProductMarket
}
