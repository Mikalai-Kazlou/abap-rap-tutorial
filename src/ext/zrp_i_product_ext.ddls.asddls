extend view entity ZRP_I_PRODUCT with

composition [0..*] of ZRP_I_PRODUCT_REVIEW as zzProductReview

{
  _Extension.zzTranslationCode,
  _Extension.zzProductGroupNameTranslated,

  zzProductReview
}
