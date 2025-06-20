CLASS zrp_cl_generate_data DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.


CLASS zrp_cl_generate_data IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DATA lt_prod_grs TYPE TABLE OF zrp_d_prod_group.
    DATA lt_phases   TYPE TABLE OF zrp_d_phase.
    DATA lt_markets  TYPE TABLE OF zrp_d_market.
    DATA lt_uom      TYPE TABLE OF zrp_d_uom.

    " PRODUCT GROUPS
    lt_prod_grs = VALUE #(
        ( pgid     = '1'
          pgname   = 'Microwave'
          imageurl = 'https://png.pngtree.com/png-clipart/20190517/original/pngtree-vector-microwave-oven-icon-png-image_4015182.jpg' )
        ( pgid     = '2'
          pgname   = 'Coffee Machine'
          imageurl = 'https://icon-library.com/images/coffee-maker-icon/coffee-maker-icon-13.jpg' )
        ( pgid     = '3'
          pgname   = 'Waffle Iron'
          imageurl = 'https://previews.123rf.com/images/anatolir/anatolir1810/anatolir181004863/110698658-waffle-maker-icon-outline-style.jpg' )
        ( pgid     = '4'
          pgname   = 'Blender'
          imageurl = 'https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRSLnFTOSs5ZV0d8pwhPzs4KANsvq1oZ7hyrg&usqp=CAU' )
        ( pgid     = '5'
          pgname   = 'Cooker'
          imageurl = 'https://st4.depositphotos.com/18657574/22404/v/1600/depositphotos_224044856-stock-illustration-stove-concept-vector-linear-icon.jpg' ) ).

    " Delete the possible entries in the database table - in case it was already filled
    DELETE FROM zrp_d_prod_group.
    " Insert the new table entries
    INSERT zrp_d_prod_group FROM TABLE @lt_prod_grs.

    " Check the result
    SELECT * FROM zrp_d_prod_group INTO TABLE @lt_prod_grs.
    out->write( sy-dbcnt ).
    out->write( 'Product Groups data inserted successfully!' ).

    " PHASES
    lt_phases = VALUE #( ( phaseid  = '1' phase = 'PLAN' )
                         ( phaseid  = '2' phase = 'DEV' )
                         ( phaseid  = '3' phase = 'PROD' )
                         ( phaseid  = '4' phase = 'OUT' ) ).

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
          imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940426/russia-flag-image-free-download.jpg' )
        ( mrktid   = '2'
          mrktname = 'Belarus'
          langcode = 'RU'
          imageurl = 'https://cdn.countryflags.com/thumbs/belarus/flag-400.png' )
        ( mrktid   = '3'
          mrktname = 'United Kingdom'
          langcode = 'EN'
          imageurl = 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ae/Flag_of_the_United_Kingdom.svg/640px-Flag_of_the_United_Kingdom.svg.png' )
        ( mrktid   = '4'
          mrktname = 'France'
          langcode = 'FR'
          imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54002660/france-flag-image-free-download.jpg' )
        ( mrktid   = '5'
          mrktname = 'Germany'
          langcode = 'DE'
          imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54006402/germany-flag-image-free-download.jpg' )
        ( mrktid   = '6'
          mrktname = 'Italy'
          langcode = 'IT'
          imageurl = 'https://cdn.countryflags.com/thumbs/italy/flag-400.png' )
        ( mrktid   = '7'
          mrktname = 'USA'
          langcode = 'EN'
          imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54958906/the-united-states-flag-image-free-download.jpg' )
        ( mrktid   = '8'
          mrktname = 'Japan'
          langcode = 'EN'
          imageurl = 'https://image.freepik.com/free-vector/illustration-japan-flag_53876-27128.jpg' )
        ( mrktid   = '9'
          mrktname = 'Poland'
          langcode = 'EN'
          imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' )
        ( mrktid   = '10'
          mrktname = 'Spain'
          langcode = 'ES'
          imageurl = 'https://cdn.webshopapp.com/shops/94414/files/54940016/poland-flag-image-free-download.jpg' ) ).

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
