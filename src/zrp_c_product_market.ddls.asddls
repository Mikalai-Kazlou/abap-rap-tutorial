@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Product Markets'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true

define view entity ZRP_C_PRODUCT_MARKET
  as projection on ZRP_I_PRODUCT_MARKET
{
  key ProductUUID,
  key ProductMarketUUID,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_MARKET', element: 'MarketID' } } ]
      @ObjectModel.text.element: ['MarketName']
      @UI.textArrangement: #TEXT_ONLY
      MarketID,
      _Market.MarketName               as MarketName,
      _Market.ImageUrl                 as MarketImageUrl,

      ISOCode,
      Status,
      StartDate,
      EndDate,

      _VirtualFields.StatusCriticality as StatusCriticality,

      CreatedBy,
      @Semantics.dateTime: true
      CreatedOn,
      ChangedBy,
      @Semantics.dateTime: true
      ChangedOn,
      @Semantics.dateTime: true
      LocalChangedOn,

      /* Associations */
      _Product                         as Product      : redirected to parent ZRP_C_PRODUCT,
      _MarketOrder                     as MarketOrders : redirected to composition child ZRP_C_MARKET_ORDER
}
