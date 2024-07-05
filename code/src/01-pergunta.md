---
title: Pergunta 1
theme: [glacier,dashboard]
toc: false
---
<style> body, div, p, li, ol, h1, h2 { max-width: none; } </style>

<h1> 1) Qual foi a evolução do índice criminal ao longo dos anos? Algum crime influência mais que o outro para esse índice?  </h1>
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
        Nesta primeira seção do trabalho vamos explorar os atributos do dataset com diversas visualizações para verificar se algum crime tem mais influência que outro no índice criminal (variável criada com a soma de todos os crimes), a evolução desse índice ao longo dos anos, e para o ano mais violento , uma HeatMatrix com o índice de crimes por dia do ano.
    </p>
</div>
<br>



<hr>

## Evolução do índice criminal:

<div class="grid grid-cols-1">
  <div class="card" id="chart_dataset_bpm">     

```js
const multiline_chart_2_data = await db_crimes_all_years.sql`
  SELECT name, feminicide,homicide,felony_murder,bodily_harm,theft_cellphone,robbery_cellphone,theft_auto,armed_robbery_auto,criminal_index
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
        Para analizar a evolução do índice criminal(a some de todos os crimes no período considerado) será utilizado um gráfico de linha com pontos, fazendo a relação entre o ano e a média do índice criminal. Nele podemos verificar o ano de 2017 como o mais violento no período considerado,  e 2014 como o menos violento com um índice criminal aproximadamente 20% menor.
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
        Nas duas seções acima são usados gráficos multilinha. Na primeira seção avaliamos a prevalência de cada crime por ano, e podemos verificar que os delitos ligados a subtração de aparelhos de telefone celular superam todos os outros delitos em toda a série histórica. Também é notável o enorme aumento desses tipo de crime a partir de 2016 em diante.
    </p>    
    <p style="text-align: justify;">   
      Na segunda seção é analisada a influência de cada crime no índice criminal e podemos verificar que quanto maior o índice criminal, roubo e furto de celular trocam  de posição e para os maiores índices o furto de celular é o mais influente. Também podemos verificar que para os menores índices criminais roubo e furto de carro são tão infleuntes quanto o furto de celular.         
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
    return {
        spec: {
          width: divWidth*0.35,
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
              aggregate: "mean",
              title: title_y
          },
          x: {
              field: campo_x,
              title: title_x,
              //aggregate: "mean",
              sort: "asc"
          },
          tooltip: [
          {field: campo_y, type: "quantitative", title: title_y, aggregate: "mean"},
          {field: campo_x, type: "quantitative", title: title_x, /*aggregate: "mean",*/ format:","}
          ],    
          
      }
    }
  }
}

function multiline_chart(data_array){
  return {
    spec: {
      "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
      width: divWidth*0.8,
      height: "400",
      data: {
        values: data_array
      },
      layer: [
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative", title: "Ano",  "axis": {"format": "d"}},
            y: {
              aggregate: "sum", field: "feminicide", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "feminicide", "type": "nominal"},
          },
          name: "child_layer_feminicide"
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "homicide", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "homicide", "type": "nominal"},
          },
          name: "child_layer_homicide"
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "felony_murder", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "felony_murder", "type": "nominal"},
          },
          name: "child_layer_felony_murder"
        },
        {
          mark: "line",
          encoding: {
            x: {field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "bodily_harm", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "bodily_harm", "type": "nominal"},
          },
          name: "child_layer_bodily_harm"
        },
        {
          mark: "line",
          encoding: {
            x: {field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_cellphone", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "theft_cellphone", "type": "nominal"},
          },
          name: "child_layer_theft_cellphone"
        },
        {
          mark: "line",
          encoding: {
            x: { field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "robbery_cellphone", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "robbery_cellphone", "type": "nominal"},
          },
          name: "child_layer_robbery_cellphone"
        },
        {
          mark: "line",
          encoding: {
            x: {field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_auto", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "theft_auto", "type": "nominal"},
          },
          name: "child_layer_theft_auto"
        },
        {
          mark: "line",
          encoding: {
            x: {field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "armed_robbery_auto", type: "quantitative", title: "Soma dos valores"
            },
            color: { datum: "armed_robbery_auto", "type": "nominal"},
          },
          name: "child_layer_armed_robbery_auto"
        },
      ]    
    }
  }
}

