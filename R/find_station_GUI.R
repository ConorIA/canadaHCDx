##' @title Find a Historical Climate Data station (GUI)
##'
##' @description A function to launch a shiny web app to search for Historical Climate Data stations.
##'
##' @param stations optional `data.frame` of stations such as a search result from `find_station()`.
##'
##' @return none
##'
##' @author Conor I. Anderson
##'
##' @importFrom shiny br column em fluidPage fluidRow runApp selectInput shinyApp shinyUI titlePanel
##' @importFrom DT datatable dataTableOutput renderDataTable
##'
##' @export
##'
##' @examples
##' \dontrun{station_explorer()}

find_station_GUI <- function(stations = NULL) {

  if (is.null(stations)) {
    data <- station_data
  } else {
    data <- stations
  }

  app <- shinyApp(
    shinyUI(
      fluidPage(
        titlePanel("canadaHCD data inventory"),

        # Create a new Row in the UI for selectInputs
        fluidRow(
          column(4,
                 selectInput("prov",
                             "Province:",
                             c("All",
                               unique(as.character(data$Province))))
          )
        ),
        # Create a new row for the table.
        fluidRow(
          dataTableOutput("table")),
        fluidRow(br(em(comment(data))))
      )
    ),
    server = function(input, output) {
      output$table <- renderDataTable(datatable({
        if (input$prov != "All") {
          data <- data[data$Province == input$prov,]
        }
        data
      }))
    })
  runApp(app)
}
