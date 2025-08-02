@AbapCatalog.viewEnhancementCategory: [ #NONE ]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Groups'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #S, dataClass: #MIXED }
@Search.searchable: true

define view entity ZRP_I_PRODUCT_GROUP
  as select from zrp_d_prod_group
{
      @ObjectModel.text.element: [ 'ProductGroupName' ]
      @Search.defaultSearchElement: true
  key pgid     as ProductGroupID,
      
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      pgname   as ProductGroupName,

      @UI.hidden: true
      imageurl as ImageUrl
}
