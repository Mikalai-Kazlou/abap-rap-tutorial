@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view entity ZRP_C_MARKET_ORDER
  as projection on ZRP_I_MARKET_ORDER
{
  key ProductUUID,
  key ProductMarketUUID,
  key OrderUUID,

      OrderID,
      Quantity,
      CalendarYear,
      DeliveryDate,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      NetAmount,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      GrossAmount,
      AmountCurrency,

      CreatedBy,
      @Semantics.dateTime: true
      CreatedOn,
      ChangedBy,
      @Semantics.dateTime: true
      ChangedOn,
      @Semantics.dateTime: true
      LocalChangedOn,

      /* Associations */
      _Product       as Product       : redirected to ZRP_C_PRODUCT,
      _ProductMarket as ProductMarket : redirected to parent ZRP_C_PRODUCT_MARKET
}
