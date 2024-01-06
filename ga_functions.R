# Author: Leandro Corrêa ~@hscleandro
# Date: January 06 2024

createPlayerDataFrame <- function(playerListString, option_lines = 1) {
  # Dividindo a string em linhas
  if(option_lines == 1){  
    lines <- unlist(strsplit(playerListString, "\n")) 
  } else{
    lines <- unlist(strsplit(playerListString, "(?<=\\d,\\d{2}) (?=\\d+\\.)", perl = TRUE))
  }
  
  # Função auxiliar para processar cada linha e extrair os dados do jogador
  processLine <- function(line) {
    # Extrai o nome, posição e nota do jogador
    parts <- strsplit(line, "\\s+\\(|\\)\\s+-\\s+|\\)\\s*-\\s+")
    player <- parts[[1]][1]
    player <- strsplit(player, '[.] ')[[1]][2]
    position <- parts[[1]][2]
    ratingString <- gsub(",", ".", parts[[1]][3])  # Substitui vírgulas por pontos
    rating <- as.numeric(ratingString)  # Converte para numérico
    
    # Retorna uma lista com os dados do jogador
    return(list(player = player, position = position, rating = rating))
  }
  
  # Aplicando a função a cada linha e criando uma lista de jogadores
  playerData <- lapply(lines, processLine)
  
  # Convertendo a lista em um dataframe
  playerDataFrame <- do.call(rbind, lapply(playerData, data.frame, stringsAsFactors = FALSE))
  return(playerDataFrame)
}


generateChromosome <- function() {
  # Criando um vetor de 1 a 21
  players <- 1:21
  
  # Embaralhando o vetor para criar uma ordem aleatória
  shuffledPlayers <- sample(players)
  
  # Retornando o vetor embaralhado
  return(shuffledPlayers)
}


generateInitialPopulation <- function(populationSize) {
  population <- vector("list", populationSize)
  for (i in 1:populationSize) {
    # Gerando um cromossomo válido
    chromosome <- generateChromosome()
    population[[i]] <- chromosome
  }
  return(population)
}


evaluateChromosome <- function(chromosome, playerData, penalizedPairs = NULL, verbose = FALSE) {
  # Dividindo o cromossomo em três times
  teams <- split(chromosome, ceiling(seq_along(chromosome) / 7))
  
  # Calculando a média das notas dos times (Fitness 1)
  teamRatings <- sapply(teams, function(team) mean(playerData$rating[team]))
  fitness1 <- max(teamRatings) - min(teamRatings)
  
  # Calculando a diferença entre a maior e a menor média
  diffRating <- max(teamRatings) - min(teamRatings)
  
  # Fitness 1: Invertendo a métrica (maior é melhor)
  fitness1 <- 1 / diffRating  # ou uma constante grande menos diffRating, se diffRating nunca for zero
  
  # Aplicando penalizações para pares de jogadores que não podem estar no mesmo time
  if (length(penalizedPairs) > 0 ){
    for (pair in penalizedPairs) {
      playerIndices <- match(pair, playerDataFrame$player)
      if (any(sapply(teams, function(team) all(playerIndices %in% team)))) {
        fitness1 <- fitness1 * 0.1  # Penalização de 90%
      }
    }
  }
  
  # Função para mapear índices de jogadores para posições
  getPlayerPositions <- function(team) {
    sapply(team, function(playerIndex) {
      playerDataFrame$position[playerIndex]
    })
  }
  
  # Função auxiliar para calcular a nota de distribuição de posições
  calculatePositionRating <- function(team) {
    teamPositions <- getPlayerPositions(team)
    positions <- table(teamPositions)
    expectedPositions <- c("GOL", "ZAG", "MEI", "ATA")
    
    # Garantindo que todas as posições esperadas estejam na tabela
    positions <- c(positions, setNames(rep(0, length(expectedPositions)), expectedPositions))
    positions <- positions[names(positions) %in% expectedPositions]
    
    # Verificando as condições
    if (positions["GOL"] == 1 && all(positions[c("ZAG", "MEI", "ATA")] == c(2, 2, 2))) {
      return(5)
    } else if (positions["GOL"] == 1 && 
               positions["ZAG"] >= 1 && positions["ZAG"] <= 3 &&
               positions["MEI"] >= 1 && positions["MEI"] <= 3 &&
               positions["ATA"] >= 1 && positions["ATA"] <= 3) {
      return(4)
    } else if (positions["GOL"] == 1 && all(positions[c("ZAG", "MEI", "ATA")] <= 3)) {
      return(3)
    } else if (positions["GOL"] == 1) {
      return(2)
    } else {
      return(0)
    }
  }
  
  # Calculando a nota de distribuição de posições para cada time (Fitness 2)
  positionRatings <- sapply(teams, calculatePositionRating)
  
  # printando resultado do fitness com base nas posićões
  if (verbose) {print(positionRatings)}
  
  fitness2 <- mean(positionRatings)
  
  # Retornando os dois valores de fitness
  return(list(fitness1 = fitness1, fitness2 = fitness2))
}


