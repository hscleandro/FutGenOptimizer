# Author: Leandro Corrêa ~@hscleandro
# Date: January 06 2024

library(dplyr)
source("ga_functions.R")

# Parâmetros do Algoritmo Genético
TOURNAMENTSIZE <- 3
POPULATIONSIZE <- 1000
ELITISMPERCENT <- 0.2
MUTATIONRATE <- 0.2 #0.05
ALPHACOEF <- 0.4      # coeficiente de peso para ajuste do fitness 1
BETACOEF <- 0.6       # coeficiente de peso para ajuste do fitness 2
NUMGENERATIONS <- 20  # Número de gerações

PENALIZEDPAIRS = list(c('Victor Braga','Thiago Braga'),c('Thiago Loiola','Kelvin'))

FutGenOptimizer <- function(playerDataFrame,
                            tournamentSize =  TOURNAMENTSIZE,
                            populationSize = POPULATIONSIZE,
                            elitismPercent = ELITISMPERCENT,
                            mutationRate = MUTATIONRATE,
                            alphaCoef = ALPHACOEF,
                            betaCoef = BETACOEF,
                            numGenerations = NUMGENERATIONS,
                            penalizedPairs = PENALIZEDPAIRS
                            ) {
  
  # Gerando a população inicial
  population <- generateInitialPopulation(populationSize)

  # Avaliando o fitness da população
  populationFitness <- evaluatePopulation(population, playerDataFrame, penalizedPairs)

  # Simulando geracões
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

  return(tableBestIndividual)
  
}