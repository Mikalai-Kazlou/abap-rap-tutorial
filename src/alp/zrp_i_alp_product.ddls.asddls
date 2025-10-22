@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products'
@Metadata.ignorePropagatedAnnotations: true

@Analytics.dataCategory: #DIMENSION

define root view entity ZRP_I_ALP_PRODUCT
  as select from zrp_d_product

  association [0..1] to ZRP_I_ALP_PRODUCT_GROUP as _ProductGroup
    on $projection.ProductGroupID = _ProductGroup.ProductGroupID

  association [0..1] to ZRP_I_ALP_PHASE         as _Phase
    on $projection.PhaseID = _Phase.PhaseID

{
  key produuid      as UUID,
      prodid        as ID,
      prodname      as Name,
      pgid          as ProductGroupID,
      phaseid       as PhaseID,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      height        as Height,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      depth         as Depth,
      @Semantics.quantity.unitOfMeasure: 'SizeUOM'
      width         as Width,
      sizeuom       as SizeUOM,
      @Semantics.amount.currencyCode: 'PriceCurrency'
      price         as Price,
      pricecurrency as PriceCurrency,
      taxrate       as TaxRate,

      /* Associations */
      _ProductGroup,
      _Phase
}
