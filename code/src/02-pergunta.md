---
theme: [glacier]
title: Pergunta 2
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

<h1> 2) Como é a concentração e a relação dos crimes dos distrito da cidade de São Paulo?</h1>
<hr>

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
    Para esta seção, iremos analisar a ocorrência de crimes nos distritos. Utilize o filtro abaixo para alterar o intervalo de anos dos dados, que atualizará automaticamente os gráficos e tabela geradas. Além disso, dois filtros permitem que o usuário selecione os tipos de crime que deseja analisar, possibilitando a construção de um gráfico de dispersão para estudar a correlação entre esses diferentes crimes. Iremos levar em consideração para a nossa análise nessa seção todos os anos, porém o usuário pode facilmente filtrar os anos que tiver interesse e tirar suas próprias conclusões.
    </p>
</div>
<br>

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
let divWidth = Generators.width(document.querySelector(".grid"));
```



<div class="yearSelect">

<div style="display: flex; justify-content: space-between; width: 100%; margin-bottom:10px; margin-top:30px;">

```js
let yearInf = view(Inputs.range([2011, 2018], {value: 2014, step: 1, label: "Ano Inferior"}));
```

```js
let yearSup = view(Inputs.range([2011, 2018], {value: 2017, step: 1, label: "Ano Superior"}));
```

</div>

```js
const MapCrimeType = {
    "feminicide": "Feminicídio",
    "homicide": "Homicídio",
    "felony_murder": "Homicídio Qualificado",
    "bodily_harm": "Lesão Corporal",
    "theft_cellphone": "Furto de Celular",
    "robbery_cellphone": "Roubo de Celular",
    "theft_auto": "Furto de Carro",
    "armed_robbery_auto": "Roubo Armado de Carro",
    "criminal_index": "Índice Criminal"
};
function translateCrimeNames(data_array) {
    return data_array.map(item => {
        let translated_item = {};
        for (let key in item) {
            translated_item[MapCrimeType[key] || key] = item[key];
        }
        return translated_item;
    });
}

const box = [MapCrimeType["feminicide"], MapCrimeType["homicide"], MapCrimeType["felony_murder"], MapCrimeType["bodily_harm"], MapCrimeType["theft_cellphone"], MapCrimeType["robbery_cellphone"], MapCrimeType["theft_auto"], MapCrimeType["armed_robbery_auto"], MapCrimeType["criminal_index"]]
let selectBox_x = view(Inputs.select([MapCrimeType["theft_cellphone"]].concat(box), {label: "Tipo de crime X"}));
let selectBox_y = view(Inputs.select([MapCrimeType["robbery_cellphone"]].concat(box), {label: "Tipo de crime Y"}));
```

</div>


```js
let dataset_crimes_all_years = await FileAttachment("data/crimes_all_years_nogeom.csv").dsv({delimiter: ";", typed: true});
let dataset = translateCrimeNames(dataset_crimes_all_years.filter(element => element.year >= yearInf && element.year <= yearSup));
console.log(dataset)
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
    if(crime !== "Índice Criminal"){
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

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      A tabela acima inclui todos os distritos presentes em nossa base de dados, exibindo a maior quantidade de crimes já registrada, o tipo desse crime e o ano em que ocorreu. Ao ajustar os filtros de ano para o intervalo de 2011 a 2018, podemos observar que os crimes mais comuns foram roubo e furto de celulares. Esses altos valores de crimes prevaleceram principalmente entre os anos de 2017 e 2018, sugerindo uma tendência de crescimento desse tipo de crime ao longo dos anos.
    </p>
</div>
<br>

```js
const maxCrimesByType = {};

data_table.forEach(entry => {
  box.forEach(crime => {

    if (!maxCrimesByType[crime] || entry[crime] > maxCrimesByType[crime].Value) {
    maxCrimesByType[crime] = {
        "Crime": crime,
        "Value": entry[crime],
        "District": entry.name,
        "Year": entry.year
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
          { "field": "District", "type": "nominal", "title": "Distrito" },
          { "field": "Year", "type": "nominal", "title": "Ano"}
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

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      Para representar o maior número de crimes já observado por tipo, utilizamos barras como marcadores para os tipos de crime e cores para indicar os distritos onde essas observações ocorreram. Ao levar o mouse para cima da barra, o usuário pode também observar o nome do distrito, o tipo de crime, a quantidade observada e o ano de ocorrência. Observamos que, ao considerar todo o intervalo de anos da nossa base de dados, o distrito República apresentou os maiores valores de roubo e furto de celulares. O distrito Jaguara destacou-se com os maiores valores de furto de carro e homicídio. Os maiores valores de roubo armado de carro foram registrados no distrito de Jabaquara. Outros tipos de crimes, como lesão corporal, homicídio qualificado e feminicídio, não apresentaram valores relevantes em nossa base de dados.
    </p>
</div>
<br>

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

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      Para analisar a variação dos valores de crimes por tipo, construímos um gráfico boxplot. Este gráfico permite observar percentis importantes, o intervalo dos valores observados e a presença de outliers. Ao passar o mouse sobre as barras, o usuário pode verificar os intervalos de valores e percentis. Ao passar o mouse sobre os pontos, que representam os outliers, o usuário pode ver em qual distrito o outlier ocorreu, o ano e a quantidade observada.
    </p>
    <br>
    <p style="text-align: justify;">
      Em relação a todo o período dos dados, não tivemos valores significativos para construir boxplots de maneira satisfatória para lesão corporal, homicídio qualificado, feminicídio e homicídio. Para os demais tipos de crimes, observamos uma alta presença de outliers, destacando-se visualmente a maior ocorrência de outliers para o crime de furto de celulares. Excluindo o índice criminal, que é a soma de todos os crimes, o crime que apresentou a maior mediana foi o de robo de celular
    </p>
</div>
<br>




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
                "y": { "value": divWidth*0.3 },
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

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
      Para estudar a relação entre os tipos de crimes, optamos pelo uso do gráfico de dispersão devido à sua capacidade de visualizar a relação entre duas variáveis quantitativas de maneira clara e intuitiva, permitindo que o usuário selecione as variáveis desejadas através dos filtros. Este tipo de gráfico nos permite representar as observações da nossa base de dados por marcadores de pontos, facilitando a identificação de padrões ou tendências. Ao passar o mouse sobre os pontos do gráfico, o usuário pode visualizar o nome do distrito, as quantidades dos crimes e o ano de ocorrência. Além disso, como complemento à visualização do gráfico de dispersão, calculamos o coeficiente de correlação entre os tipos de crimes selecionados, oferecendo uma medida quantitativa da relação entre eles.
    </p>
    <br>
    <p style="text-align: justify;">
      Este gráfico permite estudar a relação entre qualquer combinação de dois tipos de crimes. Por exemplo, ao analisar roubo e furto de celulares durante todo o período de anos, observamos uma correlação de 0.43. Embora seja fraca, isso pode indicar que esses dois tipos de crime possuem alguma relação direta, o que faz sentido, pois ambos envolvem celulares. Da mesma forma, podemos analisar furto e roubo armado de carros, que apresentam uma correlação de 0.35. Ao comparar roubo a mão armada de carro e roubo de celulares, encontramos uma correlação de 0.56, indicando uma relação mais significativa, possivelmente porque ambos estão relacionados ao roubo. Por outro lado, ao comparar furto de carro e furto de celulares, a correlação é de apenas 0.18, considerada baixa.
    </p>
</div>
<br>






