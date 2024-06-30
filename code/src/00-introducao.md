---
theme: [dashboard,glacier]
title: Introdução
toc: false
---
<style> body, div, p, li, ol, h1 { max-width: none; } </style>

## Introdução
<div style="background-color: #f2f2f2; border-left: 6px solid royalblue; padding: 10px; margin-bottom:50px">
    <p style="text-align: justify;">   
    Este trabalho consiste em uma análise detalhada de um dataset composto por músicas presentes na plataforma de streaming de áudio Spotify. Utilizando um conjunto de diversas visualizações, vamos responder às perguntas propostas. É importante ressaltar que o dataset não é um conjunto exaustivo, pois não contém todas as músicas presentes na plataforma (possui somente 953 registros), bem como não avalia todas as propriedades possíveis de uma música. Por exemplo, a duração da música não está presente nos dados. O dataset inclui informações como o nome da música, seu número de streams até meados de 2023, e vários outros atributos listados abaixo. 
    </p>
</div>

- **track_name**: Nome da música.
- **artist(s)_name**: Nome(s) dos artistas(s) envolvidos na música.
- **artist_count**: Número de artistas contribuindo na música.
- **released_year**: Ano de lançamento.
- **released_month**: Mês de lançamento.
- **released_day**: Dia do mês do lançamento.
- **in_spotify_playlists**: Número de playlists do spotify que incluem a  música.
- **in_spotify_charts**: Presença e posição da música no ranking do spotify.
- **streams**: Número total de streams no spotify.
- **in_apple_playlists**: Número de playlists da Apple que incluem a  música.
- **in_apple_charts**: Presença e posição da música no ranking da Apple Music.
- **in_deezer_playlists**: Número de playlists do Deezer que incluem a  música.
- **in_deezer_charts**: Presença e posição da música no ranking do Deezer.
- **in_shazam_charts**: Presença e posição da música no ranking do Shazam.
- **bpm**: Batidas por minuto, indicando o andamento da música.
- **key**: Tom da música.
- **mode**: Modo (maior ou menor).
- **danceability_%**: Porcentagem indicando o quão adequada a música é para dançar.
- **valence_%**: Medida da positividade musical transmitida pela música.
- **energy_%**: Nível de energia percebido da música.
- **acousticness_%**: Proporção de sons acústicos na música.
- **instrumentalness_%**: Proporção de sons instrumentais na música.
- **liveness_%**: Presença de elementos gravados ao vivo.
- **speechiness_%**: Quantidade de palavras faladas na música.