# Author: Leandro Corrêa ~@hscleandro
# Date: January 06 2024

# Install
# libcurll. For linux users: sudo apt-get install libcurl4-gnutls-dev
# libxml. For linux users: sudo apt-get install libxml2-dev

if("shiny" %in% rownames(installed.packages()) == FALSE){ install.packages("shiny") }
if("dplyr" %in% rownames(installed.packages()) == FALSE){ install.packages("dplyr") }
if("DT" %in% rownames(installed.packages()) == FALSE){ install.packages("DT") }
if("shinyjs" %in% rownames(installed.packages()) == FALSE){ install.packages("shinyjs") }
if("rmarkdown" %in% rownames(installed.packages()) == FALSE){ install.packages("rmarkdown") }
if("markdown" %in% rownames(installed.packages()) == FALSE){ install.packages("markdown") }

library(dplyr)
library(DT)
library(shinyjs)
library(rmarkdown)
library(markdown)

# Function that controls the color and position of the button "run analisys"
# withBusyIndicator <- function(button, exp) {
#   id <- button[['attribs']][['id']]
#   tagList(
#     button,
#     span(
#       class = "btn-loading-container",
#       `data-for-btn` = id,
#       hidden(
#         img(src = paste(getwd(),"/www/ajax-loader-bar.gif"), class = "btn-loading-indicator"),
#         icon("check", class = "btn-done-indicator")
#       )
#     )
#   )
# }
# 
# withBusyIndicatorUI <- function(button) {
#   id <- button[['attribs']][['id']]
#   div(
#     `data-for-btn` = id,
#     button,
#     span(
#       class = "btn-loading-container",
#       hidden(
#         img(id = "loading", src = "ajax-loader-bar.gif", class = "btn-loading-indicator"),
#         icon("check", class = "btn-done-indicator")
#       )
#     ),
#     hidden(
#       div(class = "btn-err",
#           div(icon("exclamation-circle"),
#               tags$b("Error: "),
#               span(class = "btn-err-msg")
#           )
#       )
#     )
#   )
# }
# 
# # Call this function from the server with the button id that is clicked and the
# # expression to run when the button is clicked
# withBusyIndicatorServer <- function(buttonId, expr) {
#   # UX stuff: show the "busy" message, hide the other messages, disable the button
#   loadingEl <- sprintf("[data-for-btn=%s] .btn-loading-indicator", buttonId)
#   doneEl <- sprintf("[data-for-btn=%s] .btn-done-indicator", buttonId)
#   errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
#   shinyjs::disable(buttonId)
#   shinyjs::show(selector = loadingEl)
#   shinyjs::hide(selector = doneEl)
#   shinyjs::hide(selector = errEl)
#   on.exit({
#     shinyjs::enable(buttonId)
#     shinyjs::hide(selector = loadingEl)
#   })
#   
#   # Try to run the code when the button is clicked and show an error message if
#   # an error occurs or a success message if it completes
#   tryCatch({
#     value <- expr
#     shinyjs::show(selector = doneEl)
#     shinyjs::delay(2000, shinyjs::hide(selector = doneEl, anim = TRUE, animType = "fade",
#                                        time = 0.5))
#     value
#   }, error = function(err) { errorFunc(err, buttonId) })
# }
# 
# # When an error happens after a button click, show the error
# errorFunc <- function(err, buttonId) {
#   errEl <- sprintf("[data-for-btn=%s] .btn-err", buttonId)
#   errElMsg <- sprintf("[data-for-btn=%s] .btn-err-msg", buttonId)
#   errMessage <- gsub("^ddpcr: (.*)", "\\1", err$message)
#   shinyjs::html(html = errMessage, selector = errElMsg)
#   shinyjs::show(selector = errEl, anim = TRUE, animType = "fade")
# }

