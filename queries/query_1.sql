----------------------------------------------------------------------------------------------------------------
-- Perguntas possíveis: 
-- Qual o ano mais violento? 
-- Qual o distrito mais violento? 
-- Como foi a evolução da criminalidade ao longo dos anos?
-- Dado um crime, qual o distrito em que ele acontece mais:
-- Dado um distrito, qual o crime mais prevalente?
-- QUERY 1:
-- Extrair o total de todos os crime por por distrito, por ano, com a geometria do distrito.
-- 
-- 
----------------------------------------------------------------------------------------------------------------
INSERT OVERWRITE LOCAL DIRECTORY '/Home/dumps.csv'
row format delimited
    fields terminated by ';'
    lines terminated by '\n'
select
    district_frag_geom.name as name,
    time_frag.year as year,
    --district_frag_geom.geometry as geometry,
    sum(crime_frag_2016.total_feminicide) as feminicide,
    sum(crime_frag_2016.total_homicide) as homicide, 
    sum(crime_frag_2016.total_felony_murder) as felony_murder,
    sum(crime_frag_2016.total_bodily_harm) as bodily_harm,
    sum(crime_frag_2016.total_theft_cellphone) as theft_cellphone,
    sum(crime_frag_2016.total_armed_robbery_cellphone) as robbery_cellphone,
    sum(crime_frag_2016.total_theft_auto) as theft_auto,
    sum(crime_frag_2016.total_armed_robbery_auto) as armed_robbery_auto
from
    vertice, district_frag_geom, segment, crime_frag_2016, time_frag

where 
    time_frag.year = 2016
    and time_frag.id = crime_frag_2016.time_id
    and crime_frag_2016.segment_id = segment.id
    and (segment.start_vertice_id = vertice.id OR segment.start_vertice_id = vertice.id)
    and vertice.district_id = district_frag_geom.id
    --and district_frag_geom.name = 'IGUATEMI'
    group by district_frag_geom.name, time_frag.year
    --, district_frag_geom.geometry
    ;

SET hive.exec.dynamic.partition.mode=nonstrict;
SET hive.strict.checks.cartesian.product=false;

CREATE TABLE IF NOT EXISTS district_frag_geom(
    id int,
    geometry string
)
    partitioned by (name string)
    row format delimited
    fields terminated by ';'
    lines terminated by '\n'
    stored as textfile location 'hdfs://namenode:8020/user/hive/warehouse/trabalho_bdd_nofrag.db/district_frag_geom'
;

INSERT OVERWRITE TABLE district_frag_geom
partition(name)
SELECT 
    id, 
    geometry,
    name
    FROM district;