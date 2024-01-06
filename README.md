# Projeto de Algoritmo Genético para Formação de Times
## Descrição
Este projeto implementa um algoritmo genético (AG) para otimizar a formação de times baseado em critérios específicos de performance e combinações de jogadores. O objetivo é criar times equilibrados, considerando as notas dos jogadores e certas combinações desejadas ou indesejadas.

## Acesso ao app do projeto
Para acessar o app desenvolvido em Shiny (versão beta) acesse o endereço: [hscleandro.shinyapps.io/FutGenOptimizer/](https://hscleandro.shinyapps.io/FutGenOptimizer/)

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

## Autores
**Desenvolvedor**: Leandro H S Correa.
