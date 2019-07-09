# Descrição de dados #

[![N|Solid](https://wiki.scn.sap.com/wiki/download/attachments/1710/ABAP%20Development.png?version=1&modificationDate=1446673897000&api=v2)](https://www.sap.com/brazil/developer.html)

Será criado um exemplo simples de retorno para descrição de tipo de dados de uma variavel. Em algumas soluções esse `méthod` foi usado para montar um `fieldcat` caso a solução de `alv` usada precisasse de um `merge` para mostra de dados. Existe um exemplo bem claro no site do [ABAP Juniores](http://abapjuniores.blogspot.com.br/2012/07/classe-clabaptypedescr.html) ~~que de junior tem quase que apenas o nome~~ que pode ser usado de referencia conforma a solução.

A Classe utilizada será a `CL_ABAP_TYPEDESCR` _Runtime Type Services_. Dentro desta, o método estático será `DESCRIBE_BY_DATA` _Description of data object type_.

Abaixo segue um exemplo da utilização.
```abap
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
```

Esse exemplo que coloquei foi usado para uma parte da montagem de `alv`, mas aproveitei parte de um código que estava pronto. A melhor utilização que fiz foi para criação de tabelas dinâmicas.
