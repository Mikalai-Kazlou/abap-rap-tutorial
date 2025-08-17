@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
@EndUserText.label: '###GENERATED Core Data Service Entity'
@ObjectModel.sapObjectNodeType.name: 'ZRPAPRODUCT'
define root view entity ZR_RP_PRODUCT
  as select from ZI_RP_PRODUCT as Product

  association [1] to ZI_RP_PRODUCT as _Extended
    on _Extended.Uuid = $projection.Uuid
{
  key Uuid           as Uuid,
      Id             as Id,
      Name           as Name,
      @Semantics.amount.currencyCode: 'Pricecurrency'
      Price          as Price,
      @Consumption.valueHelpDefinition: [ {
        entity.name: 'I_CurrencyStdVH',
        entity.element: 'Currency',
        useForValidation: true
      } ]
      Pricecurrency  as Pricecurrency,
      Taxrate        as Taxrate,

      @Semantics.user.createdBy: true
      Createdby      as Createdby,
      @Semantics.systemDateTime.createdAt: true
      Createdat      as Createdat,
      @Semantics.user.lastChangedBy: true
      Changedby      as Changedby,
      @Semantics.systemDateTime.lastChangedAt: true
      Changedat      as Changedat,
      @Semantics.user.localInstanceLastChangedBy: true
      Localchangedby as Localchangedby,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      Localchangedat as Localchangedat,

      _Extended

}
