@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.sapObjectNodeType.name: 'ZRPAPRODUCT'
define root view entity ZC_RP_PRODUCT
  provider contract transactional_query
  as projection on ZR_RP_PRODUCT
{
  key Uuid,
      Id,
      Name,
      Price,
      @Semantics.currencyCode: true
      Pricecurrency,
      Taxrate,

      _Extended.Criticality,

      Createdby,
      Createdat,
      Changedby,
      Changedat,
      Localchangedby,
      Localchangedat

}
