# Projeto de Algoritmo Genético para Formação de Times
## Descrição
Este projeto implementa um algoritmo genético (AG) para otimizar a formação de times baseado em critérios específicos de performance e combinações de jogadores. O objetivo é criar times equilibrados, considerando as notas dos jogadores e certas combinações desejadas ou indesejadas.

## Entrada de Dados
### Formato dos Dados dos Jogadores
O algoritmo requer um conjunto específico de dados para cada jogador para funcionar corretamente. Estes dados devem incluir o nome do jogador, sua posição e sua nota (performance). O formato esperado é um texto em string no formato de lista, onde cada linha representa um jogador e deve seguir este formato:

```
"<Número>. <Nome do Jogador> (<Posição>) - <Nota>"
```
*  `<Número>`: Um número sequencial para cada jogador.
* `<Nome do Jogador>`: O nome ou identificador do jogador.
* `<Posição>`: A posição do jogador, como GOL (goleiro), ATA (atacante), MEI (meia) e ZAG (zagueiro).
* `<Nota>`: A nota ou classificação do jogador, indicando seu desempenho ou habilidade (0-10).

### Exemplo de Entrada
Aqui está um exemplo de como os dados dos jogadores devem ser formatados:
```
'''
1. Jogador 1 (GOL) - 8,2
2. Jogador 2 (ATA) - 7,8
3. Jogador 3 (MEI) - 6,5
4. Jogador 4 (ZAG) - 7,1
...
21. Jogador 21 (ATA) - 6,9
'''
```
### Preparando os Dados para o Algoritmo
Esses dados devem ser passados como uma string única para a função *createPlayerDataFrame()* que irá transformá-los em um DataFrame utilizável pelo algoritmo. O DataFrame resultante é então utilizado nas funções subsequentes do algoritmo genético para a formação dos times.

## Saída de Dados
Após a execução do algoritmo, a saída é apresentada como um conjunto de DataFrames, cada um representando um time. Cada DataFrame contém informações detalhadas sobre os jogadores selecionados para aquele time, incluindo nome, posição, nota de desempenho e o time ao qual foram alocados.

### Formato dos DataFrames de Saída
Cada DataFrame terá as seguintes colunas:

* `Player`: Nome do jogador.
* `Position`: Posição do jogador no campo.
* `Rating`: Nota de desempenho do jogador.
* `Team`: Nome do time (Azul, Branco ou Laranja).

### Exemplo de Saída
Aqui está um exemplo de como a saída pode ser apresentada para um dos times:
```
 Player       Position  Rating    Team
1  Jogador 1    GOL      7.54     Laranja
2  Jogador 2    ZAG      6.70     Laranja
3  Jogador 3    ZAG      5.58     Laranja
4  Jogador 4    MEI      6.74     Laranja
5  Jogador 5    MEI      6.62     Laranja
6  Jogador 6    MEI      6.46     Laranja
7  Jogador 7    ATA      5.92     Laranja
```
### Visualizando os Resultados
Para visualizar os resultados, você pode simplesmente imprimir os DataFrames gerados pelo algoritmo. Cada DataFrame apresentará a configuração de um dos times, permitindo uma análise detalhada da formação e estratégia de equipe.

## Funções Principais
### generateInitialPopulation(populationSize)
Gera uma população inicial de cromossomos. Cada cromossomo é uma sequência de 21 elementos, representando a alocação de jogadores em três times.

### evaluateChromosome(chromosome, playerDataFrame, penalizedPairs)
Calcula os valores de fitness para um cromossomo. O fitness1 é baseado na diferença das médias das notas dos times, e o fitness2 leva em conta a distribuição de posições nos times. Pares de jogadores específicos no mesmo time podem resultar em penalizações.

### tournamentSelection(population, fitness1, fitness2, tournamentSize, alphaCoef, betaCoef)
Seleciona cromossomos para reprodução através de um torneio. Usa uma média ponderada de fitness1 e fitness2 para determinar os vencedores.

### crossoverPopulation(population, fitness1, fitness2, elitismPercent, alphaCoef, betaCoef)
Realiza o crossover entre cromossomos, mantendo uma porcentagem da população como elite. Utiliza o método de crossover parcialmente mapeado (PMX) para manter a unicidade dos jogadores em cada time.

### mutateChromosome(chromosome, mutationRate)
Aplica mutações aleatórias em um cromossomo. A taxa de mutação controla a frequência dessas mutações.

### createTeamDataFrames(individual, playerDataFrame)
Divide um cromossomo em três DataFrames, cada um representando um time, e ordena os jogadores por posição e nota.

### printTeamDataFrame(teamDataFrame)
Imprime um DataFrame de um time e calcula e exibe a média das notas dos jogadores desse time.

## Pipeline do Algoritmo
**Geração da População Inicial**: Usando generateInitialPopulation(). <br>
**Avaliação dos Cromossomos**: Com evaluateChromosome() para cada cromossomo na população. <br>
**Seleção para Reprodução**: Utilizando tournamentSelection(). <br>
**Crossover**: Formando novos cromossomos usando crossoverPopulation(). <br>
**Mutação**: Aplicando mutateChromosome() a cada novo cromossomo. <br>
**Repetição do Processo**: O processo retorna ao passo 2 e se repete por um número definido de gerações ou até que um critério de parada seja atingido.

## Informações Adicionais
Para atribuição das notas aos jogadores recomenda-se utilizar o app [appito](https://appito.com/) disponível para iphone e android.

## Autores
**Desenvolvedor**: Leandro H S Correa.
