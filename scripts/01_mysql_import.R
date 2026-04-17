# =========================
# Pacotes
# =========================
library(shiny)
library(dplyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(scales)
library(hms)
library(DBI)
library(RMySQL)

# ============================
# Conexão
# ============================
con <- dbConnect(
  MySQL(),
  user = "root",
  password = "root",
  dbname = "scadabr",
  host = "localhost",
  port = 3306
)

# =========================
# UI
# =========================
ui <- fluidPage(
  
  titlePanel("Dashboard de Monitoramento por Perfil de Carga"),
  
  sidebarLayout(
    
    sidebarPanel(
      width = 3,
      
      dateRangeInput(
        "periodo",
        "Período:",
        start = "2019-08-14",
        end   = "2023-04-03",
        language = "pt-BR",
        separator = " até "
      ),
      
      selectInput(
        "medidor",
        "Medidor:",
        choices = NULL
      )
    ),
    
    mainPanel(
      width = 9,
      
      tabsetPanel(
        
        tabPanel("Série Temporal",
                 plotlyOutput("grafico_tempo", height = "500px")),
        
        tabPanel("Perfil de Carga",
                 plotlyOutput("grafico_perfil", height = "500px"))
      )
    )
  )
)

# =========================
# SERVER
# =========================
server <- function(input, output, session) {
  
  observe({
    med <- dbGetQuery(con, "SELECT DISTINCT dataPointId FROM pointvalues")
    
    updateSelectInput(
      session,
      "medidor",
      choices = med$dataPointId,
      selected = med$dataPointId[1]
    )
  })
  
  dados <- reactive({
    
    req(input$periodo, input$medidor)
    
    query <- paste0("
      SELECT 
        ts,
        dataPointId,
        pointValue
      FROM pointvalues
      WHERE ts BETWEEN 
        UNIX_TIMESTAMP('", input$periodo[1], "') * 1000
        AND UNIX_TIMESTAMP('", input$periodo[2], "') * 1000
        AND dataPointId = ", input$medidor, "
      ORDER BY ts
    ")
    
    dbGetQuery(con, query)
  })
  
  dados_tratados <- reactive({
    
    df <- dados()
    
    if (nrow(df) == 0) return(NULL)
    
    df %>%
      mutate(
        DateTime = as.POSIXct(ts / 1000, origin = "1970-01-01", tz = "America/Sao_Paulo")
      ) %>%
      
      arrange(DateTime) %>%
      group_by(dataPointId) %>%
      mutate(
        pointValue = (pointValue - lag(pointValue)) * 4,
        pointValue = ifelse(pointValue < 0 | pointValue > 500000, NA, pointValue)
      ) %>%
      ungroup() %>%
      
      mutate(
        DateTime = floor_date(DateTime, "15 min")
      ) %>%
      group_by(DateTime) %>%
      
      summarise(
        pointValue = ifelse(
          all(is.na(pointValue)),
          NA,
          mean(pointValue, na.rm = TRUE)
        ),
        .groups = "drop"
      ) %>%
      
      mutate(
        Dia_semana = wday(DateTime, label = TRUE, abbr = FALSE),
        Data = as.Date(DateTime),
        Hora = as_hms(DateTime)
      ) %>%
      filter(!is.na(pointValue), pointValue > 0)
  })
  
  # =========================
  # Gráfico 1 - Temporal
  # =========================
  output$grafico_tempo <- renderPlotly({
    
    df <- dados_tratados()
    
    validate(
      need(!is.null(df) && nrow(df) > 0, "Sem dados para esse período.")
    )
    
    p <- ggplot(df, aes(x = DateTime, y = pointValue)) +
      
      geom_step(color = "blue") +
      
      labs(
        title = paste("Série Temporal - Medidor", input$medidor),
        x = "Data",
        y = "Potência (kW)"
      ) +
      
      theme_minimal()
    
    ggplotly(p) %>% layout(hovermode = "x unified")
  })
  
  # =========================
  # Gráfico 2 - Perfil
  # =========================
  output$grafico_perfil <- renderPlotly({
    
    df <- dados_tratados()
    
    validate(
      need(!is.null(df) && nrow(df) > 0, "Sem dados para esse período.")
    )
    
    p <- ggplot(df, aes(x = Hora, y = pointValue)) +
      
      geom_step(
        aes(group = Data, text = paste("Data:", Data)),
        color = "blue",
        alpha = 0.2,
        size = 0.3
      ) +
      
      stat_summary(
        aes(color = Dia_semana, group = Dia_semana),
        fun = mean,
        geom = "step",
        size = 0.7
      ) +
      
      scale_x_time(
        breaks = hms::hms(hours = seq(0, 24, by = 2)),
        labels = scales::label_time(format = "%H:%M")
      ) +
      
      labs(
        title = paste("Perfil de Carga - Medidor", input$medidor),
        x = "Hora do Dia",
        y = "Potência (kW)",
        color = "Dia da Semana"
      ) +
      
      theme_minimal() +
      theme(
        legend.position = "bottom",
        panel.grid.minor = element_blank()
      )
    
    ggplotly(p, tooltip = c("text", "x", "y", "color")) %>%
      layout(
        legend = list(
          orientation = "h",
          x = 0.5,
          xanchor = "center",
          y = -0.2
        )
      )
  })
}

# =========================
# Executar App
# =========================
shinyApp(ui, server) 
