---
theme: [glacier]
title: Pergunta 33
---
<style> body, div, p, li, ol, h1, h2, h3 { max-width: none; } 

.yearSelect {
    width: calc(100% - 20px);
    background-color: white; 
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); 
    position: sticky; 
    top: 0; 
    z-index: 1000000000000000000;
    border-radius: 10px;
    margin-bottom: 50px;
    padding-left: 10px; 
    padding-right: 10px; 
}

.yearSelect > div {
    margin-top: -25px; /* Adiciona 5px de espaço acima de cada item */
    margin-bottom: -25px; /* Adiciona 5px de espaço abaixo de cada item */
}

</style>

<script src="https://cdn.jsdelivr.net/npm/vega@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-lite@5"></script>
<script src="https://cdn.jsdelivr.net/npm/vega-embed@6"></script>
<script src="https://cdn.jsdelivr.net/npm/simple-statistics@7.7.4/dist/simple-statistics.min.js"></script>

<h1> </h1>
<hr>

```js
function calculateCorrelation(x, y) {
    const n = x.length;
    const sum_x = x.reduce((a, b) => a + b, 0);
    const sum_y = y.reduce((a, b) => a + b, 0);
    const sum_x_sq = x.reduce((a, b) => a + b * b, 0);
    const sum_y_sq = y.reduce((a, b) => a + b * b, 0);
    const sum_xy = x.reduce((sum, xi, i) => sum + xi * y[i], 0);

    const numerator = n * sum_xy - sum_x * sum_y;
    const denominator = Math.sqrt((n * sum_x_sq - sum_x ** 2) * (n * sum_y_sq - sum_y ** 2));

    if (denominator === 0) return 0;
    return numerator / denominator;
}
```



<div class="yearSelect">

<div style="display: flex; justify-content: space-between; width: 100%; margin-bottom:10px;">

```js
let yearInf = view(Inputs.range([2011, 2018], {value: 2011, step: 1, label: "Ano Inferior"}));
```

```js
let yearSup = view(Inputs.range([2011, 2018], {value: 2011, step: 1, label: "Ano Superior"}));
```

</div>

```js
const box = ["feminicide", "homicide", "felony_murder", "bodily_harm", "theft_cellphone", "robbery_cellphone", "theft_auto", "armed_robbery_auto", "criminal_index"]
let selectBox_x = view(Inputs.select(["criminal_index"].concat(box), {label: "Tipo de crime X"}));
let selectBox_y = view(Inputs.select(["criminal_index"].concat(box), {label: "Tipo de crime Y"}));
```

</div>


```js
let dataset_crimes_all_years = await FileAttachment("data/crimes_all_years_nogeom.csv").dsv({delimiter: ";", typed: true});
let dataset = dataset_crimes_all_years.filter(element => element.year >= yearInf && element.year <= yearSup);
let dataset_x = dataset.map(element => element[selectBox_x]);
let dataset_y = dataset.map(element => element[selectBox_y]);
let data_scatter = dataset.map(element => ({
    x: element[selectBox_x],
    y: element[selectBox_y],
    year: element.year,
    name: element.name
}));
const boxExtended = [...box, "year", "name"];
const data_boxplot = dataset.map(element => {
    let entry = {};
    boxExtended.forEach(property => {
        entry[property] = element[property];
    });
    return entry;
});

let coor = calculateCorrelation(dataset_x, dataset_y);

```


```js
const data_table = dataset.map(element => {
    let entry = {};
    boxExtended.forEach(property => {
        entry[property] = element[property];
    });
    return entry;
});

const maxCrimes = {};

data_table.forEach(entry => {
  box.forEach(crime => {
    if(crime !== "criminal_index"){
        if (!maxCrimes[entry.name] || entry[crime] > maxCrimes[entry.name].Value) {
        maxCrimes[entry.name] = {
            "District": entry.name,
            "Crime": crime,
            "Value": entry[crime],
            "Year": entry.year 
        };
        }
    }
  });
});
const maxCrimesArray = Object.values(maxCrimes);
view(Inputs.table(maxCrimesArray, {columns: ["District", "Crime", "Value", "Year"]}));
```

