use trabalho_bdd_nofrag;

CREATE TABLE IF NOT EXISTS crimes_dia_ano_mais_violento
    row format delimited
    fields terminated by ';'
    lines terminated by '\n'
    STORED as textfile
AS 
    select 
        'month' as month,
        'day' as day,
        'feminicide' as feminicide,
        'homicide' as homicide,
        'felony_murder' as felony_murder,
        'bodily_harm' as bodily_harm,
        'theft_cellphone' as theft_cellphone,
        'robbery_cellphone' as robbery_cellphone,
        'theft_auto' as theft_auto,
        'armed_robbery_auto' as armed_robbery_auto,
        'criminal_index' as criminal_index
;

INSERT INTO crimes_dia_ano_mais_violento
select
    time_frag.month as month,    
    time_frag.day as day,
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
    crime, time_frag

where time_frag.year = 2017
    and time_frag.id = crime.time_id    
    and time_frag.day IS NOT NULL
    and time_frag.month IS NOT NULL
    group by time_frag.month, time_frag.day
    ORDER BY time_frag.month, time_frag.day
    ;

-- hadoop fs -cat hdfs://namenode:8020/user/hive/warehouse/trabalho_bdd_nofrag.db/crimes_dia_ano_mais_violento/* > crimes_dia_2017.csv

-- ANO MAIS VIOLENTO
--select
--    time_frag.year as year,  
--    sum(crime.total_feminicide) +
--        sum(crime.total_homicide) +
--        sum(crime.total_felony_murder) +
--        sum(crime.total_bodily_harm) +
--        sum(crime.total_theft_cellphone) +
--        sum(crime.total_armed_robbery_cellphone) +
--        sum(crime.total_theft_auto) +
--        sum(crime.total_armed_robbery_auto) as criminal_index
--from
--    vertice, district_frag_geom, segment, crime, time_frag
--
--where time_frag.year IN (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018) 
--    and time_frag.id = crime.time_id
--    and crime.segment_id = segment.id
--    and (segment.start_vertice_id = vertice.id OR segment.start_vertice_id = vertice.id)
--    and vertice.district_id = district_frag_geom.id    
--    group by time_frag.year
--    ORDER BY criminal_index DESC
--    ;
