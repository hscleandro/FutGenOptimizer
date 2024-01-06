# Author: Leandro Corrêa ~@hscleandro
# Date: January 06 2024

library(shiny)
source("helpers.R")


fluidPage(
  useShinyjs(),
  
  # add custom JS and CSS
  singleton(
    tags$head(includeScript(file.path('www', 'message-handler.js')),
              includeScript(file.path('www', 'helper-script.js')),
              includeCSS(file.path('www', 'style.css'))
    )
  ),
  
  # enclose the header in its own section to style it nicer
  div(id = "headerSection",
      titlePanel("FutGenOptimizer - Seleção de times balanceados"),
      
      # author info
      span(
        span("V1.1 beta")
      )
  ),
  
  # show a loading message initially
  div(
    id = "loadingContent",
    h2("Loading...")
  ),	
  
  # all content goes here, and is hidden initially until the page fully loads
  hidden(div(id = "allContent",
        
   sidebarLayout(
# ============================Left_panel======================================
     sidebarPanel(
      
       div(id = "div_upload",
           ),
       numericInput("mut_tax", "Taxa de aleatoriedade:", 0.05, min = 0.01, max = 0.5),
       numericInput("n_generations", "Tempo de espera (s):", 20, min = 1, max = 50),
       hr(),
       strong(span("Lista de jogadores incluindo posição + nota:")),
       div(id = "div_upload",
           
           textInput("texto", label = "", value = "")
       ),

      # withBusyIndicator(
         actionButton(
           "run_selection",
           "Run selection",
           class = "btn-primary"
      #   ),
       ),
       div(id="msg_error", "Verifique se você colocou a lista de jogadores no formato correto."),
       div(id="msg_ok", "A lista de jogadores foi carregada corretamente.")

     ),
# ============================Right_panel======================================     
     mainPanel(#wellPanel(
       tabsetPanel(
         id = "resultsTab", type = "tabs",
         # ============================README======================================
         tabPanel(
           title = "README", 
           id    = "readme",
           includeMarkdown(file.path("text", "about.md")),
           br()
         ),
         # ============================RESULTADOS======================================
         tabPanel(
           title = "Times selecionados", 
           id = "plots",
           br(),
           div(id = "allPlots",
               DT::dataTableOutput("final_table"),
               br(),
               uiOutput("result_teams")
           )
         )
       #)
     ))
# ============================End_Right_panel====================================== 
   )
  ))
)
