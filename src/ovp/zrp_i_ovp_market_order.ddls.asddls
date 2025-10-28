@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Market Orders'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZRP_I_OVP_MARKET_ORDER
  as select from zrp_d_mrkt_order

  association [1..1] to ZRP_I_OVP_PRODUCT        as _Product
    on _Product.UUID = $projection.ProductUUID

  association [1..1] to ZRP_I_OVP_PRODUCT_MARKET as _ProductMarket
    on  _ProductMarket.ProductUUID       = $projection.ProductUUID
    and _ProductMarket.ProductMarketUUID = $projection.ProductMarketUUID

{
  key produuid                                as ProductUUID,
  key mrktuuid                                as ProductMarketUUID,
  key orderuuid                               as OrderUUID,
      orderid                                 as OrderID,

      _Product._ProductGroup.ProductGroupName as ProductGroupName,
      _Product.Name                           as ProductName,
      _ProductMarket._Market.MarketName       as MarketName,
      _Product._Phase.PhaseText               as PhaseName,

      calendaryear                            as CalendarYear,
      deliverydate                            as DeliveryDate,
      quantity                                as Quantity,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      netamount                               as NetAmount,
      @Semantics.amount.currencyCode: 'AmountCurrency'
      grossamount                             as GrossAmount,
      amountcurr                              as AmountCurrency,

      cast( 1 as abap.int4 )                  as CountByCountry,
      cast( 1 as abap.int4 )                  as CountByProductGroup,

      @Semantics.amount.currencyCode: 'AmountCurrency'
      grossamount - netamount                 as GrossIncom,

      @Semantics.quantity.unitOfMeasure:'Percentage'
      cast(
        cast( $projection.GrossIncom as abap.fltp ) * 100.0 / cast( $projection.NetAmount as abap.fltp )
      as abap.quan( 5, 2 ) )                  as GrossIncomPercentage,

      @Semantics.quantity.unitOfMeasure:'Percentage'
      cast(
        cast( $projection.GrossIncom as abap.fltp ) * 100.0 / cast( $projection.NetAmount as abap.fltp )
      as abap.quan( 5, 2 ) )                  as GrossIncomPercentageList,

      @Semantics.quantity.unitOfMeasure:'Percentage'
      cast(
        cast( $projection.GrossIncom as abap.fltp ) * 100.0 / cast( $projection.NetAmount as abap.fltp )
      as abap.quan( 5, 2 ) )                  as GrossIncomPercentageKPI,

      @Semantics.quantity.unitOfMeasure:'Percentage'
      cast( 30 as abap.quan( 5, 2 ) )         as TargetGrossIncomPercentage,

      @Semantics.quantity.unitOfMeasure:'Percentage'
      cast( 50 as abap.quan( 5, 2 ) )         as TargetGrossIncomPercentageKPI,

      cast('%' as abap.unit(3))               as Percentage,

      /* Associations */
      _Product,
      _ProductMarket
}
