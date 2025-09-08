@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders (Converted Amounts)'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZRP_I_MARKET_ORDER_CONVERTED
  as select from ZRP_I_MARKET_ORDER
{
  key ProductUUID,
  key ProductMarketUUID,
  key OrderUUID,

      OrderID,
      DeliveryDate,
      AmountCurrency                                                  as OrderCurrency,

      _ProductMarket._Market.MarketName                               as MarketName,
      _ProductMarket._Market.Currency                                 as MarketCurrency,

      cast( Quantity as abap.int4 )                                   as Quantity,

      @Semantics.amount.currencyCode: 'OrderCurrency'
      NetAmount,

      @Semantics.amount.currencyCode: 'MarketCurrency'
      currency_conversion( amount             => NetAmount,
                           source_currency    => $projection.OrderCurrency,
                           target_currency    => $projection.MarketCurrency,
                           exchange_rate_date => DeliveryDate,
                           error_handling     => 'KEEP_UNCONVERTED' ) as NetAmountConverted,

      @Semantics.amount.currencyCode: 'OrderCurrency'
      GrossAmount,

      @Semantics.amount.currencyCode: 'MarketCurrency'
      currency_conversion( amount             => GrossAmount,
                           source_currency    => $projection.OrderCurrency,
                           target_currency    => $projection.MarketCurrency,
                           exchange_rate_date => DeliveryDate,
                           error_handling     => 'KEEP_UNCONVERTED' ) as GrossAmountConverted
}
