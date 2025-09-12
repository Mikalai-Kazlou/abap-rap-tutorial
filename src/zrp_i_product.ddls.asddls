@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST]
@AbapCatalog.extensibility: {
  extensible: true,
  allowNewDatasources: false,
  dataSources: ['_Extension'],
  allowNewCompositions: true
}
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZRP_I_PRODUCT
  as select from zrp_d_product

  composition [0..*] of ZRP_I_PRODUCT_MARKET     as _ProductMarket

  association [0..1] to ZRP_I_PRODUCT_GROUP      as _ProductGroup
    on $projection.ProductGroupID = _ProductGroup.ProductGroupID

  association [0..1] to ZRP_I_CURRENCY           as _Currency
    on $projection.PriceCurrency = _Currency.Currency

  association [0..1] to ZRP_I_UOM                as _SizeUOM
    on $projection.SizeUOM = _SizeUOM.UoM

  association [0..1] to ZRP_I_PHASE              as _Phase
    on $projection.PhaseID = _Phase.PhaseID

  association [0..1] to ZRP_I_USER               as _CreatedByContact
    on $projection.CreatedBy = _CreatedByContact.ID

  association [0..1] to ZRP_I_USER               as _ChangedByContact
    on $projection.ChangedBy = _ChangedByContact.ID

  association [1..1] to ZRP_V_PRODUCT            as _VirtualFields
    on _VirtualFields.UUID = $projection.UUID

  association [0..*] to ZRP_I_MARKET_ORDER_CHART as _ByMarketChart
    on _ByMarketChart.ProductUUID = $projection.UUID

  association [1..1] to ZRP_I_PRODUCT_ANALYSIS   as _ProductAnalysis
    on  _ProductAnalysis.UUID = $projection.UUID
    and _ProductAnalysis.ID   = $projection.ID

  association [1..1] to ZRP_E_PRODUCT            as _Extension
    on _Extension.UUID = $projection.UUID

{
      /* start suppress warning shlporigin_not_inherited */
  key produuid       as UUID,
      prodid         as ID,
      prodname       as Name,
      @ObjectModel.text.association: '_ProductGroup'
      pgid           as ProductGroupID,
      @ObjectModel.text.association: '_Phase'
      phaseid        as PhaseID,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      height         as Height,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      depth          as Depth,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      width          as Width,
      sizeuom        as SizeUOM,
      @Semantics.amount.currencyCode: 'PriceCurrency'
      price          as Price,
      pricecurrency  as PriceCurrency,
      taxrate        as TaxRate,
      /* end suppress warning shlporigin_not_inherited */

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
      _ProductMarket,

      _ProductGroup,
      _Currency,
      _SizeUOM,
      _Phase,

      _CreatedByContact,
      _ChangedByContact,

      _VirtualFields,
      _ByMarketChart,
      _ProductAnalysis,

      _Extension
}
