@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface for ZR_RP_PRODUCT'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZI_RP_PRODUCT
  as select from zrpaproduct
{
  key uuid           as Uuid,
      id             as Id,
      name           as Name,
      @Semantics.amount.currencyCode: 'Pricecurrency'
      price          as Price,
      pricecurrency  as Pricecurrency,
      taxrate        as Taxrate,

      3              as Criticality,

      createdby      as Createdby,
      createdat      as Createdat,
      changedby      as Changedby,
      changedat      as Changedat,
      localchangedby as Localchangedby,
      localchangedat as Localchangedat
}