evaluatePopulation <- function(population, playerDataFrame, penalizedPairs = NULL){
  
  # Population é a população de cromossomos e playerDataFrame contém os dados dos jogadores
  populationFitness1 <- vector("numeric", length(population))
  populationFitness2 <- vector("numeric", length(population))
  
  # Calculando fitness para cada cromossomo na população
  for (i in seq_along(population)) {
    fitnessValues <- evaluateChromosome(population[[i]], playerDataFrame, penalizedPairs)
    populationFitness1[i] <- fitnessValues$fitness1
    populationFitness2[i] <- fitnessValues$fitness2
  }
  
  # Normalizando Fitness 1
  maxFitness1 <- max(populationFitness1)
  normalizedFitness1 <- populationFitness1 / maxFitness1
  
  # Normalizando Fitness 2
  maxFitness2 <- max(populationFitness2)
  normalizedFitness2 <- populationFitness2 / maxFitness2
  
  # Retornando os dois valores de fitness
  return(list(populationFitness1 = normalizedFitness1, populationFitness2 = normalizedFitness2))
  
}


tournamentSelection <- function(population, fitness1, fitness2, tournamentSize, alpha = 0.4, beta = 0.6) {
  selected <- vector("list", length = length(population))
  
  # Função para calcular o score combinado de fitness com ponderação
  getCombinedFitness <- function(index) {
    (alpha * fitness1[index] + beta * fitness2[index]) / (alpha + beta)
  }
  
  for (i in 1:length(population)) {
    # Selecionando índices aleatórios para o torneio
    candidates <- sample(length(population), tournamentSize)
    
    # Escolhendo o melhor candidato com base no fitness ponderado
    bestCandidate <- candidates[which.max(sapply(candidates, getCombinedFitness))]
    
    # Adicionando o melhor candidato ao conjunto selecionado
    selected[[i]] <- population[[bestCandidate]]
  }
  
  return(selected)
}


pmxCrossover <- function(parent1, parent2) {
  lengthChromosome <- length(parent1)
  cutPoint1 <- sample(1:(lengthChromosome - 1), 1)
  cutPoint2 <- sample((cutPoint1 + 1):lengthChromosome, 1)
  
  # Inicializando filhos com valores nulos
  child1 <- rep(NA, lengthChromosome)
  child2 <- rep(NA, lengthChromosome)
  
  # Copiando a seção intermediária dos pais para os filhos
  child1[cutPoint1:cutPoint2] <- parent1[cutPoint1:cutPoint2]
  child2[cutPoint1:cutPoint2] <- parent2[cutPoint1:cutPoint2]
  
  # Mapeando o restante dos elementos
  for (i in 1:lengthChromosome) {
    if (i < cutPoint1 || i > cutPoint2) {
      if (!(parent2[i] %in% child1)) {
        child1[i] <- parent2[i]
      }
      if (!(parent1[i] %in% child2)) {
        child2[i] <- parent1[i]
      }
    }
  }
  
  # Preenchendo os elementos que ainda estão faltando
  for (i in 1:lengthChromosome) {
    if (is.na(child1[i])) {
      child1[i] <- setdiff(parent2, child1)[1]
    }
    if (is.na(child2[i])) {
      child2[i] <- setdiff(parent1, child2)[1]
    }
  }
  
  return(list(child1 = child1, child2 = child2))
}


