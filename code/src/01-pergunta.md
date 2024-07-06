---
title: Pergunta 1
theme: [glacier,dashboard]
toc: false
---
<style> body, div, p, li, ol, h1, h2 { max-width: none; } </style>

<h1> 1) Qual foi a evolução do índice criminal da cidade de São Paulo ao longo dos anos? Algum crime influência mais que o outro para esse índice?  </h1>
<hr>

```js
import * as vega from "npm:vega";
import * as vegaLite from "npm:vega-lite";
import * as vegaLiteApi from "npm:vega-lite-api";
import embed from "npm:vega-embed";
let divWidth = Generators.width(document.querySelector(".grid"));
```

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
    Nesta primeira seção do trabalho, vamos explorar os atributos do dataset por meio de visualizações, buscando analisar a cidade de São Paulo como um todo, fazendo a combinação com seus distritos. Nosso objetivo é identificar quais tipos de crimes têm maior influência na construção do índice criminal, que é calculado como a soma de todos os crimes registrados. Para isso, analisaremos a evolução desse índice ao longo dos anos, observando tendências e padrões que possam emergir. Além disso, vamos identificar o ano mais violento no período analisado e desenvolver uma HeatMatrix detalhada para esse ano. Esta HeatMatrix apresentará o valor do índice criminal para cada dia do ano, permitindo uma visualização granular das flutuações diárias na criminalidade. Com essa abordagem, poderemos detectar picos de atividade criminosa, tal informação pode, por exemplo, ajudar pesquisadores a correlacionar esses dados com eventos ocorridos.
    </p>
</div>
<br>



<hr>

## Evolução do índice criminal:

<div class="grid grid-cols-1">
  <div class="card" id="chart_dataset_bpm">     

```js
const multiline_chart_2_data = await db_crimes_all_years.sql`
  SELECT name,
   feminicide as Feminicídio,
   homicide as Homicídio,
   felony_murder as 'Homicídio Qualificado',
   bodily_harm as 'Lesão Corporal',
   theft_cellphone as 'Furto de Celular',
   robbery_cellphone as 'Roubo de Celular',
   theft_auto as 'Furto de Carro',
   armed_robbery_auto as 'Roubo Armado de Carro',
   criminal_index as 'Total de Crimes', 
   year as Ano
    FROM crimes_all_years
    ORDER BY year ASC;
`;
const graph_line_BPM = line_chart(dataset_crimes_all_years, "Índice Criminal por ano", "year", "Ano", "criminal_index", "Índice Criminal");
embed("#chart_dataset_bpm",graph_line_BPM.spec);
```   
    
  </div>
</div>
<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">   
      Para analisar a evolução do índice criminal em São Paulo, utilizaremos um gráfico de linha com pontos, que representará a relação entre o ano e o índice criminal total da cidade, ou seja, a soma dos índices criminais de todos os distritos. Esta visualização permitirá que o usuário passe o mouse sobre os pontos para observar os valores precisos do índice criminal. O gráfico revela que o ano de 2017 foi o mais violento no período considerado, exibindo os valores mais altos do índice criminal. Em contraste, o ano de 2014 se destaca como o menos violento, com um índice criminal aproximadamente 20% menor em comparação a 2017. Esta analise facilita a compreensão das variações anuais no índice criminal, destacando tendências de aumento ou diminuição da criminalidade ao longo do tempo.
    </p>
</div>
<br>


## Soma dos Crimes pelos anos
<div class="grid grid-cols-1">
  <div class="card" id="multiline_chart">         
      ${ vl.render(multiline_chart(dataset_crimes_all_years)) }
  </div>
</div>

## Crime que mais influencia no índice criminal(média)
<div class="grid grid-cols-1">
  <div class="card" id="multiline_chart_2">         
      ${ vl.render(multiline_chart_2(multiline_chart_2_data)) }
  </div>  
