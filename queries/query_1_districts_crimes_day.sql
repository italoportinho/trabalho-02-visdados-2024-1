INSERT OVERWRITE LOCAL DIRECTORY '/Home/districts_crimes_day.csv'
row format delimited
    fields terminated by ';'
    lines terminated by '\n'

select
    district_frag_geom.name as name,
    time_frag.year as year,
    time_frag.month as month,
    time_frag.weekday as weekday,
    time_frag.day as day,
    sum(crime.total_feminicide) as feminicide,
    sum(crime.total_homicide) as homicide, 
    sum(crime.total_felony_murder) as felony_murder,
    sum(crime.total_bodily_harm) as bodily_harm,
    sum(crime.total_theft_cellphone) as theft_cellphone,
    sum(crime.total_armed_robbery_cellphone) as robbery_cellphone,
    sum(crime.total_theft_auto) as theft_auto,
    sum(crime.total_armed_robbery_auto) as armed_robbery_auto
from
    vertice, district_frag_geom, segment, crime, time_frag

where time_frag.year IN (2013, 2014, 2015, 2016, 2017, 2018) 
    and time_frag.id = crime.time_id
    and crime.segment_id = segment.id
    and (segment.start_vertice_id = vertice.id OR segment.start_vertice_id = vertice.id)
    and vertice.district_id = district_frag_geom.id    
    group by district_frag_geom.name, time_frag.year, time_frag.month, time_frag.weekday, time_frag.day
    ORDER BY district_frag_geom.name
    ;