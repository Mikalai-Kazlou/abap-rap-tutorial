@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

@ObjectModel: { semanticKey: ['Name'],
                representativeKey: 'ID',
                dataCategory: #VALUE_HELP
              }

@UI.presentationVariant: [{ sortOrder: [{ by: 'Name', direction: #ASC }] }]

define view entity ZRP_I_PRODUCT_VH
  as select from ZRP_I_PRODUCT
{

      @UI.hidden: true
  key UUID,

      @ObjectModel.text.element: [ 'Name' ]
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
  key ID,

      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
      Name
}