crossoverPopulation <- function(population, fitness1, fitness2, elitismPercent, alpha, beta) {
  populationSize <- length(population)
  combinedFitness <- sapply(1:populationSize, function(i) {
    (alpha * fitness1[i] + beta * fitness2[i]) / (alpha + beta)
  })
  
  # Ordenando os cromossomos com base no fitness combinado
  orderedIndices <- order(combinedFitness, decreasing = TRUE)
  numElites <- ceiling(elitismPercent * populationSize)
  
  # Selecionando os elites
  elites <- population[orderedIndices[1:numElites]]
  newPopulation <- elites
  
  # Preenchendo o restante da população com crossover
  while(length(newPopulation) < populationSize) {
    parents <- sample(population, 2)
    cutPoint <- sample(2:(length(parents[[1]]) - 1), 1)
    
    children <- pmxCrossover(parents[[1]], parents[[2]])
    
    newPopulation <- c(newPopulation, list(children$child1))
    if (length(newPopulation) < populationSize) {
      newPopulation <- c(newPopulation, list(children$child2))
    }
  }
  
  return(newPopulation)
}


mutateChromosome <- function(chromosome, mutationRate) {
  mutatedChromosome <- chromosome
  for (i in 1:length(chromosome)) {
    if (runif(1) < mutationRate) {
      # Escolhendo outro ponto aleatório para troca
      swapIndex <- sample(length(chromosome), 1)
      
      # Trocando os elementos
      temp <- mutatedChromosome[i]
      mutatedChromosome[i] <- mutatedChromosome[swapIndex]
      mutatedChromosome[swapIndex] <- temp
    }
  }
  return(mutatedChromosome)
}


getStatistics <- function(populationFitness1, populationFitness2, verbose = FALSE){
  
  meanFitness1 <- mean(populationFitness1)
  meanFitness2 <- mean(populationFitness2)
  sdFitness1 <- sd(populationFitness1)
  sdFitness2 <- sd(populationFitness2)
  varFitness1 <- var(populationFitness1)
  varFitness2 <- var(populationFitness2)
  maxFitness1 <- max(populationFitness1)
  maxFitness2 <- max(populationFitness2)
  minFitness1 <- min(populationFitness1)
  minFitness2 <- min(populationFitness2)
  
  if(verbose){
    cat("Geração", generation, "completada\n")
    cat("Fitness 1 - Média:", meanFitness1, "Variação:", varFitness1, "DP:", sdFitness1, "Máx:", maxFitness1, "Mín:", minFitness1, "\n")
    cat("Fitness 2 - Média:", meanFitness2, "Variação:", varFitness2, "DP:", sdFitness2, "Máx:", maxFitness2, "Mín:", minFitness2, "\n")
    cat("\n")
  }
  
  return(list(meanFitness1 = meanFitness1, meanFitness2 = meanFitness2, sdFitness1 = sdFitness1, sdFitness2 = sdFitness2,
              varFitness1 = varFitness1, varFitness2 = varFitness2, maxFitness1 = maxFitness1, maxFitness2 = maxFitness2,
              minFitness1 = minFitness1, minFitness2 = minFitness2))
}


selectUniqueBestIndividual <- function(population, fitness1, fitness2, alphaCoef, betaCoef) {
  # Calcula o fitness combinado
  combinedFitness <- (alphaCoef * fitness1 + betaCoef * fitness2) / (alphaCoef + betaCoef)
  
  # Ordena os indivíduos pelo fitness combinado
  orderedIndices <- order(combinedFitness, decreasing = TRUE)
  
  bestIndividual <- population[[orderedIndices[1]]]
  
  
  return(bestIndividual)
}


createTableForIndividual <- function(individual, playerDataFrame) {
  playerInfo <- playerDataFrame[individual, ]
  team <- rep(NA, length(individual))
  team[1:7] <- "Azul"
  team[8:14] <- "Branco"
  team[15:21] <- "Laranja"
  cbind(playerInfo, Team = team)
}


viewingTeams <- function(tableBestIndividual, team = "Azul"){
  teamColor <- tableBestIndividual %>%
    filter(Team == team) %>%
    arrange(match(position, c("GOL", "ZAG", "MEI", "ATA")), -rating)
  
  mediaTimeAzul <- mean(teamColor$rating)
  print(teamColor)
  cat("\n")
  cat("A média do time", team,"é:", round(mediaTimeAzul, 2), "\n")
}



