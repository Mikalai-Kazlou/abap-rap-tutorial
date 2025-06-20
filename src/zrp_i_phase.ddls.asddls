@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Phases'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
@ObjectModel.usageType: { serviceQuality: #X,
                          sizeCategory: #S,
                          dataClass: #MIXED
                        }
define view entity ZRP_I_PHASE
  as select from zrp_d_phase

  association [0..1] to ZRP_I_DOMAIN_FIXED_VALUES as _FixedValues
    on  _FixedValues.DomainName = 'ZRP_PHASE'
    and _FixedValues.Value      = $projection.Phase

{
      @ObjectModel.text.element: ['PhaseText']
  key phaseid           as PhaseID,
      phase             as Phase,
      _FixedValues.Text as PhaseText
}
