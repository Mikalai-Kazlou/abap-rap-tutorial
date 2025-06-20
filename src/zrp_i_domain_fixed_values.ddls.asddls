@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Domain Fixed Values'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZRP_I_DOMAIN_FIXED_VALUES
  as select from    dd07l as FixedValue
    left outer join dd07t as ValueText
      on  ValueText.domname    = FixedValue.domname
      and ValueText.ddlanguage = $session.system_language
      and ValueText.as4local   = FixedValue.as4local
      and ValueText.valpos     = FixedValue.valpos
      and ValueText.as4vers    = FixedValue.as4vers
      and ValueText.domvalue_l = FixedValue.domvalue_l

{
  key FixedValue.domname    as DomainName,
  key FixedValue.domvalue_l as Value,
      ValueText.ddtext      as Text
}

where
  FixedValue.as4local = 'A' -- Active
