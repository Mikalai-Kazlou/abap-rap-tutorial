@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Analysis'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

@Consumption.semanticObject: 'ProductAnalysisSO'

define view entity ZRP_I_PRODUCT_ANALYSIS
  as select from ZRP_F_PRODUCT_ANALYSIS
{
      @UI.facet: [

        { position: 10,
          purpose: #QUICK_VIEW,
          type: #FIELDGROUP_REFERENCE,
          targetQualifier: 'Product',
          label: 'Product'
        },
        { position: 20,
          purpose: #QUICK_VIEW,
          type: #FIELDGROUP_REFERENCE,
          targetQualifier: 'SalesAnalytics',
          label: 'Sales Analytics'
        }
      ]

      @UI.hidden: true
  key UUID,

      @UI.fieldGroup: [ { position: 10,
                          label: 'Product ID',
                          qualifier: 'Product',
                          criticality: 'PhaseID' } ]
  key ID,

      @UI.fieldGroup: [ { position: 20,
                          label: 'Product Name',
                          qualifier: 'Product',
                          criticality: 'PhaseID' } ]
      Name,

      @UI.fieldGroup: [ { position: 30,
                          label: 'Markets',
                          qualifier: 'SalesAnalytics' } ]
      MarketList,

      @UI.hidden: true
      PhaseID,

      @UI.fieldGroup: [ { position: 40,
                          label: 'Market Quantity',
                          qualifier: 'SalesAnalytics' } ]
      MarketQuantity,

      @UI.fieldGroup: [ { position: 50,
                          label: 'Order Quantity',
                          qualifier: 'SalesAnalytics' } ]
      OrderQuantity,

      @UI.fieldGroup: [ { position: 60,
                          label: 'Total Quantity',
                          qualifier: 'SalesAnalytics' } ]
      TotalQuantity,

      @UI.fieldGroup: [ { position: 70,
                          label: 'Total Net Amount',
                          qualifier: 'SalesAnalytics' } ]
      @Semantics.amount.currencyCode: 'Currency'
      TotalNetAmount,

      @UI.fieldGroup: [ { position: 80,
                          label: 'Total Gross Amount',
                          qualifier: 'SalesAnalytics' } ]
      @Semantics.amount.currencyCode: 'Currency'
      TotalGrossAmount,

      @Semantics.amount.currencyCode: 'Currency'
      TotalGrossAmount - TotalNetAmount                    as Income,

      Currency,

      cast(
        cast( $projection.Income as abap.fltp ) / cast( TotalGrossAmount as abap.fltp ) * 100.0
      as abap.dec( 5, 2 ) )                                as IncomePercentage,

      case
        when $projection.IncomePercentage <  20 then 1
        when $projection.IncomePercentage <  30 then 2
        when $projection.IncomePercentage >= 30 then 3
                                                else 0 end as IncomePercentageCriticality
}
