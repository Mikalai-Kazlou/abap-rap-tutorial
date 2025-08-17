CLASS zrp_cl_generate_data_mstr DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zrp_cl_generate_data_mstr IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_prod_grs TYPE TABLE OF zrp_d_prod_group.
    DATA lt_phases   TYPE TABLE OF zrp_d_phase.
    DATA lt_markets  TYPE TABLE OF zrp_d_market.
    DATA lt_uom      TYPE TABLE OF zrp_d_uom.

    " PRODUCT GROUPS
    lt_prod_grs = VALUE #(
        ( pgid     = '1'
          pgname   = 'Microwave'
          imageurl = 'https://dummyjson.com/image/500x500/4B9BE1/FFFFFF?text=Microwave' )
        ( pgid     = '2'
          pgname   = 'Coffee Machine'
          imageurl = 'https://dummyjson.com/image/500x500/4B9BE1/FFFFFF?text=Coffee Machine' )
        ( pgid     = '3'
          pgname   = 'Waffle Iron'
          imageurl = 'https://dummyjson.com/image/500x500/4B9BE1/FFFFFF?text=Waffle Iron' )
        ( pgid     = '4'
          pgname   = 'Blender'
          imageurl = 'https://dummyjson.com/image/500x500/4B9BE1/FFFFFF?text=Blender' )
        ( pgid     = '5'
          pgname   = 'Cooker'
          imageurl = 'https://dummyjson.com/image/500x500/4B9BE1/FFFFFF?text=Cooker' ) ).

    " Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zrp_d_prod_group.
    " Insert the new table entries
    INSERT zrp_d_prod_group FROM TABLE @lt_prod_grs.

    " Check the result
    SELECT * FROM zrp_d_prod_group INTO TABLE @lt_prod_grs.
    out->write( sy-dbcnt ).
    out->write( 'Product Groups data inserted successfully!' ).

    " PHASES
    lt_phases = VALUE #( ( phaseid = '1' phase = 'PLAN' )
                         ( phaseid = '2' phase = 'DEV' )
                         ( phaseid = '3' phase = 'PROD' )
                         ( phaseid = '4' phase = 'OUT' ) ).

    " Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zrp_d_phase.
    " Insert the new table entries
    INSERT zrp_d_phase FROM TABLE @lt_phases.

    " Check the result
    SELECT * FROM zrp_d_phase INTO TABLE @lt_phases.
    out->write( sy-dbcnt ).
    out->write( 'Phases data inserted successfully!' ).

    " MARKETS
    lt_markets = VALUE #(
        ( mrktid   = '1'
          mrktname = 'Russia'
          langcode = 'RU'
          imageurl = 'https://flagpedia.net/data/flags/w1160/ru.webp' )
        ( mrktid   = '2'
          mrktname = 'Belarus'
          langcode = 'RU'
          imageurl = 'https://flagpedia.net/data/flags/w1160/by.webp' )
        ( mrktid   = '3'
          mrktname = 'United Kingdom'
          langcode = 'EN'
          imageurl = 'https://flagpedia.net/data/flags/w1160/gb.webp' )
        ( mrktid   = '4'
          mrktname = 'France'
          langcode = 'FR'
          imageurl = 'https://flagpedia.net/data/flags/w1160/fr.webp' )
        ( mrktid   = '5'
          mrktname = 'Germany'
          langcode = 'DE'
          imageurl = 'https://flagpedia.net/data/flags/w1160/de.webp' )
        ( mrktid   = '6'
          mrktname = 'Italy'
          langcode = 'IT'
          imageurl = 'https://flagpedia.net/data/flags/w1160/it.webp' )
        ( mrktid   = '7'
          mrktname = 'USA'
          langcode = 'EN'
          imageurl = 'https://flagpedia.net/data/flags/w1160/us.webp' )
        ( mrktid   = '8'
          mrktname = 'Japan'
          langcode = 'JP'
          imageurl = 'https://flagpedia.net/data/flags/w1160/jp.webp' )
        ( mrktid   = '9'
          mrktname = 'Poland'
          langcode = 'EN'
          imageurl = 'https://flagpedia.net/data/flags/w1160/pl.webp' )
        ( mrktid   = '10'
          mrktname = 'Spain'
          langcode = 'ES'
          imageurl = 'https://flagpedia.net/data/flags/w1160/es.webp' ) ).

    " Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zrp_d_market.
    " Insert the new table entries
    INSERT zrp_d_market FROM TABLE @lt_markets.

    " Check the result
    SELECT * FROM zrp_d_market INTO TABLE @lt_markets.
    out->write( sy-dbcnt ).
    out->write( 'Markets data inserted successfully!' ).

    " UOM
    lt_uom = VALUE #( dimensionid = 'LENGTH'
                      ( msehi = 'CM'  isocode = 'CMT' )
                      ( msehi = 'DM'  isocode = 'DMT' )
                      ( msehi = 'FT'  isocode = 'FOT' )
                      ( msehi = 'IN'  isocode = 'INH' )
                      ( msehi = 'KM'  isocode = 'KMT' )
                      ( msehi = 'M'   isocode = 'MTR' )
                      ( msehi = 'MI'  isocode = 'SMI' )
                      ( msehi = 'MIM' isocode = '4H' )
                      ( msehi = 'MM'  isocode = 'MMT' )
                      ( msehi = 'NAM' isocode = 'C45' )
                      ( msehi = 'YD'  isocode = 'YRD' ) ).

    " Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zrp_d_uom.
    " Insert the new table entries
    INSERT zrp_d_uom FROM TABLE @lt_uom.

    " Check the result
    SELECT * FROM zrp_d_uom INTO TABLE @lt_uom.
    out->write( sy-dbcnt ).
    out->write( 'UOM data inserted successfully!' ).
  ENDMETHOD.
ENDCLASS.
