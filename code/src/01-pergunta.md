---
title: Pergunta 1
theme: [glacier,dashboard]
toc: false
---
<style> body, div, p, li, ol, h1 { max-width: none; } </style>

<h1> 1) Mostrar a evolução dos crimes ao longos dos anos de 2011 a 2018 em um gráfico de linhas. Todos os crimes juntos. Algum crime se destaca? Mostrar índice criminal ao longo dos anos num gráfico de barras. Qual o ano com o maior índice? A partir do ano com maior índice criminal, mostrar HeatMatrix com os meses (eixo y) e os dias do ano(eixo x) com o índice criminal por dia. [Será precisa extrair um dataset do Apache Hive para o ano mais criminoso com essas informações] </h1>
<hr>

```js
import * as vega from "npm:vega";
import * as vegaLite from "npm:vega-lite";
import * as vegaLiteApi from "npm:vega-lite-api";
import embed from "npm:vega-embed";
let divWidth = 670;
```

<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">
        Nesta primeira seção do trabalho vamos explorar os atributos do dataset com diversas visualizações para verificar se algum valor específico, ou faixa de valor, desses atributos tem alguma influência relevante na posição da música no conjunto. Serão apresentadas visualizações para o mês de lançamento, o dia de lançamento, BPM, para todas as propriedades percentuais, e também para as propriedades musicais(tom da música). Exceto pela visualização de  dia de lançamento, todas usam o dataset já ordenado pelo número de streams.
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
/*
const graph_line_data = await db_crimes_all_years.sql`
  SELECT year, sum(criminal_index) as criminal_index
    FROM crimes_all_years
    GROUP BY year
    ORDER BY year ASC;
`;

console.log(graph_line_data);
*/
const graph_line_BPM = line_chart(dataset_crimes_all_years, "Índice Criminal por ano", "year", "Ano", "criminal_index", "Índice Criminal");
embed("#chart_dataset_bpm",graph_line_BPM.spec);
```   
    
  </div>
</div>
<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px;">
    <p style="text-align: justify;">   
        Para analizar o BPM(batidas por minuto) será utilizado um gráfico de linha com pontos, fazendo a relação entre BPM das músicas e a média de streams. Nele podemos verificar que para valores mais baixos na escala de streams, o BPM das músicas oscila bastante entre valores altos e baixos. Porém para valores mais altos da média de stream(aonde estão as  músicas mais populares), podemos constatar  que o valor de BPM possui menos variação.
    </p>
</div>
<br>


## Crime mais prevalente por ano(média)
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
        Aqui é utilizado um gráfico multilinha para explorar os atributos que são apresentados com um valor percentual. São eles: danceability(o quão dançante é  a música), valence (positividade da música), energy (nível de energia associado à música), acousticness (sons acústicos na música), instrumentalness (proporção de instrumental na música), liveness (presença de elementos de gravação ao vivo na música) e speechiness (presença de vocais na música). Aqui vamos analizar as duas pontas do gráfico para verificar se um valor alto ou baixo de uma propriedade influencia no sucesso da música, e também vamos ver se alguma propriedade é mais relevante que outra.         
    </p>
    <ul style="max-width: none;">
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">danceability:</span> as músicas com mais streams estão associadas com valores acima de 65, próximos a 70, no entanto as músicas com menos streams também apresentam esse comportamento. 
        </p>
      </li>
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">valence:</span> essa  é uma propriedade que mostra uma relevância de maiores valores para alcançar o sucesso. As músicas com mais streams apresentam valores entre 60 e 65, enquanto as com menos streams tem valores um pouco acima de 50.
        </p>
      </li>
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">energy:</span> as músicas com mais streams apresentam valores acima de 70, enquanto as com menos streams estão estávei em torno de 65.
        </p>
      </li>
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">acousticness:</span> tanto as músicas com menos streams quanto as com mais strams apresentam valores próximo de 30, no entanto na parte média do gráfico tem um grande aumento de valor, mais próximo à 40.
        </p>
      </li>
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">instrumentalness:</span> essa parece ser uma propriedade irrelevante, todo o conjunto apresenta valores próximo à 0.
        </p>
      </li>
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">liveness:</span> dois terços do conjunto apresentam valores próximos à 20, no entanto as músicas mais populares apresentam valores abaixo de 10. 
        </p>
      </li>
      <li>
        <p style="text-align: justify;">   
          <span style="font-weight: 700;">speechiness:</span> a maior parte do conjunto apresenta valor estável próximo de 8, no entanto as músicas com menos streams apresentam valores acima de 10.
        </p>
      </li>
    </ul>
    
</div>
<br>

```js

/*
*
*/

// Carregamos o dataset.
let dataset = await FileAttachment("data/spotify-2023.csv").csv({typed: true});
let dataset_crimes_all_years = await FileAttachment("data/crimes_all_years_nogeom.csv").dsv({delimiter: ";", typed: true});

const db_crimes_all_years = await DuckDBClient.of({crimes_all_years: FileAttachment("data/crimes_all_years_nogeom.csv").dsv({delimiter: ";", typed: true})});


//console.log(dataset_crimes_all_years);
// Ordenamos o dataset por streams, de forma CRESCENTE.
dataset = dataset.sort((a, b) => (a.streams > b.streams ? 1 : -1));

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
          width: "container",
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
                    sort: null,                    
                },
                color: {field: "crime"},
                tooltip: [
                  {field: "valor", type: "quantitative", title: "Total"}
                ],                
            }
        }
    }
}

