@Metadata.allowExtensions: true
@EndUserText.label: 'Products'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ObjectModel.sapObjectNodeType.name: 'ZRPAPRODUCT_API'
define root view entity ZC_RP_PRODUCT_API
  provider contract transactional_query
  as projection on ZR_RP_PRODUCT_API
{
  key Uuid,
      Id,
      Name,
      Price,
      @Semantics.currencyCode: true
      Pricecurrency,
      Taxrate,
      Createdby,
      Createdat,
      Changedby,
      Changedat,
      Localchangedby,
      Localchangedat

}
