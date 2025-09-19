# Overpass-API-service

## Descrição
Serviço responsável por integrar ao projeto uma ferramenta de terceiros. O serviço em si é independente dos demais, e funciona normalmente como aplicação individual.

## Funcionamento
Seu funcionamento como API é simples, o mesmo recebe uma requisição HTTP POST e retorna o que foi solicitado com base em um banco de dados local já populado. É utilizado a porta padrão do Apache, porta **80**, para realizar a execução do serviço. A abordagem conteinarizada da aplicação exige que já se tenha um banco de daods populado, para facilitar essa parte foi definida uma imagem que possui como função exclusiva realizar esse tipo de serviço, o Dockerfile desta imagem está presente na pasta denominada [OverpassAPI-Populator](https://github.com/projetomaram/Overpass-API-service/tree/main/OverpassAPI-Populator).

## Exemplo de uso individual
O preenchimento do banco de dados local exige inicialmente um arquivo .pbf, para obter esse arquivo foi utilizado o site [Geofabrik](https://download.geofabrik.de/). No caso atual vamos manipular os arquivos em somente uma pasta, portanto é aconselhado que se utilize uma pasta vazia. Com a pasta já definida é necessário realizar o download do arquivo .pbf, como exemplo utilizamos o arquivo referente a região sul do Brasil:
```bash
wget "https://download.geofabrik.de/south-america/brazil/sul-latest.osm.pbf"
```
O comando acima irá baixar o arquivo de sua escolha no local atual de seu terminal. Já baixado o arquivo .pbf é necessário criar no mesmo local a pasta que vai conter os arquivos referente ao banco de dados.
```bash
mkdir db
```
Tanto o arquivo quanto a pasta criada serão passados como parâmentro para a imagem docker criar o contêiner e popular o banco de dados:
```bash
docker run --rm -v "$(pwd)/sul-latest.osm.pbf:/overpass/data/input.pbf:ro" -v "$(pwd)/db:overpass/db" projetomaram/robot-project:overpass-populator
```
Onde nos locais que está escrito "sul-latest.osm.pbf" é necessário inserir o nome do arquivo baixado via [Geofabrik](https://download.geofabrik.de/).

Vale ressaltar que este é um processo um tanto quanto demorado, vai depender portando da capacidade de processamento e memória RAM do computador no qual está sendo executado, o tamanho do arquivo .pbf também é influência diretamente no tempo de execução deste processo.

Após o banco de dados local estar completamente populado, o comando abaixo executa o serviço:
```bash
docker run -d -p 80:80 -e DB_DIR="/opt/overpass/db" -v "$(pwd)/db:/opt/overpass/db projetomaram/robot-project:overpass
```
Com a execução do comando acima, espera-se que a aplicação já esteja em execução, para teste é possível utilizar o arquivo **teste_req.ql** por meio do seguinte comando:
```bash
curl -X POST -d @teste_req.ql "https://localhost/api/interpreter"
```
É esperado como retorno um conjunto de pontos (LAT, LONG) da API.