```js
const maxCrimesByType = {};

data_table.forEach(entry => {
  box.forEach(crime => {

    if (!maxCrimesByType[crime] || entry[crime] > maxCrimesByType[crime].Value) {
    maxCrimesByType[crime] = {
        "Crime": crime,
        "Value": entry[crime],
        "District": entry.name
    };
        
    }
  });
});



const maxCrimesByTypeArray = Object.values(maxCrimesByType).filter(d => d.Value > 0);

console.log(maxCrimesByTypeArray)

const graph_bar = {
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "description": "Gráfico de barras mostrando o maior crime por tipo",
  "width": "container",
  "height": 500,
  "data": {
    "values": maxCrimesByTypeArray
  },
  "layer": [
    {
      "mark": "bar",
      "encoding": {
        "x": {
          "field": "Crime",
          "type": "nominal",
          "title": "Tipo de Crime",
          "axis": {
            "labelAngle": 0
          }
        },
        "y": {
          "field": "Value",
          "type": "quantitative",
          "title": "Maior Observação"
        },
        "color": {
          "field": "District",
          "type": "nominal",
          "title": "Distrito",
          "legend": {
            "title": "Distrito"
          }
        },
        "tooltip": [
          { "field": "Crime", "type": "nominal", "title": "Tipo de Crime" },
          { "field": "Value", "type": "quantitative", "title": "Maior Observação", "format": ",.0f" },
          { "field": "District", "type": "nominal", "title": "Distrito" }
        ]
      }
    },
    {
      "mark": {
        "type": "text",
        "dy": -10,
        "fontSize": 12,
        "align": "center"
      },
      "encoding": {
        "x": {
          "field": "Crime",
          "type": "nominal"
        },
        "y": {
          "field": "Value",
          "type": "quantitative"
        },
        "text": {
          "field": "Value",
          "type": "quantitative",
          "format": ",.0f"
        }
      }
    }
  ]
};

vegaEmbed('#vis0', graph_bar);
```

<div class="grid grid-cols-1"> 
    <div id="vis0" class="card"></div>
</div>


<div class="grid grid-cols-1"> 
    <div id="vis1" class="card"></div>
</div>

```js

const graph_boxplot = {
  "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
  "description": "Distribuição das propriedades de crimes por distrito",
  "width": "container",
  "height": 500,
  "data": {
    "values": data_boxplot
  },
  "transform": [
    {
      "fold": box,
      "as": ["Crime Property", "Value"]
    }
  ],
  "mark": "boxplot",
  "encoding": {
    "x": {
      "field": "Crime Property",
      "type": "nominal",
      "title": "Tipos de Crime"
    },
    "y": {
      "field": "Value",
      "type": "quantitative",
      "title": "Número de Ocorrências",
    },
    "tooltip": [
        { "field": "Crime Property", "type": "nominal", "title": "Tipo de Crime" },
        { "field": "Value", "type": "quantitative", "title": "Número de Ocorrências", "format": ",.0f" },
        { "field": "name", "type": "nominal", "title": "Distrito" },
        { "field": "year", "type": "quantitative", "title": "Ano" }
    ]
  }
};


vegaEmbed('#vis1', graph_boxplot);

```




```js
const graph_scatter = {
    "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
    "description": "",
    "width": "container",
    "height": 500,
    "data": { "values": data_scatter },
    "layer": [
        {
            "mark": "point",
            "encoding": {
                "x": {
                    "field": "x",
                    "type": "quantitative",
                    "title": selectBox_x
                },
                "y": {
                    "field": "y",
                    "type": "quantitative",
                    "title": selectBox_y
                },
                "tooltip": [
                    { "field": "name", "type": "nominal", "title": "Nome" },
                    { "field": "x", "type": "quantitative", "title": selectBox_x, "format": ",.0f" },
                    { "field": "y", "type": "quantitative", "title": selectBox_y, "format": ",.0f" },
                    { "field": "year", "type": "quantitative", "title": "Ano" }
                ]
            }
        },
        {
            "mark": {
                "type": "text",
                "align": "left",
                "baseline": "top",
                "dx": 5,
                "fontSize": 16
            },
            "encoding": {
                "x": { "value": 700 },
                "y": { "value": 0 },
                "text": { "value": `Correlação: ${coor.toFixed(2)}` }
            }
        }
    ]
};
vegaEmbed('#vis2', graph_scatter);
```



<div class="grid grid-cols-1"> 
    <div id="vis2" class="card grid-colspan-1"></div>
</div>







