---
theme: [dashboard,glacier]
title: Testes com mapa
toc: false
---
<style> body, div, p, li, ol, h1 { max-width: none; } 
    #container{
        display: flex;
        flex-direction: row;
        gap: 20px; 
        margin-bottom:-200px;
    }
    #map {
        width: 60%;
        height: 600px;
        /* border-radius: 15px; 
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); */
    }
    #vis {
        width: 40%;
        height: 600px;
        /* border-radius: 15px; 
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); */
    }
    #legend {
      position: relative;
      width:10%;
      bottom: 200px;
      left: 10px;
      background: white;
      padding: 10px;
      border-radius: 4px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
      font-size:12px;
      font-family: Arial, sans-serif;
    }
    .legend-item {
      display: flex;
      align-items: center;
      margin-bottom: 5px;
    }
    .legend-color {
      width: 20px;
      height: 20px;
      margin-right: 10px;
      border-radius: 4px;
    }
</style>

<script src='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.js'></script>
<link href='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.css' rel='stylesheet' /> 



<script src="https://cdn.jsdelivr.net/npm/vega@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-lite@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-embed@6"></script>

<h1> Como é a distribuição de crimes por tipo, região e ano na .... de São Paulo?</h1>
<hr>

```js

const year = view(Inputs.range([2011, 2018], {value: 2011, step: 1, label: "Ano"}));
const crimeTypeOptions = ["Roubo Armado de Carro", "Danos Corporais", "Total de Crimes", "Homicídio Qualificado","Feminicídio","Homicídio","Roubo de Celular","Furto de Carro","Furto de Celular"];
const crimeType = view(Inputs.radio(crimeTypeOptions, {value: "Total de Crimes", label: "Tipo de crime: "}));

const MapCrimeType = {
    "Feminicídio": "feminicide",
    "Homicídio": "homicide",
    "Homicídio Qualificado": "felony_murder",
    "Danos Corporais": "bodily_harm",
    "Furto de Celular": "theft_cellphone",
    "Roubo de Celular": "robbery_cellphone",
    "Furto de Carro": "theft_auto",
    "Roubo Armado de Carro": "armed_robbery_auto",
    "Total de Crimes": "criminal_index"
};
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
// layer_crimes.features.forEach(feature => {
//     const properties = feature.properties;
//     properties.crime_total = properties.feminicide + properties.homicide + properties.felony_murder + properties.bodily_harm + properties.theft_cellphone + properties.robbery_cellphone + properties.theft_auto + properties.armed_robbery_auto + properties.criminal_index;
// });





```

