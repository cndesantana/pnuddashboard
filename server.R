library(dplyr)

shinyServer(function(input, output, session) {

  # Provide explicit colors for regions, so they don't get recoded when the
  # different series happen to be ordered differently from year to year.
  # http://andrewgelman.com/2014/09/11/mysterious-shiny-things/
  defaultColors <- c("#3366cc", "#dc3912", "#ff9900", "#109618", "#990099")
  series <- structure(
    lapply(defaultColors, function(color) { list(color=color) }),
    names = c("Norte","Nordeste","Sudeste","Sul","Centro-Oeste")
  )

  yearData <- reactive({
    # Filter to the desired year, and put the columns
    # in the order that Google's Bubble Chart expects
    # them (name, x, y, color, size). Also sort by region
    # so that Google Charts orders and colors the regions
    # consistently.
    regions <- c("Norte","Nordeste","Sudeste","Sul","Centro-Oeste")
    df <- pnud_muni %>%
      mutate(reg = regions[pnud_muni$uf%/%10]) %>%
      filter(ano == input$year) %>%
      select(municipio, rdpc, espvida,
        reg, pop) %>%
      arrange(reg)
  })

  output$chart <- reactive({
    # Return the data and options
    list(
      data = googleDataTable(yearData()),
      options = list(
        title = sprintf(
          "Renda Domiciliar Per Capita vs. Expectativa de Vida, %s",
          input$year),
        series = series
      )
    )
  })
})


