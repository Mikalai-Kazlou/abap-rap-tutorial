CLASS zrp_cl_amdp_product_analysis DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_product_analysis
        FOR TABLE FUNCTION zrp_f_product_analysis.

ENDCLASS.


CLASS zrp_cl_amdp_product_analysis IMPLEMENTATION.
  METHOD get_product_analysis BY DATABASE FUNCTION FOR HDB
                              LANGUAGE SQLSCRIPT
                              OPTIONS READ-ONLY
                              USING zrp_i_product
                                    zrp_i_product_market
                                    zrp_i_market_order
                                    zrp_i_market.
    lt_markets =
      select Products.uuid                                   as uuid
           , string_agg( Markets.marketname, '; '
                           order by Markets.marketname asc ) as MarketList
           , count ( distinct Markets.marketid )             as MarketQuantity
        from      zrp_i_product         as Products
       inner join zrp_i_product_market  as ProductMarkets on Products.uuid = ProductMarkets.productuuid
       inner join zrp_i_market          as Markets        on ProductMarkets.marketid = Markets.marketid
       group by
             Products.uuid
    ;

    lt_aggregation =
      select Products.uuid                             as uuid
           , Products.id                               as id
           , Products.name                             as Name
           , Products.phaseid                          as PhaseID
           , Markets.MarketList                        as MarketList
           , Markets.MarketQuantity                    as MarketQuantity
           , count ( distinct MarketOrders.orderuuid ) as OrderQuantity
           , sum (MarketOrders.quantity)               as TotalQuantity
           , SUM ( MarketOrders.netamount )            as TotalNetAmount
           , sum (MarketOrders.grossamount)            as TotalGrossAmount
           , Products.pricecurrency                    as Currency
        from            zrp_i_product       as Products
        left outer join zrp_i_market_order  as MarketOrders on Products.uuid = MarketOrders.productuuid
        left outer join :lt_markets         as Markets      on Products.uuid = Markets.uuid
       group by
             Products.uuid
           , Products.id
           , Products.name
           , Products.phaseid
           , Markets.MarketList
           , Markets.MarketQuantity
           , Products.pricecurrency
       order by
             Products.uuid
           , Products.id
     ;

     return
       select session_context( 'CLIENT') as Client
            , uuid
            , id
            , Name
            , PhaseID
            , MarketList
            , MarketQuantity
            , OrderQuantity
            , TotalQuantity
            , TotalNetAmount
            , TotalGrossAmount
            , Currency
         from :lt_aggregation
     ;

  endmethod.
ENDCLASS.
