@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Users'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}

define view entity ZRP_I_USER
  as select from zrp_d_user

  association [0..1] to I_Country as _Country
    on $projection.Country = _Country.Country
{
  key id                                                                 as ID,

      @Semantics.name.fullName: true
      concat_with_space( firstname, lastname, 1 )                        as FullName,

      @Consumption.filter.hidden: true
      @Consumption.valueHelpDefault.display: true
      @ObjectModel.text.element: ['CountryText']
      @UI.textArrangement: #TEXT_ONLY
      @EndUserText.label: 'Country'
      country                                                            as Country,

      @Consumption.filter.hidden: true
      @Consumption.valueHelpDefault.display: false
      @Semantics.address.country: true
      @Semantics.address.type: [#WORK]
      _Country._Text[1: Language = $session.system_language].CountryName as CountryText,

      @Semantics.address.street: true
      @Semantics.address.type: [#WORK]
      street                                                             as Street,

      @Semantics.address.city: true
      @Semantics.address.type: [#WORK]
      city                                                               as City,

      @Semantics.address.zipCode: true
      @Semantics.address.type: [#WORK]
      postcode                                                           as PostCode,

      @Semantics.imageUrl: true
      photourl                                                           as PhotoUrl,

      @Semantics.telephone.type: [ #WORK]
      phone                                                              as Phone,

      @Semantics.eMail.address: true
      @Semantics.eMail.type: [#WORK]
      email                                                              as Email,

      /* Associations */
      _Country
}
