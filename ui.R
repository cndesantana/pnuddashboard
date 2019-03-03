

# More info:
#   https://github.com/jcheng5/googleCharts
# Install:
#   devtools::install_github("jcheng5/googleCharts")
library(googleCharts)

# Use global max/min for axes so the view window stays
# constant as the user moves between years
#xlim <- list(
#  min = min(data$Health.Expenditure) - 500,
#  max = max(data$Health.Expenditure) + 500
#)
#ylim <- list(
#  min = min(data$Life.Expectancy),
#  max = max(data$Life.Expectancy) + 3
#)

xlim <- list(
  min = min(pnud_muni$rdpc) - 500,
  max = max(pnud_muni$rdpc) + 500
)
ylim <- list(
  min = 50,
  max = max(pnud_muni$espvida) + 3
)

shinyUI(fluidPage(
  # This line loads the Google Charts JS library
  googleChartsInit(),

  # Use the Google webfont "Source Sans Pro"
  tags$link(
    href=paste0("http://fonts.googleapis.com/css?",
                "family=Source+Sans+Pro:300,600,300italic"),
    rel="stylesheet", type="text/css"),
  tags$style(type="text/css",
    "body {font-family: 'Source Sans Pro'}"
  ),

  h2("Dashboard"),

  googleBubbleChart("chart",
    width="100%", height = "475px",
    # Set the default options for this chart; they can be
    # overridden in server.R on a per-update basis. See
    # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
    # for option documentation.
    options = list(
      fontName = "Source Sans Pro",
      fontSize = 13,
      # Set axis labels and ranges
      hAxis = list(
        title = "Renda Domiciliar per capita (R$)",
        viewWindow = xlim
      ),
      vAxis = list(
        title = "Expectativa de vida (anos)",
        viewWindow = ylim
      ),
      # The default padding is a little too spaced out
      chartArea = list(
        top = 50, left = 75,
        height = "75%", width = "75%"
      ),
      # Allow pan/zoom
      explorer = list(),
      # Set bubble visual props
      bubble = list(
        opacity = 0.4, stroke = "none",
        # Hide bubble label
        textStyle = list(
          color = "none"
        )
      ),
      # Set fonts
      titleTextStyle = list(
        fontSize = 16
      ),
      tooltip = list(
        textStyle = list(
          fontSize = 12
        )
      )
    )
  ),
  fluidRow(
    shiny::column(3, offset = 4,
      sliderInput("year", "Year", step=c(9,10,10),
        min = min(pnud_muni$ano), max = max(pnud_muni$ano),
        value = min(pnud_muni$ano), animate = TRUE),
      selectInput("state", "Choose a state:",multiple = TRUE,selected="Bahia",
                  sort(unique(pnud_muni$ufn))
      )
    )
  )
))


