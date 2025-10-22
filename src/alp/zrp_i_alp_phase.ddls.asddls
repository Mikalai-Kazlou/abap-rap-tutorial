@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phases'
@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType: { serviceQuality: #X,
                          sizeCategory: #S,
                          dataClass: #MIXED }

@Analytics.dataCategory: #DIMENSION

@UI.presentationVariant: [ { sortOrder: [ { by: 'PhaseID', direction: #ASC } ] } ]

define view entity ZRP_I_ALP_PHASE
  as select from zrp_d_phase

  association [0..*] to DDCDS_CUSTOMER_DOMAIN_VALUE_T as _DomainFixedValues
    on  _DomainFixedValues.domain_name = 'ZRP_PHASE'
    and _DomainFixedValues.language    = $session.system_language
    and _DomainFixedValues.value_low   = $projection.Phase

{
      @ObjectModel.text.element: ['PhaseText']
      @UI.textArrangement: #TEXT_ONLY
  key phaseid                                         as PhaseID,

      @UI.hidden: true
      phase                                           as Phase,

      @Semantics.text: true
      @EndUserText.label: 'Product Life Cycle Phase'
      _DomainFixedValues( p_domain_name: 'ZRP_PHASE' )
                            [1: language = 'E' ].text as PhaseText
}
