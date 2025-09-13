@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Analysis'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Consumption.semanticObject: 'ProductAnalysisSO'

define view entity ZRP_I_PRODUCT_ANALYSIS
  as select from ZRP_F_PRODUCT_ANALYSIS
{
  key UUID,
  key ID,

      Name,
      MarketList,
      PhaseID,
      MarketQuantity,
      OrderQuantity,
      TotalQuantity,

      @Semantics.amount.currencyCode: 'Currency'
      TotalNetAmount,

      @Semantics.amount.currencyCode: 'Currency'
      TotalGrossAmount,

      @Semantics.amount.currencyCode: 'Currency'
      TotalGrossAmount - TotalNetAmount                    as Income,

      Currency,

      cast(
        cast( TotalNetAmount as abap.dec(15,2) ) / cast( TotalGrossAmount as abap.dec(15,2) ) * 100
        as abap.dec( 4, 1 )
      )                                                    as NetAmountInGrossAmount,

      cast(
        cast( $projection.Income as abap.fltp ) / cast( TotalGrossAmount as abap.fltp ) * 100.0
        as abap.dec( 5, 2 )
      )                                                    as IncomePercentage,

      case
        when $projection.IncomePercentage <  20 then 1
        when $projection.IncomePercentage <  30 then 2
        when $projection.IncomePercentage >= 30 then 3
                                                else 0 end as IncomePercentageCriticality
}
