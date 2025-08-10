extend view entity ZRP_C_PRODUCT with
{
  @Consumption.valueHelpDefinition: [ { entity: { name: 'ZRP_I_TRANSLATION_LANGUAGE', element: 'LanguageCode' } } ]
  Product.zzTranslationCode,
  Product.zzProductGroupNameTranslated
}
