@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phases'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType: { serviceQuality: #X,
                          sizeCategory: #S,
                          dataClass: #MIXED }

@UI.presentationVariant: [ { sortOrder: [ { by: 'PhaseID', direction: #ASC } ] } ]

define view entity ZRP_I_PHASE
  as select from zrp_d_phase

  association [0..*] to DDCDS_CUSTOMER_DOMAIN_VALUE_T as _FixedValues
    on  _FixedValues.domain_name = 'ZRP_PHASE'
    and _FixedValues.language    = $session.system_language
    and _FixedValues.value_low   = $projection.Phase

{
      @ObjectModel.text.element: ['PhaseText']
  key phaseid                                         as PhaseID,
      phase                                           as Phase,
      _FixedValues( p_domain_name: 'ZRP_PHASE' ).text as PhaseText
}
