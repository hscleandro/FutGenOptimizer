# Author: Leandro Corrêa ~@hscleandro
# Date: January 06 2024
library(dplyr)
source("ga_functions.R")

# Exemplo de uso da função
playerListString <- "1. JP (GOL) - 7,18
2. David (ZAG) - 7,38
3. Leo Ribeiro (MEI) - 7,12
4. Igor (ATA) - 5,82
5. ⁠Guilherme (MEI) - 6,62
6. Kelvin (ATA) - 5,16
7. Ricardo (ZAG) - 6,76
8. Olavo (ZAG) -  7,38
9. Otávio (GOL) - 6,06
10. Ademir (MEI) - 7,06
11. Léo Oliveira (ATA) - 8,28
12. ⁠Rafa (ATA) - 4,26
13. Rafael Tadim (MEI) - 7,28
14. Leandro C (MEI) - 7,32
15. Thiago Loiola (ATA) - 8,32
16. Thiago Teodoro (MEI) - 8,92
17. Felipe (MEI) - 7,23
18. Matheus Barbosa (ZAG) - 5,56
19. Luis Felipe (ZAG) - 6,85
20. ⁠Joao Pavani (MEI)- 6,91
21. Anon (GOL) - 5,91
"

# Parâmetros do Algoritmo Genético
tournamentSize <- 3
populationSize <- 1000
elitismPercent <- 0.2
mutationRate <- 0.2 #0.05
alphaCoef <- 0.4      # coeficiente de peso para ajuste do fitness 1
betaCoef <- 0.6       # coeficiente de peso para ajuste do fitness 2
numGenerations <- 50  # Número de gerações

penalizedPairs = list(c('Victor Braga','Thiago Braga'),c('Thiago Loiola','Kelvin'))

# Definindo a lista de jogadores
playerDataFrame <- createPlayerDataFrame(playerListString)

# vetor <- rnorm(n = 6, mean = 6.838667, sd = (1.265441)/2)
# playerDataFrame %>% summarise(media = sd(rating))
# playerDataFrame %>% group_by(position) %>%  summarise(total = n())


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




