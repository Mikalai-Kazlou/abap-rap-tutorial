@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'OVP: Cards'
@Metadata.ignorePropagatedAnnotations: false
@Metadata.allowExtensions: true

define view entity ZRP_C_OVP_MARKET_ORDER_CARDS
  as select from ZRP_I_OVP_MARKET_ORDER
{
  key ProductUUID,
  key ProductMarketUUID,
  key OrderUUID,

      OrderID,
      ProductName,
      MarketName,

      @Aggregation.default: #SUM
      CountByCountry,

      @Aggregation.default: #SUM
      CountByProductGroup,

      PhaseName,
      CalendarYear,
      DeliveryDate,
      Quantity,
      NetAmount,
      GrossAmount,
      GrossIncom,
      AmountCurrency,

      @Aggregation.default: #AVG
      GrossIncomPercentage,
      TargetGrossIncomPercentage,
      GrossIncomPercentageList,

      @Aggregation.default: #MAX
      GrossIncomPercentageKPI,
      TargetGrossIncomPercentageKPI,
      Percentage,

      'https://www.epam.com/'        as WebAddress1,
      'https://www.epam.com/careers' as WebAddress2,
      'sap-icon://order-status'      as IconUrl
}
