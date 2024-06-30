---
theme: [dashboard,glacier]
title: Testes com mapa
toc: false
---
<style> body, div, p, li, ol, h1 { max-width: none; } </style>

## Testes com o mapa
<script src='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.js'></script>
<link href='https://unpkg.com/maplibre-gl@latest/dist/maplibre-gl.css' rel='stylesheet' /> 
<div id='map' style='width: 400px; height: 300px;'></div>

```js

let dataset = await FileAttachment("data/crimes_2011.geojson").json({typed: true});
console.log(dataset);
var map = new maplibregl.Map({
    container: 'map',
    style: 'https://tiles.stadiamaps.com/styles/alidade_smooth.json',
    center: [-46.63078308105469,-23.629427267052435], // starting position [lng, lat]
    zoom: 8 // starting zoom
});

map.on('load', () => {
        map.addSource('crimes_2011', {
            'type': 'geojson',
            'data': dataset
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