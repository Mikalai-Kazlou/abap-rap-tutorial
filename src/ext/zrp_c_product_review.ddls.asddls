@EndUserText.label: 'Product Review'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@ObjectModel.semanticKey: [ 'Reviewer' ]

define view entity ZRP_C_PRODUCT_REVIEW
  as projection on ZRP_I_PRODUCT_REVIEW
{
  key ProductUUID,
  key ReviewUUID,
      Rating,
      FreeTextComment,
      HelpfulCount,
      HelpfulTotal,
      Reviewer,
      LocalCreatedAt,
      LocalLastChangedAt,

      /* Associations */
      _Product as Product : redirected to parent ZRP_C_PRODUCT
}
