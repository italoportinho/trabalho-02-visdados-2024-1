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
console.log(layer_crimes_2011);
var map = new maplibregl.Map({
    container: 'map',
    style: 'https://tiles.stadiamaps.com/styles/alidade_smooth.json',
    /*style: {
        sources: {},
        layers: [],
        version: 8
    },*/ 
    center: [-46.621856689453125,-23.704265788783246], // starting position [lng, lat]
    zoom: 9 // starting zoom
});

map.on('load', () => {
        map.addSource('crimes_2011', {
            'type': 'geojson',
            'data': layer_crimes_2011
        });
        map.addLayer({
            'id': 'crimes_2011',
            'type': 'fill',
            'source': 'crimes_2011',
            'layout': {},
            'paint': {
                'fill-color': '#088',
                'fill-opacity': 0.8
            }
        });
    });

```