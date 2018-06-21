REPORT ztrcktrsr_loop_performance_cmp.
" http://www.abapforum.com/forum/viewtopic.php?f=1&t=21900&p=82017#p82017

PARAMETERS p TYPE i DEFAULT 100000.

CLASS help DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS rnd_name RETURNING VALUE(name) TYPE string.
    CLASS-METHODS rnd_bool RETURNING VALUE(tf) TYPE boolean.
    CLASS-METHODS class_constructor.
  PROTECTED SECTION.
    CLASS-DATA rnd  TYPE REF TO cl_abap_random.
ENDCLASS.

CLASS help_standard DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.
    CLASS-METHODS p01_reduce.
    CLASS-METHODS p02_filter.
    CLASS-METHODS p03_loop_case.
    CLASS-METHODS p04_loop_where.
    CLASS-METHODS p05_loop_case_fs.
    CLASS-METHODS p06_loop_where_fs.
    CLASS-METHODS p07_loop_where_no.
  PROTECTED SECTION.
    TYPES:
      BEGIN OF lst_names,
        name TYPE string,
        tf   TYPE abap_bool,
      END OF lst_names,
      ltt_names TYPE STANDARD TABLE OF lst_names
                WITH NON-UNIQUE KEY name
                WITH NON-UNIQUE SORTED KEY key_tf COMPONENTS tf.

    CLASS-DATA names TYPE ltt_names.
ENDCLASS.

CLASS help_sorted DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS class_constructor.
    CLASS-METHODS p01_reduce.
    CLASS-METHODS p02_filter.
    CLASS-METHODS p03_loop_case.
    CLASS-METHODS p04_loop_where.
    CLASS-METHODS p05_loop_case_fs.
    CLASS-METHODS p06_loop_where_fs.
    CLASS-METHODS p07_loop_where_no.
  PROTECTED SECTION.
    TYPES:
      BEGIN OF lst_names,
        name TYPE string,
        tf   TYPE abap_bool,
      END OF lst_names,

      ltt_names TYPE SORTED TABLE OF lst_names
                WITH NON-UNIQUE KEY name
                WITH NON-UNIQUE SORTED KEY key_tf COMPONENTS tf.
    CLASS-DATA names TYPE ltt_names.
ENDCLASS.

CLASS help IMPLEMENTATION.
  METHOD class_constructor.
    rnd   = cl_abap_random=>create( ).
  ENDMETHOD.

  METHOD rnd_name.
    DATA(len) = rnd->intinrange( low = 5 high = 40 ).
    DO len TIMES.
      DATA(pos) = rnd->intinrange( low = 0 high = 25 ).
      name = name && sy-abcde+pos(1).
    ENDDO.
  ENDMETHOD.

  METHOD rnd_bool.
    CASE rnd->intinrange( low = 0 high = 1 ).
      WHEN 0.
        tf = abap_false.
      WHEN 1.
        tf = abap_true.
    ENDCASE.
  ENDMETHOD.

ENDCLASS.

