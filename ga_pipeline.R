library(dplyr)
source("ga_functions.R")

# Exemplo de uso da função
playerListString <- "1. Igor (ATA) - 5,92
2. Ademir (MEI) - 6,62
3. Leo Ribeiro (MEI) - 7,04
4. David (ZAG) - 6,70
5. Thiago Loiola (ATA) - 7,24
6. Leandro C (MEI) - 5,62
7. Kelvin (ATA) - 6,90
8. Olavo (ZAG) - 6,84
9. Otávio (GOL) - 6,54
10. Blasque (ATA) - 5,62
11. Victor Braga (ZAG) - 5,58
12. Thiago Braga (ZAG) - 4,46
13. Lucas Drago (GOL) - 7,54
14. Johnatan (MEI) - 6,46
15. Nikolas (ZAG) - 5,13
16. JP (GOL) - 7,08
17. Ricardo (ZAG) - 6,76
18. Ferlini (MEI) - 6,32
19. Guilherme (MEI) - 6,5
20. Thiago Teodoro (MEI) - 8,92
21. Lucão (MEI) - 6,74"



# Parâmetros do Algoritmo Genético
tournamentSize <- 3
populationSize <- 1000
elitismPercent <- 0.2
mutationRate <- 0.1 #0.05
alphaCoef <- 0.4      # coeficiente de peso para ajuste do fitness 1
betaCoef <- 0.6       # coeficiente de peso para ajuste do fitness 2
numGenerations <- 50  # Número de gerações

penalizedPairs = list(c('Victor Braga','Thiago Braga'),c('Thiago Loiola','Kelvin'))

# Definindo a lista de jogadores
playerDataFrame <- createPlayerDataFrame(playerListString)

# Gerando a população inicial
population <- generateInitialPopulation(populationSize)

# Avaliando o fitness da população
populationFitness <- evaluatePopulation(population, playerDataFrame, penalizedPairs)

# Loop principal do Algoritmo Genético
for (generation in 1:numGenerations) {
  
  
  # Seleção por torneio
  matingpool <- tournamentSelection(population, 
                                    populationFitness$populationFitness1, 
                                    populationFitness$populationFitness2, 
                                    tournamentSize, alphaCoef, betaCoef)
  
  # Recalculando fitness para populaćão de acasalamento
  matingpoolFitness <- evaluatePopulation(matingpool, playerDataFrame, penalizedPairs)
  
  # Cruzamento com elitismo
  newPopulation <- crossoverPopulation(matingpool, 
                                       matingpoolFitness$populationFitness1, 
                                       matingpoolFitness$populationFitness2, 
                                       elitismPercent, alphaCoef, betaCoef)
  
  # Mutação
  population <- lapply(newPopulation, function(chromo) mutateChromosome(chromo, mutationRate))
  
  # Avaliando o fitness da população
  populationFitness <- evaluatePopulation(population, playerDataFrame, penalizedPairs)
  
  # Logística e estatísticas
  list_result <- getStatistics(populationFitness$populationFitness1, 
                               populationFitness$populationFitness2,
                               verbose = TRUE)
}

# Selecionando melhor indivíduo da populaćão
bestIndividual <- selectUniqueBestIndividual(population, 
                                             populationFitness$populationFitness1, 
                                             populationFitness$populationFitness2, 
                                             alphaCoef, betaCoef)


# Criando tabela para o melhor indivíduo
tableBestIndividual <- createTableForIndividual(bestIndividual, playerDataFrame)


# Printando os resultado para cada um dos times
viewingTeams(tableBestIndividual, team = "Azul")
viewingTeams(tableBestIndividual, team = "Branco")
viewingTeams(tableBestIndividual, team = "Laranja")




