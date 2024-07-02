-- Para copiar o arquivo do container docker para a máquina local: 
-- sudo docker cp hive-server:/Home/districts_crimes_2011_geom.csv /home/italo/Projects/MESTRADO/trabalho-02-visdados-2024-1/datasets
-- sudo docker cp NOME_CONTAINER:SOURCE_PATH DESTINATION_PATH


-- Step 1: Create csv table with dummy deafer column as first rom:
CREATE TABLE districts_crimes_2011_geom
    row format delimited
    fields terminated by ';'
    lines terminated by '\n'
    STORED as textfile
AS 
    select 
        'id' as id,
        'name' as name,
        'year' as year,
        'feminicide' as feminicide,
        'homicide' as homicide,
        'felony_murder' as felony_murder,
        'bodily_harm' as bodily_harm,
        'theft_cellphone' as theft_cellphone,
        'robbery_cellphone' as robbery_cellphone,
        'theft_auto' as theft_auto,
        'armed_robbery_auto' as armed_robbery_auto,
        'criminal_index' as criminal_index,
        'geometry' as geometry      
;

-- hdfs://namenode:8020/user/hive/warehouse/trabalho_bdd_nofrag.db/districts_crimes_2011_geom

-- Step 2: Insert data into actual table:
INSERT INTO districts_crimes_2011_geom
select 
    distrito.*
    , geometria.geometry
from 
    (select
    district_frag_geom.id as id,
    district_frag_geom.name as name,
    time_frag.year as year,
    sum(crime.total_feminicide) as feminicide,
    sum(crime.total_homicide) as homicide, 
    sum(crime.total_felony_murder) as felony_murder,
    sum(crime.total_bodily_harm) as bodily_harm,
    sum(crime.total_theft_cellphone) as theft_cellphone,
    sum(crime.total_armed_robbery_cellphone) as robbery_cellphone,
    sum(crime.total_theft_auto) as theft_auto,
    sum(crime.total_armed_robbery_auto) as armed_robbery_auto,
    sum(crime.total_feminicide) +
        sum(crime.total_homicide) +
        sum(crime.total_felony_murder) +
        sum(crime.total_bodily_harm) +
        sum(crime.total_theft_cellphone) +
        sum(crime.total_armed_robbery_cellphone) +
        sum(crime.total_theft_auto) +
        sum(crime.total_armed_robbery_auto) as criminal_index
from
    vertice, district_frag_geom, segment, crime, time_frag

where time_frag.id = crime.time_id
    and crime.segment_id = segment.id
    and (segment.start_vertice_id = vertice.id OR segment.start_vertice_id = vertice.id)
    and vertice.district_id = district_frag_geom.id  
    and time_frag.year = 2011  
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

-- Step 3: Export table rows to csv file (escolher nome diferente da tabela pra não dar erro):
-- hadoop fs -cat hdfs://namenode:8020/user/hive/warehouse/trabalho_bdd_nofrag.db/districts_crimes_2011_geom/* > districts_crimes_2011_geom.csv