</div>

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">   
        Nas duas seções acima, utilizamos gráficos multilinha e de barras empilhadas, respectivamente. Na primeira seção, avaliamos a prevalência de cada tipo de crime por ano. Verificamos que os delitos relacionados à subtração de aparelhos de telefone celular superam todos os outros crimes ao longo de toda a série histórica. É notável o enorme aumento desse tipo de crime a partir de 2016, seguido por uma queda em 2018.
    </p>    
    <p style="text-align: justify;">   
        Na segunda seção, analisamos a influência percentual de cada tipo de crime na construção do índice criminal ao longo dos anos. Observamos que a soma das proporções dos crimes relacionados a roubo e furto de celular contribui com mais de 50% para a formação do índice criminal. Além disso, o roubo armado e o furto de carro também apresentam uma proporção significativa em relação aos anos. Os demais tipos de crimes não contribuem significativamente para este índice. Essas análises revelam padrões importantes na dinâmica da criminalidade em São Paulo. A predominância dos crimes relacionados a celulares destaca a necessidade de estratégias específicas para combater esses delitos.
    </p>
</div>
<br>

```js

/*
*
*/

// Carregamos o dataset.
let dataset_crimes_all_years = await FileAttachment("data/crimes_all_years_nogeom.csv").dsv({delimiter: ";", typed: true});

const db_crimes_all_years = await DuckDBClient.of({crimes_all_years: FileAttachment("data/crimes_all_years_nogeom.csv").dsv({delimiter: ";", typed: true})});


const db_dataset_crimes_dia_2017 = await DuckDBClient.of({crimes_dia_2017: FileAttachment("data/crimes_dia_2017_no_nulls.csv").dsv({delimiter: ";", typed: true})});

const heatmatrix_data = await db_dataset_crimes_dia_2017.sql`
CREATE TEMP TABLE all_dates (
    minha_date VARCHAR,
    streams_total INT DEFAULT 0
);

INSERT INTO all_dates (minha_date)
SELECT
    CONCAT(m, '-', d) AS minha_date
FROM
    (SELECT * FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12)) AS m(m)),
    (SELECT * FROM (VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12),(13),(14),(15),(16),(17),(18),(19),(20),(21),(22),(23),(24),(25),(26),(27),(28),(29),(30),(31)) AS d(d));

SELECT 
    all_dates.minha_date, 
    COALESCE(LOG10(SUM(CAST(s.streams_total AS INT64))), 0) AS log_streams_total,
    COALESCE(SUM(CAST(s.streams_total AS INT64)), 0) AS streams_total
FROM 
    all_dates
LEFT JOIN (
    SELECT 
        CONCAT(month::INTEGER, '-', day::INTEGER) AS minha_date,
        criminal_index::BIGINT AS streams_total
    FROM 
        crimes_dia_2017 
    
) AS s ON all_dates.minha_date = s.minha_date
GROUP BY 
    all_dates.minha_date
ORDER BY 
    all_dates.minha_date;

DROP TABLE all_dates;