CLASS help_standard IMPLEMENTATION.
  METHOD class_constructor.
    names = VALUE ltt_names( FOR i = 1 THEN i + 1 WHILE i <= p
                            ( name = help=>rnd_name( )  tf = help=>rnd_bool( ) ) ).
  ENDMETHOD.

  METHOD p01_reduce.
    TYPES:
      BEGIN OF stf,
        tf    TYPE abap_bool,
        count TYPE i,
      END OF stf,
      ttf TYPE SORTED TABLE OF stf WITH UNIQUE KEY tf.

    DATA(sum) = VALUE ttf( FOR GROUPS grp OF <name> IN names
                           WHERE ( name IS NOT INITIAL )
                           GROUP BY ( tf = <name>-tf )
                            ( tf    = grp
                              count = REDUCE #( INIT i = 0
                                                FOR name IN names
                                                WHERE ( tf = grp )
                                                NEXT i = i + 1 ) ) ).
  ENDMETHOD.

  METHOD p02_filter.
    DATA(lv_true)   = lines( FILTER #( names USING KEY key_tf WHERE tf = abap_true  ) ).
    DATA(lv_false)  = lines( FILTER #( names USING KEY key_tf WHERE tf = abap_false ) ).

  ENDMETHOD.

  METHOD p03_loop_case.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names INTO DATA(name).
      CASE name-tf.
        WHEN abap_true.  ADD 1 TO lv_true.
        WHEN abap_false. ADD 1 TO lv_false.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD p04_loop_where.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names INTO DATA(name) WHERE tf = abap_true.
      ADD 1 TO lv_true.
    ENDLOOP.
    LOOP AT names INTO name WHERE tf = abap_false.
      ADD 1 TO lv_false.
    ENDLOOP.

  ENDMETHOD.

  METHOD p05_loop_case_fs.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names ASSIGNING FIELD-SYMBOL(<name>).
      CASE <name>-tf.
        WHEN abap_true.  ADD 1 TO lv_true.
        WHEN abap_false. ADD 1 TO lv_false.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD p06_loop_where_fs.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names ASSIGNING FIELD-SYMBOL(<name>) WHERE tf = abap_true.
      ADD 1 TO lv_true.
    ENDLOOP.
    LOOP AT names ASSIGNING <name> WHERE tf = abap_false.
      ADD 1 TO lv_false.
    ENDLOOP.

  ENDMETHOD.

  METHOD p07_loop_where_no.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names TRANSPORTING NO FIELDS WHERE tf = abap_true.
      ADD 1 TO lv_true.
    ENDLOOP.
    LOOP AT names TRANSPORTING NO FIELDS WHERE tf = abap_false.
      ADD 1 TO lv_false.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS help_sorted IMPLEMENTATION.
  METHOD class_constructor.
    names = VALUE ltt_names( FOR i = 1 THEN i + 1 WHILE i <= p
                            ( name = help=>rnd_name( )  tf = help=>rnd_bool( ) ) ).

  ENDMETHOD.

  METHOD p01_reduce.
    TYPES:
      BEGIN OF stf,
        tf    TYPE abap_bool,
        count TYPE i,
      END OF stf,
      ttf TYPE SORTED TABLE OF stf WITH UNIQUE KEY tf.

    DATA(sum) = VALUE ttf( FOR GROUPS grp OF <name> IN names
                           WHERE ( name IS NOT INITIAL )
                           GROUP BY ( tf = <name>-tf )
                            ( tf    = grp
                              count = REDUCE #( INIT i = 0
                                                FOR name IN names
                                                WHERE ( tf = grp )
                                                NEXT i = i + 1 ) ) ).
  ENDMETHOD.

  METHOD p02_filter.
    DATA(lv_true)   = lines( FILTER #( names USING KEY key_tf WHERE tf = abap_true  ) ).
    DATA(lv_false)  = lines( FILTER #( names USING KEY key_tf WHERE tf = abap_false ) ).

  ENDMETHOD.

  METHOD p03_loop_case.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names INTO DATA(name).
      CASE name-tf.
        WHEN abap_true.  ADD 1 TO lv_true.
        WHEN abap_false. ADD 1 TO lv_false.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD p04_loop_where.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names INTO DATA(name) WHERE tf = abap_true.
      ADD 1 TO lv_true.
    ENDLOOP.
    LOOP AT names INTO name WHERE tf = abap_false.
      ADD 1 TO lv_false.
    ENDLOOP.

  ENDMETHOD.

  METHOD p05_loop_case_fs.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names ASSIGNING FIELD-SYMBOL(<name>).
      CASE <name>-tf.
        WHEN abap_true.  ADD 1 TO lv_true.
        WHEN abap_false. ADD 1 TO lv_false.
      ENDCASE.
    ENDLOOP.

  ENDMETHOD.

  METHOD p06_loop_where_fs.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names ASSIGNING FIELD-SYMBOL(<name>) WHERE tf = abap_true.
      ADD 1 TO lv_true.
    ENDLOOP.
    LOOP AT names ASSIGNING <name> WHERE tf = abap_false.
      ADD 1 TO lv_false.
    ENDLOOP.

  ENDMETHOD.

  METHOD p07_loop_where_no.

    DATA lv_true  TYPE i.
    DATA lv_false TYPE i.

    LOOP AT names TRANSPORTING NO FIELDS WHERE tf = abap_true.
      ADD 1 TO lv_true.
    ENDLOOP.
    LOOP AT names TRANSPORTING NO FIELDS WHERE tf = abap_false.
      ADD 1 TO lv_false.
    ENDLOOP.

  ENDMETHOD.


ENDCLASS.

START-OF-SELECTION.


  help_standard=>p01_reduce( ).
  help_standard=>p02_filter( ).
  help_standard=>p03_loop_case( ).
  help_standard=>p04_loop_where( ).
  help_standard=>p05_loop_case_fs( ).
  help_standard=>p06_loop_where_fs( ).
  help_standard=>p07_loop_where_no( ).

  help_sorted=>p01_reduce( ).
  help_sorted=>p02_filter( ).
  help_sorted=>p03_loop_case( ).
  help_sorted=>p04_loop_where( ).
  help_sorted=>p05_loop_case_fs( ).
  help_sorted=>p06_loop_where_fs( ).
  help_sorted=>p07_loop_where_no( ).
