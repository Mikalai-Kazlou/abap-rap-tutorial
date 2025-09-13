@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

@AbapCatalog.extensibility: {
  extensible: true,
  allowNewDatasources: false,
  dataSources: ['Product'],
  allowNewCompositions: true
}

define root view entity ZRP_C_PRODUCT
  provider contract transactional_query
  as projection on ZRP_I_PRODUCT as Product

{
  key UUID,

      @Search.defaultSearchElement: true
      @Consumption.semanticObject: 'ProductAnalysisSO'
      @Consumption.semanticObjectMapping.additionalBinding: [ { element: 'UUID', localElement: 'UUID' } ]
      @ObjectModel.foreignKey.association: 'ProductAnalysis'
      ID,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Name,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PRODUCT_GROUP', element: 'ProductGroupID' } } ]
      @ObjectModel.text.element: ['ProductGroupName']
      @UI.textArrangement: #TEXT_ONLY
      ProductGroupID,
      @Semantics.text: true
      _ProductGroup.ProductGroupName as ProductGroupName,
      _ProductGroup.ImageUrl         as ProductGroupImageUrl,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_PHASE', element: 'PhaseID' } } ]
      @ObjectModel.text.element: ['PhaseText']
      @UI.textArrangement: #TEXT_ONLY
      PhaseID,
      _Phase.PhaseText               as PhaseText,

      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      Height,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      Depth,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      Width,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_UOM', element: 'UoM' } } ]
      @Semantics.unitOfMeasure: true
      SizeUOM,

      @Semantics.amount.currencyCode: 'PriceCurrency'
      Price,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_CURRENCY', element: 'Currency' } } ]
      @Semantics.currencyCode: true
      PriceCurrency,

      TaxRate,

      _ProductAnalysis.IncomePercentage,
      _ProductAnalysis.IncomePercentageCriticality,
      _ProductAnalysis.NetAmountInGrossAmount,

      CreatedBy,
      @Semantics.dateTime: true
      CreatedOn,
      ChangedBy,
      @Semantics.dateTime: true
      ChangedOn,
      @Semantics.dateTime: true
      LocalChangedOn,

      /* Associations */
      _ProductMarket                 as ProductMarkets : redirected to composition child ZRP_C_PRODUCT_MARKET,

      _ProductGroup                  as ProductGroup,
      _Currency                      as Currency,
      _Phase                         as Phase,

      _CreatedByContact              as CreatedByContact,
      _ChangedByContact              as ChangedByContact,

      _ByMarketChart                 as ByMarketChart,
      _ProductAnalysis               as ProductAnalysis
}