`;


/*
*
*/
const vl = vegaLiteApi.register(vega, vegaLite);

function bar_chart(data_array, titulo, campo_x, titulo_x, campo_y, titulo_y){
    // data_array = translateCrimes(data_array);
    return {
        spec: {
          width: divWidth*0.30,
            data: {
                values: data_array
            },
            mark: "bar",
            title: titulo,
            encoding: {
                y: {
                    field: "valor",
                    type: "quantitative",
                    title: "Total"
                },
                x: {
                    field: "crime",
                    title: "Crime",
                    sort: null               
                },
                color: {field: "crime"},
                tooltip: [
                  {field: "valor", type: "quantitative", title: "Total", format: ",.0f"    }
                ],                
            }
        }
    }
}


function line_chart(data_array, titulo, campo_x, title_x, campo_y, title_y){
  return {
    spec: {
      width: divWidth*0.9,
      data: {
          values: data_array
      },
        mark: {
          type: "line",
          point: true
      },
      title: titulo,
      encoding: {
          y: {
              field: campo_y,
              type: "quantitative",
              aggregate: "sum",
              title: title_y
          },
          x: {
              field: campo_x,
              title: title_x,
              //aggregate: "mean",
              sort: "asc"
          },
          tooltip: [
          {field: campo_y, type: "quantitative", title: title_y, aggregate: "sum",format:",.0f"},
          {field: campo_x, type: "quantitative", title: title_x, /*aggregate: "mean",*/ format:"d"}
          ],    
          
      }
    }
  }
}

const MapCrimeType = {
    "feminicide": "Feminicídio",
    "homicide": "Homicídio",
    "felony_murder": "Homicídio Qualificado",
    "bodily_harm": "Lesão Corporal",
    "theft_cellphone": "Furto de Celular",
    "robbery_cellphone": "Roubo de Celular",
    "theft_auto": "Furto de Carro",
    "armed_robbery_auto": "Roubo Armado de Carro",
    "criminal_index": "Total de Crimes"
};

function translateCrimes(data_array) {
    const translated_data = [];
    for (let i = 0; i < data_array.batches[0].data.children[1].values.length; i++) {
        const crime_code = Object.keys(MapCrimeType)[i];
        translated_data.push({
            crime: MapCrimeType[crime_code] || crime_code,
            valor: data_array.batches[0].data.children[1].values[i]
        });
    }
    return translated_data;
}

function multiline_chart(data_array) {
  return {
    spec: {
      "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
      width: divWidth * 0.8,
      height: "400",
      data: {
        values: data_array
      },
      layer: [
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative", title: "Ano", axis: { format: "d" } },
            y: {
              aggregate: "sum", field: "feminicide", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["feminicide"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "feminicide", type: "quantitative", title: "Feminicídio", format: ",.0f" }
            ]
          },
          name: "child_layer_feminicide"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "feminicide", type: "quantitative"
            },
            color: { datum: MapCrimeType["feminicide"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "feminicide", type: "quantitative", title: "Feminicídio", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "homicide", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["homicide"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "homicide", type: "quantitative", title: "Homicídio", format: ",.0f" }
            ]
          },
          name: "child_layer_homicide"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "homicide", type: "quantitative"
            },
            color: { datum: MapCrimeType["homicide"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "homicide", type: "quantitative", title: "Homicídio", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "felony_murder", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["felony_murder"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "felony_murder", type: "quantitative", title: "Homicídio Qualificado", format: ",.0f" }
            ]
          },
          name: "child_layer_felony_murder"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "felony_murder", type: "quantitative"
            },
            color: { datum: MapCrimeType["felony_murder"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "felony_murder", type: "quantitative", title: "Homicídio Qualificado", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "bodily_harm", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["bodily_harm"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "bodily_harm", type: "quantitative", title: "Lesão Corporal", format: ",.0f" }
            ]
          },
          name: "child_layer_bodily_harm"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "bodily_harm", type: "quantitative"
            },
            color: { datum: MapCrimeType["bodily_harm"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "bodily_harm", type: "quantitative", title: "Lesão Corporal", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_cellphone", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["theft_cellphone"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "theft_cellphone", type: "quantitative", title: "Furto de Celular", format: ",.0f" }
            ]
          },
          name: "child_layer_theft_cellphone"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_cellphone", type: "quantitative"
            },
            color: { datum: MapCrimeType["theft_cellphone"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "theft_cellphone", type: "quantitative", title: "Furto de Celular", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "robbery_cellphone", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["robbery_cellphone"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "robbery_cellphone", type: "quantitative", title: "Roubo de Celular", format: ",.0f" }
            ]
          },
          name: "child_layer_robbery_cellphone"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "robbery_cellphone", type: "quantitative"
            },
            color: { datum: MapCrimeType["robbery_cellphone"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "robbery_cellphone", type: "quantitative", title: "Roubo de Celular", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_auto", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["theft_auto"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "theft_auto", type: "quantitative", title: "Furto de Carro", format: ",.0f" }
            ]
          },
          name: "child_layer_theft_auto"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_auto", type: "quantitative"
            },
            color: { datum: MapCrimeType["theft_auto"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "theft_auto", type: "quantitative", title: "Furto de Carro", format: ",.0f" }
            ]
          }
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "armed_robbery_auto", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: MapCrimeType["armed_robbery_auto"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "armed_robbery_auto", type: "quantitative", title: "Roubo Armado de Carro", format: ",.0f" }
            ]
          },
          name: "child_layer_armed_robbery_auto"
        },
        {
          mark: "point",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "armed_robbery_auto", type: "quantitative"
            },
            color: { datum: MapCrimeType["armed_robbery_auto"], type: "nominal" },
            tooltip: [
              { field: "year", type: "quantitative", title: "Ano" },
              { aggregate: "sum", field: "armed_robbery_auto", type: "quantitative", title: "Roubo Armado de Carro", format: ",.0f" }
            ]
          }
        }
      ]
    }
  }
}



function multiline_chart_2(data_array) {
  return {
    spec: {
      "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
      width: divWidth * 0.8,
      height: "400",
      data: {
        values: data_array
      },
      mark: "bar",
      encoding: {
        x: {
          field: "Ano",
          type: "ordinal",
          title: "Ano"
        },
        y: {
          aggregate: "sum",
          field: "proportion",
          type: "quantitative",
          title: "Proporção de Crimes",
          axis: {
            format: "%"
          }
        },
        color: {
          field: "crime",
          type: "nominal",
          title: "Tipo de Crime",
          scale: {
            domain: [
              "Feminicídio",
              "Homicídio",
              "Homicídio Qualificado",
              "Lesão Corporal",
              "Furto de Celular",
              "Roubo de Celular",
              "Furto de Carro",
              "Roubo Armado de Carro"
            ],
            range: [
              "#1f77b4",
              "#ff7f0e",
              "#2ca02c",
              "#d62728",
              "#9467bd",
              "#8c564b",
              "#e377c2",
              "#7f7f7f"
            ]
          },
          legend: {
            title: "Tipo de Crime"
          }
        },
        tooltip: [
          { field: "Ano", type: "ordinal", title: "Ano" },
          { field: "crime", type: "nominal", title: "Tipo de Crime" },
          { aggregate: "sum", field: "value", type: "quantitative", title: "Total", format: ",.0f" },
          { aggregate: "sum", field: "proportion", type: "quantitative", title: "Proporção", format: ".1%" }
        ]
      },
      transform: [
        { fold: ["Feminicídio", "Homicídio", "Homicídio Qualificado", "Lesão Corporal", "Furto de Celular", "Roubo de Celular", "Furto de Carro", "Roubo Armado de Carro"], as: ["crime", "value"] },
        {
          window: [{ op: "sum", field: "value", as: "total_crimes" }],
          frame: [null, null],
          groupby: ["Ano"]
        },
        {
          calculate: "datum.value / datum.total_crimes",
          as: "proportion"
        }
      ]
    }
  };
}


const graph_heatmatrix = {
    width: divWidth*0.85,
    height: "268",
    "data": { values: heatmatrix_data},
    "title": "Índice de criminalidade em cada dia de 2017",
    "config": {
        "view": {
            "strokeWidth": 0,
            "step": 13
        },
        "axis": {
            "domain": false
        }
    },
    "mark": "rect",
    "encoding": {
        "x": {
            "field": "minha_date",
            "timeUnit": "date",
            "type": "ordinal",
            "title": "Dia",
            "axis": {
                "labelAngle": 0,
                "format": "%e"
            }
        },
        "y": {
            "field": "minha_date",
            "timeUnit": "month",
            "type": "ordinal",
            "title": "Mês"
        },
        "color": {
            "field": "streams_total",
            "type": "quantitative",
            "legend": {
                "title": "Índice de criminalidade",
                "format": ",.0s"
            }
        },
        "tooltip": [
            {
                "field": "minha_date", 
                "timeUnit": "date",
                "type": "ordinal", 
                "title": "Dia",
            },  
            {
                "field": "minha_date", 
                "timeUnit": "month",
                "type": "ordinal", 
                "title": "Mês",
            },
            {
                "field": "minha_date", 
                "timeUnit": "day",
                "type": "ordinal", 
                "title": "dia da semana",
            },          
            {
                "field": "streams_total", 
                "type": "quantitative", 
                "title": "Total do índice de criminalidade",
                "format":","
            },
        
        ]
    }
}

embed("#chart_heatmatrix", graph_heatmatrix)
```
## Total dos tipos de crime para os anos mais e menos violentos:


<div class="grid grid-cols-2">  
  <div class="card" id="bar_crimes_2014">  
      <span style="font-size: 80%;"></span> 

  ```js
  const data_bar_chart_2014 = await db_crimes_all_years.sql`
  SELECT 
    'Feminicídio' as crime,
    sum(feminicide) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Homicídio' as crime,
    sum(homicide) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Homicídio Qualificado' as crime,
    sum(felony_murder) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Lesão Corporal' as crime,
    sum(bodily_harm) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Furto de Celular' as crime,
    sum(theft_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Roubo de Celular' as crime,
    sum(robbery_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Furto de Carro' as crime,
    sum(theft_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'Roubo Armado de Carro' as crime,
    sum(armed_robbery_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2014;


`;
  const graph_bar_2014 =  bar_chart(data_bar_chart_2014, "2014");
  embed("#bar_crimes_2014",graph_bar_2014.spec)
  ```
  
  </div>  

  <div class="card" id="bar_crimes_2017">  
      <span style="font-size: 80%;"></span> 

  ```js
  const data_bar_chart_2017 = await db_crimes_all_years.sql`
 SELECT 
    'Feminicídio' as crime,
    sum(feminicide) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Homicídio' as crime,
    sum(homicide) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Homicídio Qualificado' as crime,
    sum(felony_murder) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Lesão Corporal' as crime,
    sum(bodily_harm) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Furto de Celular' as crime,
    sum(theft_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Roubo de Celular' as crime,
    sum(robbery_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Furto de Carro' as crime,
    sum(theft_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'Roubo Armado de Carro' as crime,
    sum(armed_robbery_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2017;

`;
  const graph_bar_2017 =  bar_chart(data_bar_chart_2017, "2017");
  embed("#bar_crimes_2017",graph_bar_2017.spec)
  ```
  
  </div> 
</div>

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">   
      Acima, observamos visualizações do total de crimes nos anos de 2014, o menos violento, e 2017, o mais violento. Aqui podemos quantificar com mais precisão o aumento da criminalidade de 2014 para 2017. Os crimes de roubo de telefone celular, que em 2014 estavam abaixo de 500.000, ultrapassaram 600.000 em 2017, representando um aumento de aproximadamente 22%. Além disso, o crime de furto de telefone celular aumentou de 231.615 em 2014 para 421.435 em 2017, um aumento significativo de cerca de 45%. Da análise dos gráficos, também é possível constatar que os crimes de roubo armado de carros diminuiu de 2014 para 2017. Isso sugere que a criminalidade pode ter migrado de uma prática para outra, com os criminosos focando menos na subtração de carros e mais na subtração de telefones celulares.
    </p>
</div>
<br>

<hr>

## HeatMatrix

<div class="grid grid-cols-1">
  <div class="card" id="chart_heatmatrix">   
  </div>  
</div>

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">   
    Nesta visualização, apresentamos um mapa de calor em formato de matriz para o ano mais violento do período considerado, 2017, com os meses no eixo y e os dias do mês no eixo x. As cores mapeiam o valor do índice criminal para cada data. Quanto maior o índice criminal em um determinado dia do mês, mais escura será a cor do quadrante correspondente. Destacam-se nessa visualização os dias 18/02/2017 e 18/06/2017. O dia 18 de fevereiro de 2017 foi um fim de semana com comemorações de pré-carnaval, e podemos verificar que nos finais de semana anterior e posterior (carnaval), o índice criminal também é mais elevado do que nos dias adjacentes. Já o dia 18 de junho de 2017 foi o sábado do feriado prolongado de Corpus Christi, e pela visualização da matriz, foi o dia mais violento de 2017, pois possui o maior índice criminal dentre todas as datas do ano. Nesse dia, também aconteceu a 21ª Parada do Orgulho LGBT de São Paulo, um evento de grande porte na Avenida Paulista que registrou diversas ocorrências de furto de celular.
    </p>
</div>
<br>