```js
function transformData(name_values) {
  return [
    { "name" : name_values.name},
    { "crime": "Feminicídio", "value": name_values.feminicide },
    { "crime": "Homicídio", "value": name_values.homicide },
    { "crime": "Homicídio Qualificado", "value": name_values.felony_murder },
    { "crime": "Danos Corporais", "value": name_values.bodily_harm },
    { "crime": "Furto de Celular", "value": name_values.theft_cellphone },
    { "crime": "Roubo de Celular", "value": name_values.robbery_cellphone },
    { "crime": "Furto de Carro", "value": name_values.theft_auto },
    { "crime": "Roubo armado de Carro", "value": name_values.armed_robbery_auto },
    { "crime": "Total de Crimes", "value": name_values.criminal_index },
    // { "crime": "crime_total", "value": name_values.crime_total }
  ];
}


function createGraphBar(data, title) {
  return {
    "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
    "description": "A bar chart showing various crime types and their values.",
    "width": "container",
    "height": 600 - 64 - 83,
    "title": title,
    "data": { "values": data },
    "mark": {
      "type": "bar",
      "tooltip": true
    },
    "encoding": {
      "x": { "field": "crime", "type": "nominal", "axis": { "labelAngle": 270 } },
      "y": { "field": "value", "type": "quantitative" }
    },
    "layer": [
      {
        "mark": "bar",
        "encoding": {
          "tooltip": [
            { "field": "crime", "type": "nominal", "title": "Crime Type" },
            { "field": "value", "type": "quantitative", "title": "Value", "format": ",.0f" }
          ]
        }
      },
      {
        "mark": {
          "type": "text",
          "align": "center",
          "baseline": "bottom",
          "dy": -5 // Ajuste vertical para a posição do texto
        },
        "encoding": {
          "text": { 
            "field": "value", 
            "type": "quantitative", 
            "format": ",.0f" 
          }
        }
      }
    ],
    "config": {
      "bar": { "width": 30 }, // Ajusta a largura das barras
      "text": { "fontSize": 12 } // Ajusta o tamanho do texto
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

updateGraph(name_values);

const crimeValues = layer_crimes.features.map(element => element.properties[MapCrimeType[crimeType]]);
const maxCrimeValue = Math.max(...crimeValues);

// Define a escala dinâmica baseada no valor máximo
const scaleSteps = 9;
const colorStops = [];
const colors = ['#F2F12D', '#FED976', '#FEB24C', '#FD8D3C', '#FC4E2A', '#E31A1C', '#BD0026', '#800026', '#4A0000'];


for (let i = 0; i <= scaleSteps; i++) {
    colorStops.push(i * (maxCrimeValue / scaleSteps));
}

// Monta a legenda
if(document.getElementById('legend')){
  document.getElementById('legend').innerHTML = '';
}

const legend = document.getElementById('legend');
for (let i = 0; i < colorStops.length - 1; i++) {
    const legendItem = document.createElement('div');
    legendItem.className = 'legend-item';
    
    const legendColor = document.createElement('div');
    legendColor.className = 'legend-color';
    legendColor.style.backgroundColor = colors[i];
    
    const legendText = document.createElement('span');
    let startValue;
    if (colorStops[i] === 0) {
        startValue = colorStops[i].toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    } else {
        startValue = (1 + colorStops[i]).toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    }
    const endValue = colorStops[i + 1].toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    legendText.textContent = `${startValue} - ${endValue}`;
    
    legendItem.appendChild(legendColor);
    legendItem.appendChild(legendText);
    legend.appendChild(legendItem);
}


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
                ['get', MapCrimeType[crimeType]],
                0, colors[0],
                colorStops[1], colors[1],
                colorStops[2], colors[2],
                colorStops[3], colors[3],
                colorStops[4], colors[4],
                colorStops[5], colors[5],
                colorStops[6], colors[6],
                colorStops[7], colors[7],
                colorStops[8], colors[8]
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
    const value = e.features[0].properties[MapCrimeType[crimeType]]; // substitua pelo campo de interesse

    // Formate o valor com separadores de milhar
    const formattedValue = value.toFixed(0).replace(/\B(?=(\d{3})+(?!\d))/g, ".");

    const content = `<strong>${name}</strong><br>Valor: ${formattedValue}`;

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

    updateGraph(name_values);
    });
});

```

<div id="container">
    <div id='map'></div>
    <div id='vis'></div>
</div>
<div id="legend"></div>

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      Para responder à pergunta, criamos um mapa detalhado que exibe a quantidade de crimes por tipo nas diversas regiões. Este mapa é complementado por um filtro interativo, permitindo ao usuário selecionar e visualizar dados específicos para diferentes tipos de crime, e para os anos de 2011 a 2018. A intensidade da cor no mapa varia conforme a quantidade de crimes na região, tornando mais fácil identificar áreas com maior incidência criminal.
      Além disso, desenvolvemos um gráfico de barras interativo à direita do mapa. Quando o usuário clica em uma região específica no mapa, o gráfico de barras atualiza-se automaticamente para mostrar a quantidade detalhada de cada tipo de crime naquela região. Esta abordagem integrada facilita uma análise detalhada e intuitiva dos dados criminais, permitindo uma melhor compreensão das tendências e padrões.
    </p>
</div>
<br>
<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      Ao considerar o filtro "Total de Crimes", que representa a soma de todos os tipos de crime, observamos que o bairro de Jaguara apresentou os maiores valores nos anos de 2011 a 2013. Em 2014, os bairros de Santo Amaro, Cidade Ademar, Jabaquara, Cidade Dutra e República destacaram-se com os maiores índices. Em 2015, houve um aumento significativo no número de crimes no bairro da República, uma tendência que se manteve nos anos de 2016, 2017 e 2018, se comparado aos demais. Diante dessa informação, seria interessante investigar os possíveis fatores que contribuíram para o aumento expressivo da criminalidade nesse bairro.
    </p>
</div>
<br>
<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      Em relação aos tipos de crimes, observamos que, ao longo de todos os anos analisados, os mais comuns foram roubo armado de carros, roubo de celulares, furto de carros e furto de celulares. Em contrapartida, os crimes de danos corporais, homicídio qualificado, feminicídio e homicídio apresentaram uma incidência proporcionalmente menor quando comparados aos demais.
    </p>
</div>


