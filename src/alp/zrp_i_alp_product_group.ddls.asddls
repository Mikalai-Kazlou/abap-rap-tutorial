@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Groups'
@Metadata.ignorePropagatedAnnotations: true

@Analytics.dataCategory: #DIMENSION

define view entity ZRP_I_ALP_PRODUCT_GROUP
  as select from zrp_d_prod_group
{
      @ObjectModel.text.element: ['ProductGroupName']
  key pgid     as ProductGroupID,

      @Semantics.text: true
      pgname   as ProductGroupName,

      @UI.hidden: true
      imageurl as ImageUrl
}
