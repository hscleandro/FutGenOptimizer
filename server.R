# Author: Leandro Corrêa ~@hscleandro
# Date: January 06 2024

library(shiny)
source("helpers.R")
source("ga_functions.R")
source("FutGenOptimizer.R")

#Sets the maximum size of the input file
options(shiny.maxRequestSize = 700*1024^3) 

shinyServer(function(input, output, session) {
  
  playerDataFrameIsOk <- function(df) {
    # Verifica o número de linhas
    if (nrow(df) != 21) {
      return(FALSE)
    }
    
    # Verifica as colunas
    if (!all(c("player", "position", "rating") %in% names(df))) {
      return(FALSE)
    }
    
    # Verifica se 'player' contém apenas strings
    if (!all(sapply(df$player, is.character))) {
      return(FALSE)
    }
    
    # Verifica posições e a presença de pelo menos um GOL
    posicoes_validas <- c("GOL", "ZAG", "MEI", "ATA")
    if (!all(df$position %in% posicoes_validas) || !any(df$position == "GOL")) {
      return(FALSE)
    }
    
    # Verifica se 'rating' é numérico e está no intervalo de 0 a 10
    if (!all(sapply(df$rating, is.numeric)) || any(df$rating < 0 | df$rating > 10)) {
      return(FALSE)
    }
    
    return(TRUE)
  }
  

 getBalancedTeamTable <- function(){
   
   playerListString = input$texto
   mutationRate = input$mut_tax
   n_generations = input$n_generations
   
   playerDataFrame <- tryCatch({
     createPlayerDataFrame(playerListString, option_lines = 2)
   
     playerDataFrame <- createPlayerDataFrame(playerListString, option_lines = 2)

     if (playerDataFrameIsOk(playerDataFrame)){
       show("loadingContent")
       balancedTeamTable <- FutGenOptimizer(playerDataFrame = playerDataFrame, 
                                            mutationRate = mutationRate,
                                            numGenerations = n_generations)
       hide("loadingContent")
       
       balancedTeamTable <- balancedTeamTable %>%
         arrange(match(Team, c("Azul", "Branco", "Laranja")), match(position, c("GOL", "ZAG", "MEI", "ATA")), -rating)
       
       # Renderizar a tabela
       output$final_table <- DT::renderDataTable({
         datatable(balancedTeamTable, options = list(pageLength = 7, lengthChange = FALSE, searching = FALSE))
       })
       
       media_teams <- balancedTeamTable %>%
         group_by(Team) %>%
         summarise(media = mean(rating)) %>%
         split(.$Team)
      
       output$result_teams <- renderUI({
         HTML(paste("<strong>Média do time branco:</strong>", round(media_teams$Branco$media,2), 
               "<br>", 
               "<strong>Média do time azul:</strong>", round(media_teams$Azul$media,2),
               "<br>",
               "<strong>Média do time Laranja:</strong>", round(media_teams$Laranja$media,2)
               )
         )
       })
       
       hide("background_image")
       show("msg_ok")
       hide("msg_error")
     }
     else{
       hide("background_image")
       show("msg_error")
       hide("msg_ok")
     }
   }, warning = function(w) {
     print("Ocorreu um aviso.")
   }, error = function(e) {
     hide("background_image")
     show("msg_error")
     hide("msg_ok")
   }, finally = {
     print("Processo finalizado.")
   })

 }
 
 hide("msg_error")
 hide("msg_ok")
 
  observeEvent(input$run_selection, {
      updateTabsetPanel(session, "resultsTab", "Times selecionados")
      getBalancedTeamTable()
    
  })
  
  ##########
  
  hide("loadingContent")
  show("allContent")
})
