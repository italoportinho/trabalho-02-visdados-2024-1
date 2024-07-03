---
theme: [dashboard,glacier]
title: Testes com mapa
toc: false
---
<style> body, div, p, li, ol, h1 { max-width: none; } 
    #container{
        display: flex;
        flex-direction: row;
    }
    #map {
        width: 100%;
        height: 600px;
    }
    #vis {
        width: 100%;
        height: 600px;
    }
</style>

## Testes com o mapa
<script src='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.js'></script>
<link href='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.css' rel='stylesheet' /> 



<script src="https://cdn.jsdelivr.net/npm/vega@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-lite@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-embed@6"></script>


```js

const year = view(Inputs.range([2011, 2018], {value: 2011, step: 1, label: "Ano"}));
const crimeTypeOptions = ["armed_robbery_auto", "bodily_harm", "crime_total", "felony_murder","feminicide","homicide","robbery_cellphone","theft_auto","theft_cellphone"];
const crimeType = view(Inputs.radio(crimeTypeOptions, {value: "crime_total", label: "Tipo de crime: "}));
```


```js
let layer_crimes;
switch (year) {
  case 2011:
    layer_crimes = await FileAttachment("data/crimes_2011.geojson").json();
    break;
  case 2012:
    layer_crimes = await FileAttachment("data/crimes_2012.geojson").json();
    break;
  case 2013:
    layer_crimes = await FileAttachment("data/crimes_2013.geojson").json();
    break;
  case 2014:
    layer_crimes = await FileAttachment("data/crimes_2014.geojson").json();
    break;
  case 2015:
    layer_crimes = await FileAttachment("data/crimes_2015.geojson").json();
    break;
  case 2016:
    layer_crimes = await FileAttachment("data/crimes_2016.geojson").json();
    break;
  case 2017:
    layer_crimes = await FileAttachment("data/crimes_2017.geojson").json();
    break;
  case 2018:
    layer_crimes = await FileAttachment("data/crimes_2018.geojson").json();
    break;
  default:
    throw new Error("Ano não suportado");
}


const regex = /"(-|)([0-9]+(?:\.[0-9]+)?)"/g 
layer_crimes = JSON.stringify(layer_crimes).replace(regex, '$1$2');
layer_crimes = JSON.parse(layer_crimes);
let layer_limite_distritos = await FileAttachment("data/limite_dos_distritos.geojson").json({typed:true});
layer_crimes.features.forEach(feature => {
    const properties = feature.properties;
    properties.crime_total = properties.feminicide + properties.homicide + properties.felony_murder + properties.bodily_harm + properties.theft_cellphone + properties.robbery_cellphone + properties.theft_auto + properties.armed_robbery_auto + properties.criminal_index;
});





```

```js
function transformData(name_values) {
  return [
    { "name" : name_values.name},
    { "crime": "feminicide", "value": name_values.feminicide },
    { "crime": "homicide", "value": name_values.homicide },
    { "crime": "felony_murder", "value": name_values.felony_murder },
    { "crime": "bodily_harm", "value": name_values.bodily_harm },
    { "crime": "theft_cellphone", "value": name_values.theft_cellphone },
    { "crime": "robbery_cellphone", "value": name_values.robbery_cellphone },
    { "crime": "theft_auto", "value": name_values.theft_auto },
    { "crime": "armed_robbery_auto", "value": name_values.armed_robbery_auto },
    { "crime": "criminal_index", "value": name_values.criminal_index },
    { "crime": "crime_total", "value": name_values.crime_total }
  ];
}

function createGraphBar(data, title) {
  return {
    "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
    "description": "A bar chart showing various crime types and their values.",
    "width": 700,
    "height": 300,
    "title": title,
    "data": { "values": data },
    "mark": "bar",
    "encoding": {
      "x": { "field": "crime", "type": "nominal", "axis": { "labelAngle": 0 }},
      "y": { "field": "value", "type": "quantitative" },
      "tooltip": [
        { "field": "crime", "type": "nominal", "title": "Crime Type" },
        { "field": "value", "type": "quantitative", "title": "Value" }
      ]
    }
  };
}

function updateGraph(data) {
    data = transformData(data)
    vegaEmbed('#vis', createGraphBar(data,data[0].name));
}


```


```js
var map = new maplibregl.Map({
    container: 'map',
    style: 'https://tiles.stadiamaps.com/styles/alidade_smooth.json',
    center: [-46.621856689453125,-23.704265788783246], // starting position [lng, lat]
    zoom: 9 // starting zoom
});

let popup;

let name_values = {
  "id": 58,
  "name": "PEDREIRA",
  "year": 2011,
  "feminicide": 0,
  "homicide": 150,
  "felony_murder": 0,
  "bodily_harm": 0,
  "theft_cellphone": 1055,
  "robbery_cellphone": 4975,
  "theft_auto": 1085,
  "armed_robbery_auto": 5125,
  "criminal_index": 12390,
  "crime_total": 24780
};

map.on('load', () => {
    map.addSource('source_crimes', {
        'type': 'geojson',
        'data': layer_crimes
    });
    map.addLayer({
        'id': 'layer_crimes',
        'type': 'fill',
        'source': 'source_crimes',
        'layout': {},
        'paint': {
            'fill-color': [
                'interpolate',
                ['linear'],
                ['get', crimeType],
                0,
                '#F2F12D',
                1000,
                '#EED322',
                2000,
                '#E6B71E',
                3000,
                '#DA9C20',
                4000,
                '#CA8323',
                5000,
                '#B86B25',
                6000,
                '#A25626',
                8000,
                '#8B4225',
                10000,
                '#723122'
            ],
            'fill-opacity': 1
        }
    });
    
    map.addSource('limites_dos_distritos', {
        'type': 'geojson',
        'data': layer_limite_distritos
    });
    
    map.addLayer({
        'id': 'limites_dos_distritos',
        'type': 'line',
        'source': 'limites_dos_distritos',
        'layout': {},
        'paint': {
            'line-color': '#000000'
        }
    });

    // map.on('mouseenter', 'layer_crimes', function (e) {
    //     map.getCanvas().style.cursor = 'pointer';

    //     if (popup) popup.remove();

    //     const coordinates = e.lngLat;
    //     const name = e.features[0].properties.name;

    //     popup = new maplibregl.Popup()
    //         .setLngLat(coordinates)
    //         .setText(name)
    //         .addTo(map);
    // });

    map.on('mouseleave', 'layer_crimes', function () {
        map.getCanvas().style.cursor = '';
        if (popup) popup.remove();
        popup = null;
    });

    map.on('mousemove', 'layer_crimes', function (e) {
        map.getCanvas().style.cursor = 'pointer';
        if (popup) popup.remove();

        const coordinates = e.lngLat;
        const name = e.features[0].properties.name;
        const value = e.features[0].properties[crimeType]; // substitua pelo campo de interesse

        const content = `<strong>${name}</strong><br>Valor: ${value}`;

        popup = new maplibregl.Popup()
            .setLngLat(coordinates)
            .setHTML(content)
            .addTo(map);
    });

    map.on('click', 'layer_crimes', function (e) {
    const name = e.features[0].properties.name;

    // Filtrar o layer_crimes para encontrar a característica correspondente
    const filtered_features = layer_crimes.features.filter(element => element.properties.name === name);

    if (filtered_features.length > 0) {
        name_values = filtered_features[0].properties;
    } else {
        name_values = {}; // Se não encontrar, reseta o valor
    }


    console.log(transformData(name_values));
    updateGraph(name_values);
    });
});

```

<div id="container">
    <div id='map'></div>
    <div id='vis'></div>
</div

