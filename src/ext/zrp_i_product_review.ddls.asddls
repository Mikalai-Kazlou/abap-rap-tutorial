@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Review'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZRP_I_PRODUCT_REVIEW
  as select from zrp_d_prod_rev

  association to parent ZRP_I_PRODUCT as _Product
    on $projection.ProductUUID = _Product.UUID
{
  key product_uuid          as ProductUUID,
  key review_uuid           as ReviewUUID,
      rating                as Rating,
      free_text_comment     as FreeTextComment,
      helpful_count         as HelpfulCount,
      helpful_total         as HelpfulTotal,

      @Semantics.user.createdBy: true
      reviewer              as Reviewer,
      @Semantics.systemDateTime.createdAt: true
      local_created_at      as LocalCreatedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at as LocalLastChangedAt,

      _Product
}
