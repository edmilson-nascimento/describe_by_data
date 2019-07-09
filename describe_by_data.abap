*&---------------------------------------------------------------------*
*& Report  YTESTE
*&
*&---------------------------------------------------------------------*
*&
*&
*&---------------------------------------------------------------------*

REPORT  YTESTE.

tables:
  mara .


class local definition .

  public section .

    methods get
      exporting
        !matnr type ism_matnr_range_tab .

    methods show .

    types:
    begin of ty_out,
      matnr type mara-matnr,
      maktx type makt-maktx,
    end of ty_out .

  protected section .

  private section .

    methods search .

    methods organize .

    methods fieldcat .

    methods alv .

endclass .

class local implementation .

  method get .



  endmethod .

  method show .
  endmethod .

  method search .
  endmethod .

  method organize .
  endmethod .

  method fieldcat .

*    data : it_details type abap_compdescr_tab.
*    data : ref_descr type ref to cl_abap_structdescr.
*
*    ref_descr ?= cl_abap_typedescr=>describe_by_data( <dyn_wa> ).
*    it_details[] = ref_descr->components[].
*
**   Write out data from table.
*    loop at <dyn_table> into <dyn_wa>.
*      do.
*        assign component  sy-index  of structure <dyn_wa> to <dyn_field>.
*        if sy-subrc <> 0.
*          exit.
*        endif.
*        if sy-index = 1.
*          write:/ <dyn_field>.
*        else.
*          write: <dyn_field>.
*        endif.
*      enddo.
*    endloop.

  endmethod .

  method alv .
  endmethod .


endclass .


data:
  obj type ref to local .

selection-screen begin of block b1 with frame title text-001.
  select-options:
    s_matnr for mara-matnr obligatory.
selection-screen end of block b1.


initialization .

start-of-selection .

  create object obj .

  obj->get(
    importing
      matnr = s_matnr[]
  ).

  obj->show( ) .