---
theme: [dashboard,glacier]
title: Introdução
toc: false
---
<style> body, div, p, li, ol, h1, ul { max-width: none; } li span {font-weight: bold;} </style>

## Introdução
<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px; margin-bottom:50px">
    <p style="text-align: justify;">   
    Este trabalho consiste em uma análise detalhada de subconjutos de um dataset composto pelo registro de determinados crimes na cidade de São Paulo. O dataset em questão é o PolRoute-DS, e pode ser obtido no endereço <a href="https://osf.io/mxrgu/">https://osf.io/mxrgu/</a>. Originalmente ele é composto dos seguintes arquivos no formato csv:
    </p>
    <ul>
        <li><span>time.csv</span></li>
        <li><span>crime.csv</span></li>
        <li><span>segment.csv</span></li>
        <li><span>vertice.csv</span></li>
        <li><span>district.csv</span></li>
        <li><span>neighborhood.csv</span></li>
    </ul>
    <p style="text-align: justify;">   
    O dataset foi importado para um datawarehouse(Apache Hive) , de forma que pudessemos rodar consultas eficientemente em um ambiente distribuído para extrair um conjuto de informações relevantes para o propósito deste trabalho. O objetivo é extrair sub-datasets com os crimes por ano e distrito, com e sem sua geometria, e também rodar uma consulta para descobrir o ano com mais crimes e deste ano extrair um dataset com os crimes por dia e mês para poder fazer uma HeatMatrix. O dataset com os distrito sem geometria será usado para todas as visualizações que não envolvam mapas. Os crimes considerados no dataset e suas respectivas traduções são:
    <ul>
        <li><span>feminicide -> Feminicídio</span></li>
        <li><span>homicide -> Homicídio</span></li>
        <li><span>felony_murder -> Homicídio Qualificado</span></li>
        <li><span>bodily_harm -> Lesão Corporal</span></li>
        <li><span>theft_cellphone -> Furto de Celular</span></li>
        <li><span>robbery_cellphone -> Roubo de Celular</span></li>
        <li><span>theft_auto -> Furto de Carro</span></li>
        <li><span>armed_robbery_auto -> Roubo Armado de Carro</span></li>
    </ul>
    </p>
    <p style="text-align: justify;">   
    No dataset orignal a geometria dos distritos está no formato EWKB(Extended Weel Know Binary) e para podermos visualiza-la na biblioteca MapLibre foi preciso utilizar o software Quantum GIS para converter a geometria para o formato Lat/Long na projeção EPSG:4326, e exportar o dataset para o formato GeoJSON. O dataset com a geometria dos distritos foi separado por ano devido ao seu tamanho, e somente foram considerados para este trabalho os ano de 2011 a 2018, por apresentarem mais registros. Também foi extraído do site da Infraestrutura de Dados Espaciais de São Paulo, uma <a href="https://ide.emplasa.sp.gov.br/geoserver/ows?service=WFS&version=1.1.1&request=GetFeature&typeNames=emplasa:LIMITES_EMPLASA_DISTRITO_UIT_MSP&styles=&srsName=EPSG:4326&outputFormat=application/json&transparent=true">camada</a> com a divisão dos distritos transparente, e com uma linha grossa, para fins de melhor visualização. Com todas essas etapas concluídas, os sub-datasets extraídos e que serão considerados para este trabalho são:
    <ul>
        <li><span>crimes_all_years_nogeom.csv</span>: crimes por ano e por distrito, sem geomtria.</li>
        <li><span>crimes_dia_2017_no_nulls.csv</span>: crimes de 2017, por mês e dia, sem geometria. Registros com valores nulos de mês ou dia não foram considerados.</li>
        <li><span>crimes_2011.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2012.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2013.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2014.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2015.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2016.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2017.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>crimes_2018.geojson</span>: crimes por ano, com o distrito e sua geometria.</li>
        <li><span>limite_dos_distritos.geojson</span>: geometria dos limites dos distritos do município de São Paulo.</li>
    </ul>
    </p>
</div>