@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZRP_I_PRODUCT
  as select from zrp_d_product

  composition [0..*] of ZRP_I_PRODUCT_MARKET as _ProductMarket

  association [0..1] to ZRP_I_PRODUCT_GROUP  as _ProductGroup
    on $projection.ProductGroupID = _ProductGroup.ProductGroupID

  association [0..1] to ZRP_I_CURRENCY       as _Currency
    on $projection.PriceCurrency = _Currency.Currency

  association [0..1] to ZRP_I_UOM            as _SizeUOM
    on $projection.SizeUOM = _SizeUOM.UoM

  association [0..1] to ZRP_I_PHASE          as _Phase
    on $projection.PhaseID = _Phase.PhaseID

{
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
      _Phase
}
