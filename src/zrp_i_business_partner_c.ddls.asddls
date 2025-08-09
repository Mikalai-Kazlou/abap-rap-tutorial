@EndUserText.label: 'Business Partner (Custom Entity)'
@ObjectModel.query.implementedBy: 'ABAP:ZRP_CL_BP_QUERY_PROVIDER'
define custom entity ZRP_I_BUSINESS_PARTNER_C
{
  key business_partner : zrp_business_partner_id;
      company_name     : zrp_business_partner;
      email_address    : zrp_business_partner_email;
      phone_number     : zrp_business_partner_phone;
}
