@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Markets'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

@ObjectModel: { semanticKey: ['MarketName'],
                representativeKey: 'MarketID',
                resultSet.sizeCategory: #XS,
                dataCategory: #VALUE_HELP
              }

@UI.presentationVariant: [{ sortOrder: [{ by: 'MarketName', direction: #ASC }] }]

define view entity ZRP_I_MARKET_VH
  as select from ZRP_I_MARKET
{
      @ObjectModel.text.element: [ 'MarketName' ]
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key MarketID,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      MarketName
}
