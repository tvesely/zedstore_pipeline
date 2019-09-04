\timing
\set ON_ERROR_STOP true

create extension if not exists vops;

drop table if exists lineitem;
create table lineitem(
   l_orderkey integer,
   l_partkey integer,
   l_suppkey integer,
   l_linenumber integer,
   l_quantity real,
   l_extendedprice real,
   l_discount real,
   l_tax real,
   l_returnflag "char",
   l_linestatus "char",
   l_shipdate date,
   l_commitdate date,
   l_receiptdate date,
   l_shipinstruct char(25),
   l_shipmode char(10),
   l_comment char(44),
   l_dummy char(1));

copy lineitem from '/tmp/lineitem.tbl' delimiter '|' csv;

drop table if exists lineitem_projection;
create table lineitem_projection (
   l_shipdate date not null,
   l_quantity float4 not null,
   l_extendedprice float4 not null,
   l_discount float4 not null,
   l_tax      float4 not null,
   l_returnflag "char" not null,
   l_linestatus "char" not null 
);

drop table if exists vops_lineitem_projection;
create table vops_lineitem_projection(
   l_shipdate vops_date not null,
   l_quantity vops_float4 not null,
   l_extendedprice vops_float4 not null,
   l_discount vops_float4 not null,
   l_tax vops_float4 not null,
   l_returnflag "char" not null,
   l_linestatus "char" not null
);

drop table if exists zedstore_lineitem_projection_copy;
create table zedstore_lineitem_projection_copy(
   l_shipdate date not null,
   l_quantity float4 not null,
   l_extendedprice float4 not null,
   l_discount float4 not null,
   l_tax      float4 not null,
   l_returnflag "char" not null,
   l_linestatus "char" not null
) using zedstore;

drop table if exists zedstore_lineitem_projection_insert;
create table zedstore_lineitem_projection_insert(
   l_shipdate date not null,
   l_quantity float4 not null,
   l_extendedprice float4 not null,
   l_discount float4 not null,
   l_tax      float4 not null,
   l_returnflag "char" not null,
   l_linestatus "char" not null
) using zedstore;


insert into lineitem_projection (select l_shipdate,l_quantity,l_extendedprice,l_discount,l_tax,l_returnflag::"char",l_linestatus::"char" from lineitem);

select populate(destination := 'vops_lineitem_projection'::regclass, source := 'lineitem_projection'::regclass, sort := 'l_returnflag,l_linestatus');

copy lineitem_projection to '/tmp/lineitem_projection.csv';
copy zedstore_lineitem_projection_copy from '/tmp/lineitem_projection.csv';

insert into zedstore_lineitem_projection_insert (select l_shipdate,l_quantity,l_extendedprice,l_discount,l_tax,l_returnflag::"char",l_linestatus::"char" from lineitem);
