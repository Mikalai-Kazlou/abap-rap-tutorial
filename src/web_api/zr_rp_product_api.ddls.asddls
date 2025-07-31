@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: 'Products'
@ObjectModel.sapObjectNodeType.name: 'ZRPAPRODUCT_API'
define root view entity ZR_RP_PRODUCT_API
  as select from zrpaproduct
{
  key uuid           as Uuid,
      id             as Id,
      name           as Name,
      @Semantics.amount.currencyCode: 'Pricecurrency'
      price          as Price,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_CurrencyStdVH',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      pricecurrency  as Pricecurrency,
      taxrate        as Taxrate,
      @Semantics.user.createdBy: true
      createdby      as Createdby,
      @Semantics.systemDateTime.createdAt: true
      createdat      as Createdat,
      @Semantics.user.lastChangedBy: true
      changedby      as Changedby,
      @Semantics.systemDateTime.lastChangedAt: true
      changedat      as Changedat,
      @Semantics.user.localInstanceLastChangedBy: true
      localchangedby as Localchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      localchangedat as Localchangedat

}