function bar_chart2(data_array, titulo, campo_x, titulo_x, campo_y, titulo_y){
  return {
    spec: {
      data: {
          values: data_array
      },
      width: "container",
      mark: "bar",
      title: titulo,
      encoding: {
        x: {
            field: "tom_da_musica",
            title: "Tom da música",
            sort: null
        },
        y: {
            field: "streams",
            type: "quantitative",
            title: "Total de streams"
        } ,
        tooltip: [
        {field: campo_y, title: titulo_y},
        {field: campo_x, title: titulo_x, format:","}
        ],                
      },
    }
  }
}

function line_chart(data_array, titulo, campo_x, title_x, campo_y, title_y){
  return {
    spec: {
      width: "container",
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
      width: "600",
      height: "400",
      data: {
        values: data_array
      },
      layer: [
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "feminicide", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "feminicide", "type": "nominal"},
          },
          name: "child_layer_feminicide"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "homicide", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "homicide", "type": "nominal"},
          },
          name: "child_layer_homicide"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "felony_murder", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "felony_murder", "type": "nominal"},
          },
          name: "child_layer_felony_murder"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "bodily_harm", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "bodily_harm", "type": "nominal"},
          },
          name: "child_layer_bodily_harm"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_cellphone", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "theft_cellphone", "type": "nominal"},
          },
          name: "child_layer_theft_cellphone"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "robbery_cellphone", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "robbery_cellphone", "type": "nominal"},
          },
          name: "child_layer_robbery_cellphone"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "theft_auto", type: "quantitative", title: "Média do valor da propriedade"
            },
            color: { datum: "theft_auto", "type": "nominal"},
          },
          name: "child_layer_theft_auto"
        },
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "year", type: "quantitative" },
            y: {
              aggregate: "sum", field: "armed_robbery_auto", type: "quantitative", title: "Média do valor da propriedade"
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
      width: "600",
      height: "400",
      data: {
        values: data_array
      },
      layer: [
        {
          mark: "line",
          encoding: {
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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
            x: { bin: true, field: "criminal_index", type: "quantitative", title: "Índice criminal" },
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

console.log(heatmatrix_data.batches[0].data.children[0]);

const graph_heatmatrix = {
    width: "container",
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

function popula_months_array(months_array, dataset){
  // Iteramos no dataset para extrair os lançamentos por mês e popular o array.
  for(var i=0;i<dataset.length;i++){
    switch(dataset[i].released_month){
      case 1: 
        months_array[0].lancamentos++; 
        break;
      case 2:
        months_array[1].lancamentos++;
        break;
      case 3:
        months_array[2].lancamentos++;
        break;
      case 4:
        months_array[3].lancamentos++;
        break;
      case 5:
        months_array[4].lancamentos++;
        break;
      case 6:
        months_array[5].lancamentos++;
        break;
      case 7:
        months_array[6].lancamentos++;
        break;
      case 8:
        months_array[7].lancamentos++;
        break;
      case 9:
        months_array[8].lancamentos++;
        break;
      case 10:
        months_array[9].lancamentos++;
        break;
      case 11:
        months_array[10].lancamentos++;
        break;
      case 12:
        months_array[11].lancamentos++;
        break;
      default:
        //do nothing
        break;
    }
  }
  return months_array;
}
```
## Total dos tipos de crime por ano (colocar interação para escolher o ano):


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
    Este conjunto de visualizações apresenta o número de lançamentos por mês. O dataset foi ordenado por streams em ordem crescente e dividido em intervalos de quartis. Utilizou-se um gráfico de barras, pois cada mês atua como um "pote" onde os lançamentos são agrupados, permitindo uma comparação visual direta e quantitativa entre os diferentes intervalos. Primeiramente, o gráfico com o dataset completo é apresentado, revelando que os meses de janeiro e maio possuem os maiores números de lançamentos, sendo os únicos com mais de 100. Em seguida, quatro visualizações são mostradas, uma para cada quartil do dataset, dividido com base nos valores de streams.
    No primeiro gráfico, que representa o primeiro quartil, o mês de maio se destaca. No segundo e terceiro gráfico, o padrão se mantém, com maio continuando a ter destaque. No quarto gráfico, que representa o quartil com os maiores valores de streams, observa-se uma mudança, o mês de janeiro se destaca significativamente. Este último intervalo é o mais relevante para nosso estudo, pois contém as BPMs com os maiores números de visualizações.
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
    Nesta visualização, apresentamos um mapa de calor em formato de matriz, com os meses no eixo y e os dias do mês no eixo x. As cores mapeiam o valor de streams em escala logarítmica para cada data, uma escolha feita devido ao grande intervalo de variação no número de streams. Para visualizar o número exato de streams em cada data, o recurso de tooltip pode ser utilizado ao passar o mouse sobre os quadrantes. Quanto mais lançamentos ocorrerem em um determinado dia do mês, mais escura será a cor do quadrante correspondente. Os dias 6 de maio e 1º de janeiro se destacam com as cores mais escuras, corroborando os achados das visualizações de gráfico de barras que já apontavam esses meses como os com maior número de lançamentos de BPMs.
    </p>
</div>
<br>
