---
theme: [dashboard,glacier]
title: Testes com mapa
toc: false
---
<style> body, div, p, li, ol, h1 { max-width: none; } </style>

## Testes com o mapa
<script src='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.js'></script>
<link href='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.css' rel='stylesheet' /> 
<div id='map' style='width: 800px; height: 600px;'></div>

```js

let layer_crimes_2011 = await FileAttachment("data/crimes_2011.geojson").json({typed: true});
const regex = /"(-|)([0-9]+(?:\.[0-9]+)?)"/g 
layer_crimes_2011 = JSON.stringify(layer_crimes_2011).replace(regex, '$1$2');
layer_crimes_2011 = JSON.parse(layer_crimes_2011);
let layer_limite_distritos = await FileAttachment("data/limite_dos_distritos.geojson").json({typed:true});
console.log(layer_crimes_2011);
var map = new maplibregl.Map({
    container: 'map',
    style: 'https://tiles.stadiamaps.com/styles/alidade_smooth.json',
    /*
    style: {
        sources: {},
        layers: [],
        version: 8
    },*/ 
    center: [-46.621856689453125,-23.704265788783246], // starting position [lng, lat]
    zoom: 9 // starting zoom
});
//console.log(map);
map.on('load', () => {
    
    map.addSource('source_crimes_2011', {
        'type': 'geojson',
        'data': layer_crimes_2011
    });
    map.addLayer({
        'id': 'layer_crimes_2011',
        'type': 'fill',
        'source': 'source_crimes_2011',
        'layout': {},
        /*'paint': {
                'fill-color': '#088',
                'fill-opacity': 1
            } */
        'paint': {
                    'fill-color': [
                        'interpolate',
                        ['linear'],
                        ['get', 'theft_cellphone'],
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
});

```