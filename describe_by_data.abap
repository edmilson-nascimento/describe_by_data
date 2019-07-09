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
      pstat type mara-pstat,
      mtart type mara-mtart,
      brgew type mara-brgew,
      ntgew type mara-ntgew,
    end of ty_out,

    begin of ty_mara,
      matnr type mara-matnr,
      pstat type mara-pstat,
      mtart type mara-mtart,
      brgew type mara-brgew,
      ntgew type mara-ntgew,
    end of ty_mara,

    begin of ty_makt,
      matnr type makt-matnr,
      spras type makt-spras,
      maktx type makt-maktx,
    end of ty_makt,

    tab_out  type table of ty_out,
    tab_mara type table of ty_mara,
    tab_makt type table of ty_makt .

  protected section .

    data:
      out type tab_out .

  private section .

    methods search
      importing
        !matnr type ism_matnr_range_tab
      exporting
        !mara  type tab_mara
        !makt  type tab_makt .

    methods organize
      importing
        !mara  type tab_mara
        !makt  type tab_makt .

    methods fieldcat .

    methods alv .

endclass .

class local implementation .

  method get .

    data:
      mara type table of ty_mara,
      makt type table of ty_makt .

    search(
      exporting
        matnr = matnr
      importing
        mara  = mara
        makt  = makt
    ).

    organize(
      exporting
        mara  = mara
        makt  = makt
    ).

*    fieldcat(
*      exporting
*
*    ).



  endmethod .

  method show .
  endmethod .

  method search .

    refresh:
      out, mara, makt .

    select matnr pstat mtart brgew ntgew
      into table mara
      from mara
     where matnr in matnr .

    if sy-subrc eq 0 .

      select matnr spras maktx
        into table makt
        from makt
         for all entries in mara
       where matnr eq mara-matnr
         and spras eq sy-langu .

      if sy-subrc eq 0 .
      endif .

    endif .



  endmethod .

  method organize .

    data:
      line type me->ty_out .

    field-symbols:
      <fs_mara> type me->ty_mara,
      <fs_makt> type me->ty_makt .

    refresh:
      me->out .

    if ( lines( mara ) gt 0 ) and
       ( lines( makt ) gt 0 ) .

      loop at mara assigning <fs_mara> .

        line-matnr = <fs_mara>-matnr .
        line-pstat = <fs_mara>-pstat .
        line-mtart = <fs_mara>-mtart .
        line-brgew = <fs_mara>-brgew .
        line-ntgew = <fs_mara>-ntgew .

        read table makt assigning <fs_makt>
          with key matnr = <fs_mara>-matnr .

        if sy-subrc eq 0 .

          line-maktx = <fs_makt>-maktx .

          append line to me->out .
          clear line .

        endif .

      endloop .

    endif .

    unassign:
      <fs_mara>, <fs_makt> .

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