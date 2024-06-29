use trabalho_bdd_nofrag;

CREATE TABLE IF NOT EXISTS districts_crimes_allyears_nogeom
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
        'criminal_index' as criminal_index
;

CREATE TABLE IF NOT EXISTS districts_crimes_2011_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2012_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2013_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2014_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2015_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2016_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2017_geom
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
CREATE TABLE IF NOT EXISTS districts_crimes_2018_geom
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

INSERT INTO districts_crimes_allyears_nogeom
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
;

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


INSERT INTO districts_crimes_2012_geom
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
    and time_frag.year = 2012  
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

INSERT INTO districts_crimes_2013_geom
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
    and time_frag.year = 2013 
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

INSERT INTO districts_crimes_2014_geom
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
    and time_frag.year = 2014
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

INSERT INTO districts_crimes_2015_geom
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
    and time_frag.year = 2015
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

INSERT INTO districts_crimes_2016_geom
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
    and time_frag.year = 2016  
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

INSERT INTO districts_crimes_2017_geom
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
    and time_frag.year = 2017
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;

INSERT INTO districts_crimes_2018_geom
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
    and time_frag.year = 2018  
    group by district_frag_geom.id, district_frag_geom.name, time_frag.year) 
    as distrito, 
    (select
        district_frag_geom.id,
        district_frag_geom.geometry
        from district_frag_geom) 
    as geometria
where distrito.id = geometria.id
;