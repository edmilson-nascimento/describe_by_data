report describe_by_data .

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
      out      type tab_out,
      fieldcat type slis_t_fieldcat_alv .

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

    methods describe_by_data .

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

    describe_by_data( ).


  endmethod .

  method show .

    if lines( me->out ) eq 0 .
    else .

      me->alv( ) .

    endif .

  endmethod .

  method search .

    refresh:
      mara, makt .

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

  method describe_by_data .

    refresh:
      me->fieldcat .

    data:
      ref_descr     type ref to cl_abap_structdescr,
      line_out      type me->ty_out,
      line_fieldcat type slis_fieldcat_alv,
      pos           type i .

    field-symbols:
      <line> type abap_compdescr .

    ref_descr ?= cl_abap_typedescr=>describe_by_data( line_out ) .

    pos = 1 .

    loop at ref_descr->components assigning <line> .

      line_fieldcat-col_pos      = pos .
      line_fieldcat-fieldname    = <line>-name .
      line_fieldcat-outputlen    = <line>-length .
      line_fieldcat-decimals_out = <line>-decimals .
      line_fieldcat-datatype     = <line>-type_kind .

      append line_fieldcat to me->fieldcat .
      clear  line_fieldcat .

      pos = pos + 1 .

    endloop.


  endmethod .

  method alv .

    if lines( me->out ) eq 0 .
    else .

      call function 'REUSE_ALV_GRID_DISPLAY'
        exporting
*         i_interface_check                 = ' '
*         i_bypassing_buffer                = ' '
*         i_buffer_active                   = ' '
          i_callback_program                = sy-repid
*         i_callback_pf_status_set          = ' '
*         i_callback_user_command           = ' '
*         i_callback_top_of_page            = ' '
*         i_callback_html_top_of_page       = ' '
*         i_callback_html_end_of_list       = ' '
*         i_structure_name                  =
*         i_background_id                   = ' '
*         i_grid_title                      =
*         i_grid_settings                   =
*         is_layout                         =
          it_fieldcat                       = me->fieldcat
*         it_excluding                      =
*         it_special_groups                 =
*         it_sort                           =
*         it_filter                         =
*         is_sel_hide                       =
*         i_default                         = 'x'
*         i_save                            = ' '
*         is_variant                        =
*         it_events                         =
*         it_event_exit                     =
*         is_print                          =
*         is_reprep_id                      =
*         i_screen_start_column             = 0
*         i_screen_start_line               = 0
*         i_screen_end_column               = 0
*         i_screen_end_line                 = 0
*         i_html_height_top                 = 0
*         i_html_height_end                 = 0
*         it_alv_graphics                   =
*         it_hyperlink                      =
*         it_add_fieldcat                   =
*         it_except_qinfo                   =
*         ir_salv_fullscreen_adapter        =
*       importing
*         e_exit_caused_by_caller           =
*         es_exit_caused_by_user            =
        tables
          t_outtab                          = me->out
        exceptions
          program_error                     = 1
          others                            = 2 .

      if sy-subrc <> 0 .
*       implement suitable error handling here
      endif.


    endif .

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
  
  
