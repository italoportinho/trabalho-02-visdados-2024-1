INSERT OVERWRITE LOCAL DIRECTORY '/Home/district_iguatemi_geom.csv'
row format delimited
    fields terminated by ';'
    lines terminated by '\n'

select
    *
from
    district_frag_geom

where 
    name = 'IGUATEMI'
    ;