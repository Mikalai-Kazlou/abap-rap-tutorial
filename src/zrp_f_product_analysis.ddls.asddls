@EndUserText.label: 'Product Analysis'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@ClientHandling: { type: #CLIENT_DEPENDENT,
                   algorithm: #SESSION_VARIABLE }

define table function ZRP_F_PRODUCT_ANALYSIS
returns
{
  Client           : abap.clnt;
  UUID             : sysuuid_x16;
  ID               : zrp_product_id;
  Name             : zrp_pg_name;
  PhaseID          : zrp_phase_id;
  MarketList       : abap.char(1024);
  MarketQuantity   : abap.int4;
  OrderQuantity    : abap.int4;
  TotalQuantity    : abap.int4;
  TotalNetAmount   : zrp_amount_net;
  TotalGrossAmount : zrp_amount_gross;
  Currency         : waers_curc;
}
implemented by method
  zrp_cl_amdp_product_analysis=>get_product_analysis;