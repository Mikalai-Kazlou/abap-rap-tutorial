@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

@Analytics.dataCategory: #CUBE

define view entity ZRP_I_ALP_MARKET_ORDER
  as select from zrp_d_mrkt_order

  association [1..1] to ZRP_I_ALP_PRODUCT        as _Product
    on _Product.UUID = $projection.ProductUUID

  association [1..1] to ZRP_I_ALP_PRODUCT_MARKET as _ProductMarket
    on  _ProductMarket.ProductUUID       = $projection.ProductUUID
    and _ProductMarket.ProductMarketUUID = $projection.ProductMarketUUID

{
  key produuid                                as ProductUUID,
  key mrktuuid                                as ProductMarketUUID,
  key orderuuid                               as OrderUUID,
      orderid                                 as OrderID,

      _Product._ProductGroup.ProductGroupName as ProductGroupName, // ProductName
      _ProductMarket._Market.MarketName       as MarketName,       // CountryName
      _Product._Phase.PhaseText               as PhaseName,

      calendaryear                            as CalendarYear,
      deliverydate                            as DeliveryDate,
      quantity                                as Quantity,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      netamount                               as NetAmount,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      grossamount                             as GrossAmount,
      amountcurr                              as AmountCurrency,

      1                                       as OrderCount,       // ProductCount

      @Semantics.amount.currencyCode: 'AmountCurrency'
      @EndUserText.label: 'Gross Incom'
      grossamount - netamount                 as GrossIncom,

      @Semantics.amount.currencyCode: 'AmountCurrency'
      @EndUserText.label: 'Average Gross Incom'
      grossamount - netamount                 as GrossIncomAvg,

      @Semantics.amount.currencyCode: 'AmountCurrency'
      @EndUserText.label: 'Maximum Gross Incom'
      grossamount - netamount                 as GrossIncomMax,

      @Semantics.amount.currencyCode: 'AmountCurrency'
      @EndUserText.label: 'Manimum Gross Incom'
      grossamount - netamount                 as GrossIncomMin,

      --Target Value for KPIs
      @Semantics.amount.currencyCode: 'AmountCurrency'
      cast( 15000000 as abap.curr( 15, 2 ) )  as KPITargGrossAmount,

      @Semantics.amount.currencyCode: 'AmountCurrency'
      cast( 8000000  as abap.curr( 15, 2 ) )  as KPITargGrossIncome,

      /* Associations */
      _Product,
      _ProductMarket
}
