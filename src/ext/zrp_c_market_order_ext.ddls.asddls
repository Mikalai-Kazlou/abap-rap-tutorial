extend view entity ZRP_C_MARKET_ORDER with
{
  @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_BUSINESS_PARTNER_C', element: 'business_partner' },
                                        additionalBinding: [ { element: 'company_name',  localElement: 'zzBusinessPartner',      usage: #RESULT },
                                                             { element: 'email_address', localElement: 'zzBusinessPartnerEmail', usage: #RESULT },
                                                             { element: 'phone_number',  localElement: 'zzBusinessPartnerPhone', usage: #RESULT } ] } ]
  @ObjectModel.text.element: ['zzBusinessPartner']
  @UI.textArrangement: #TEXT_ONLY
  MarketOrder.zzBusinessPartnerID,
  @Semantics.text: true
  MarketOrder.zzBusinessPartner,
  MarketOrder.zzBusinessPartnerEmail,
  MarketOrder.zzBusinessPartnerPhone
}
