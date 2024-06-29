select
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
    and time_frag.year IN (2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018)  
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year
    order by district_frag_geom.name ASC, time_frag.year DESC 