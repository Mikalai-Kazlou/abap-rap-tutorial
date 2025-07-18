@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.sapObjectNodeType.name: 'ZRPAPRODUCT'
define root view entity ZR_RP_PRODUCT
  as select from zrpaproduct as Product
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
