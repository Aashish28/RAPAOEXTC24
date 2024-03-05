CLASS lsc_yr_ext_producttp DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lsc_yr_ext_producttp IMPLEMENTATION.

  METHOD adjust_numbers.
   DATA: lv_max type yztprodbom-productid,
         lv_productid type yztprodbom-productid.

   loop at mapped-zzyztprodbom REFERENCE INTO data(map).

       lv_productid = map->%tmp-Productid.

       if lv_max is initial.
           select max( bomid ) from yi_prodbom
           WHERE Productid = @lv_productid
           into @lv_max.
       endif.

        lv_max = lv_max + 1.
        map->Bomid = lv_max.
        map->Productid = lv_productid.
   ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_yr_product DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS zz_checkproductname FOR VALIDATE ON SAVE
      IMPORTING keys FOR YR_PRODUCT~zz_checkproductname.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR YR_PRODUCT RESULT result.

    METHODS zzaddReview FOR MODIFY
      IMPORTING keys FOR ACTION YR_PRODUCT~zzaddReview RESULT result.

ENDCLASS.

CLASS lhc_yr_product IMPLEMENTATION.

  METHOD zz_checkproductname.

      READ ENTITIES OF YI_YR_PRODUCTTP IN LOCAL MODE
            ENTITY yr_product
            ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_product).

    LOOP AT lt_product INTO DATA(lw_product).
      APPEND VALUE #( %tky           = lw_product-%tky
                      %state_area    = 'CHECK_UOM' )
             TO reported-yr_product.
      DATA(lv_uom)             =  lw_product-Uom.
      IF lv_uom IS INITIAL  .
        APPEND VALUE #( %tky           = lw_product-%tky ) TO failed-yr_product.
        APPEND VALUE #( %tky           = lw_product-%tky
                        %state_area    = 'CHECK_UOM'
                        %msg           = new_message_with_text(
                                            severity = if_abap_behv_message=>severity-error
                                            text     = 'UOM cannot be initial'
                       ) )
                TO reported-yr_product.
      ENDIF.
    ENDLOOP.


  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD zzaddReview.

    MODIFY ENTITIES OF yi_yr_producttp in LOCAL MODE
      ENTITY yr_product
      UPDATE FIELDS ( zz_review_yza ) WITH VALUE #( FOR key IN keys INDEX INTO i (
            %tky          = key-%tky
            zz_review_yza     = key-%param-review
      ) ).

      READ ENTITIES OF yi_yr_producttp in LOCAL MODE
      ENTITY yr_product
      ALL FIELDS
            WITH CORRESPONDING #( keys )
            RESULT DATA(lt_product).

      result = VALUE #( FOR lw_read IN lt_product ( %tky   = lw_read-%tky
                                                   %param = lw_read ) ).

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
