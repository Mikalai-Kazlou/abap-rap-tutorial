@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'UoMs'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRP_I_UOM
  as select from zrp_d_uom
{
  key msehi       as UoM,
      dimensionid as DimensionID,
      isocode     as IsoCode
}