function multiline_chart_2(data_array){
  return {
    spec: {
      "$schema": "https://vega.github.io/schema/vega-lite/v5.json",
      width: divWidth*0.8,
      height: "400",
      data: {
        values: data_array
      },
      layer: [
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "feminicide", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "feminicide", "type": "nominal"},
          },
          name: "child_layer_feminicide"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "homicide", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "homicide", "type": "nominal"},
          },
          name: "child_layer_homicide"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "felony_murder", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "felony_murder", "type": "nominal"},
          },
          name: "child_layer_felony_murder"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "bodily_harm", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "bodily_harm", "type": "nominal"},
          },
          name: "child_layer_bodily_harm"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "theft_cellphone", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "theft_cellphone", "type": "nominal"},
          },
          name: "child_layer_theft_cellphone"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "robbery_cellphone", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "robbery_cellphone", "type": "nominal"},
          },
          name: "child_layer_robbery_cellphone"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "theft_auto", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "theft_auto", "type": "nominal"},
          },
          name: "child_layer_theft_auto"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: false, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
            y: {
              aggregate: "mean", field: "armed_robbery_auto", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "armed_robbery_auto", "type": "nominal"},
          },
          name: "child_layer_armed_robbery_auto"
        },
      ]    
    }
  }
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
            {
                "field": "log_streams_total", 
                "type": "quantitative", 
                "title": "Log total do índice de criminalidade",
                "format":",.3s"
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
    'feminicide' as crime,
    sum(feminicide) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'homicide' as crime,
    sum(homicide) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'felony_murder' as crime,
    sum(felony_murder) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'bodily_harm' as crime,
    sum(bodily_harm) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'theft_cellphone' as crime,
    sum(theft_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'robbery_cellphone' as crime,
    sum(robbery_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'theft_auto' as crime,
    sum(theft_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2014
  UNION
  SELECT 
    'armed_robbery_auto' as crime,
    sum(armed_robbery_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2014

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
    'feminicide' as crime,
    sum(feminicide) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'homicide' as crime,
    sum(homicide) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'felony_murder' as crime,
    sum(felony_murder) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'bodily_harm' as crime,
    sum(bodily_harm) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'theft_cellphone' as crime,
    sum(theft_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'robbery_cellphone' as crime,
    sum(robbery_cellphone) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'theft_auto' as crime,
    sum(theft_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2017
  UNION
  SELECT 
    'armed_robbery_auto' as crime,
    sum(armed_robbery_auto) as valor        
    FROM crimes_all_years
    WHERE year = 2017

`;
  const graph_bar_2017 =  bar_chart(data_bar_chart_2017, "2017");
  embed("#bar_crimes_2017",graph_bar_2017.spec)
  ```
  
  </div> 
</div>

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">   
    Esta é uma visualização do total de crimes nos anos de 2014, o menos violento, e do ano de 2017, o mais violento. Os gráficos de barra confirmam o que já vimos no gráfico multilinha, porém aqui podemos quantificar melhor de quanto foi o aumento da criminalidade de 2014 para 2017. Os crimes de roubo de telefone celular que em 2014 estavam abaixo de 500.000 na escala, passam de 600.000 em 2017, um aumento de aproximadamente 22%. Já o crime de furto de telefone celular passou de 231.615 em 2014 para 421.435 em 2017., um aumento de aproximadamente 45%! Da análise dos gráficos também é possível constatar que roubo e furto de carros caiu de 2014 para 2017, o que nos leva a crer que a criminalidade migrou de uma prática para outra, dos crimes de subtração de carros para subtração de telefones celulares.
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
    Nesta visualização, apresentamos uma mapa de calor em formato de matriz para o ano mais violento do período considerado, 2017, com os meses no eixo y e os dias do mês no eixo x. As cores mapeiam o valor do índice criminal para cada data. Quanto maior o índice criminal em um determinado dia do mês, mais escura será a cor do quadrante correspondente. Destacam-se nessa visualização os dias 18/02/2017 e 18/06/2017. Dia 18 de fevereiro de 2017 foi um fina de semana com comemorações de pré caranaval e podemos verificar que nos finais de semana anterior e posterior(carnaval), o índice criminal também é mais elevado do que dos dias adjacentes. Já o dia 18 de junho de 2017 foi o sábado do feriado prolongado de Corpus Christi, e pela visualização da matriz, foi o dia mais violento de 2017 pois, possuí o maior índice criminal dentre todas as datas do ano. No dia 18 de junho de 2017 também aconteceu a 21ª Parada do Orgulho LGBT de São Paulo, um evento de grande porte, aberto ao público na Avenida Paulista e que registrou diversas ocorrências de furto de celular.
    </p>
</div>
<br>
