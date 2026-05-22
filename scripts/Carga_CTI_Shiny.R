# =========================================================
# DASHBOARD DE MONITORAMENTO ENERGÉTICO - SCADABR CTI
# =========================================================

# =========================================================
# PACOTES
# =========================================================
library(shiny)
library(shinythemes)
library(dplyr)
library(tidyr)
library(lubridate)
library(hms)
library(ggplot2)
library(plotly)
library(DBI)
library(RMySQL)
library(DT)

# =========================================================
# MAPEAMENTO DOS MEDIDORES
# =========================================================
medidores_map <- c(
  M_2 = "QAC1", 
  M_3 = "QAC2",
  M_4 = "QAC3",
  M_5 = "NT3D",
  M_6 = "THERMOTRON",
  M_7 = "UTA1",
  M_8 = "UTA2",
  # Início do bloco de medidores da SCHNEIDER
  M_9  = "BANCO DE CAPACITOR", 
  M_10 = "BW1-P2",
  M_11 = "CHILLER 1", 
  M_12 = "QDFP4-NORMAL", 
  M_13 = "QGN-1237-TU",
  M_14 = "TR5-CM", 
  M_15 = "DISJ. GERAL TRAFO 1",
  M_16 = "DISJ. GERAL TRAFO 2", 
  M_17 = "QDLF-ALMOXARIFADO",
  M_18 = "NO BREAK 4", 
  M_19 = "QDE1-TU", 
  M_20 = "GERADOR 1",
  M_21 = "QDFP3-TU", 
  M_22 = "QDFP2-TU",
  M_23 = "QDF1-TU", 
  M_24 = "QDG-NO BREAK PRINCIPAL",
  M_26 = "QDFP1-TU", 
  M_27 = "GERADOR 2", 
  M_28 = "QDE2-TU",
  M_29 = "GERADOR 3", 
  M_30 = "CHILLER 3 -QUADRO BOMBAS",
  M_31 = "QTLE-CM", 
  M_32 = "QDFP4-EMERGÊNCIA",
  M_33 = "POÇO 2", 
  M_34 = "COMPRESSORES", 
  M_35 = "QGL-CM",
  M_36 = "DEPOSITO QUIMICO", 
  M_37 = "POÇO 1",
  M_39 = "CHILLER 2", 
  M_42 = "SCHNEIDER_42",
  M_43 = "SCHNEIDER_43",
  # Fim do bloco da SCHNEIDER
  M_76 = "ACS_76",
  M_78 = "ACS_78",
  M_79 = "SCHNEIDER_79",
  M_80 = "SCHNEIDER_80",
  M_81 = "ACS_81",
  M_82 = "ACS_82",
  M_83 = "ACS_83",
  M_84 = "ACS_84",
  M_85 = "ACS_85",
  M_86 = "ACS_86",
  M_87 = "ACS_87",
  M_88 = "ACS_88",
  M_91 = "ACS_91",
  M_92 = "ACS_92",
  M_93 = "ACS_93",
  M_94 = "ACS_94",
  M_95 = "ACS_95",
  M_96 = "ACS_96",
  M_97 = "ACS_97",
  M_98 = "ACS_98",
  M_99 = "ACS_99",
  M_100 = "ACS_100",
  M_110 = "ACS*_110",
  M_111 = "ACS*_111",
  M_112 = "ACS*_112",
  M_113 = "ACS*_113",
  M_114 = "JE07_114",
  M_115 = "JE07_115",
  M_116 = "JE07_116",
  M_117 = "JE07_117",
  M_118 = "JE07_118",
  M_119 = "JE07_119",
  M_121 = "SCHNEIDER_121",
  M_122 = "SCHNEIDER_122",
  M_127 = "JE07_127",
  M_128 = "SCHNEIDER_128",
  M_129 = "JE07_129",
  M_130 = "JE07_130",
  M_131 = "JE07_131",
  M_132 = "JE07_132",
  M_133 = "Arduino_133",
  M_134 = "Arduino_134",
  M_135 = "Arduino_135",
  M_136 = "Arduino_136",
  M_140 = "JE07_140",
  M_163 = "ACS_163",
  M_164 = "ACS_164",
  M_165 = "ACS_165",
  M_166 = "ACS_166",
  M_167 = "ACS_167",
  M_193 = "ACS_193",
  M_194 = "ACS_194",
  M_195 = "ACS*_195",
  M_197 = "ACS_197",
  M_200 = "ACS_200",
  M_201 = "ACS_201",
  M_202 = "Integradores_202",
  M_203 = "Integradores_203",
  M_204 = "Integradores_204",
  M_205 = "Integradores_205",
  M_206 = "Integradores_206",
  M_207 = "Integradores_207",
  M_208 = "Integradores_208",
  M_227 = "SCHNEIDER_227",
  M_233 = "Integradores_233",
  M_234 = "SCHNEIDER_234",
  M_236 = "UTA1_236",
  M_237 = "Conjunto CAG",
  M_238 = "SCHNEIDER_238",
  M_239 = "SCHNEIDER_239",
  M_240 = "SCHNEIDER_240",
  M_241 = "SCHNEIDER_241",
  M_242 = "SCHNEIDER_242",
  M_243 = "Consumo2",
  M_245 = "QAC1_245",
  M_246 = "QAC2_246",
  M_247 = "QAC3_247",
  M_248 = "UTA2_248",
  M_249 = "ConsumoCTI_249",
  M_250 = "SCHNEIDER_250",
  M_251 = "SCHNEIDER_251",
  M_252 = "SCHNEIDER_252",
  M_253 = "Consumo2_253",
  M_254 = "Consumo2_254",
  M_255 = "Consumo2_255",
  M_256 = "PMT-02",
  M_257 = "QAC3_257",
  M_259 = "PMT-02_259",
  M_260 = "PMT-02_260",
  M_261 = "THERMOTRON_261",
  M_262 = "THERMOTRON_262",
  M_263 = "THERMOTRON_263",
  M_264 = "THERMOTRON_264",
  M_265 = "THERMOTRON_265",
  M_266 = "THERMOTRON_266",
  M_267 = "SCHNEIDER_267",
  M_268 = "Gerador3_268",
  M_269 = "SCHNEIDER_269",
  M_284 = "Nitrogênio_284",
  M_295 = "Nitrogênio_295",
  M_296 = "Nitrogênio_296",
  M_297 = "Nitrogênio_297",
  M_298 = "Nitrogênio_298",
  M_299 = "Nitrogênio_299",
  M_300 = "Nitrogênio_300",
  M_301 = "Nitrogênio_301",
  M_302 = "Nitrogênio_302",
  M_303 = "Nitrogênio_303",
  M_316 = "Nitrogênio_316",
  M_317 = "Nitrogênio_317",
  M_318 = "Nitrogênio_318"
)

# =========================================================
# UI
# =========================================================
ui <- fluidPage(
  
  theme = shinytheme("flatly"),
  
  # =========================================================
  # CSS CUSTOMIZADO
  # =========================================================
  tags$head(
    
    tags$style(HTML("
    
      /* =====================================================
         SELECTIZE
      ===================================================== */
      
      .selectize-input {
        min-height: 30px !important;
        padding: 4px 8px !important;
        font-size: 14px !important;
        background: white !important;
      }
      
      .selectize-control.single .selectize-input {
        background: white !important;
      }
      
      .selectize-dropdown {
        background: white !important;
        opacity: 1 !important;
        z-index: 9999 !important;
        border: 1px solid #ccc !important;
      }
      
      .selectize-dropdown-content {
        background: white !important;
      }
      
      .selectize-dropdown .active {
        background-color: #2c7be5 !important;
        color: white !important;
      }
      
      .selectize-input.items.full.has-options.has-items {
        min-height: 30px !important;
      }
      
      /* =====================================================
         INPUTS
      ===================================================== */
      
      .form-control {
        height: 30px !important;
        font-size: 14px !important;
      }
      
      /* =====================================================
         SIDEBAR
      ===================================================== */
      
      .well {
        margin-bottom: 0px;
      }
      
      /* =====================================================
         CARDS
      ===================================================== */
      
      .card-indicador {
        padding: 4px 8px;
        min-height: 45px;
        border-radius: 6px;
        background-color: #f8f9fa;
        border: 1px solid #dee2e6;
        margin-bottom: 5px;
      }
      
      .valor-indicador {
        font-size: 15px;
        font-weight: 600;
        line-height: 0.8;
        display: inline-block;
      }
      
      .label-indicador {
        color: gray;
        font-size: 12px !important;
        display: inline-block;
        margin-left: 4px;
      }
      
      /* =====================================================
         DATATABLE
      ===================================================== */
      
      table.dataTable {
        font-size: 11px !important;
      }
      
      table.dataTable tbody td {
        padding: 8px 10px !important;
      }
      
      table.dataTable thead th {
        padding: 8px 6px !important;
        font-size: 12px !important;
      }
      
      .dataTables_filter,
      .dataTables_length,
      .dataTables_info,
      .dataTables_paginate {
        font-size: 11px !important;
      }
      
      /* =====================================================
         TABS
      ===================================================== */
      
      .nav-tabs {
        font-size: 14px;
      }
      
    "))
  ),
  
  # =========================================================
  # TÍTULO
  # =========================================================
  titlePanel(
    "Dashboard de Monitoramento Energético - ScadaBR CTI"
  ),
  
  # =========================================================
  # LAYOUT
  # =========================================================
  sidebarLayout(
    
    # =========================================================
    # SIDEBAR
    # =========================================================
    sidebarPanel(
      width = 3,
      
      # =========================================================
      # PERÍODO
      # =========================================================
      dateRangeInput(
        inputId = "periodo",
        label = "1. Período:",
        language = "pt-BR",
        separator = " até "
      ),
      
      # =========================================================
      # MEDIDOR
      # =========================================================
      selectizeInput(
        inputId = "medidor",
        label = "2. Medidor:",
        choices = NULL,
        multiple = FALSE
      ),
      
      hr(),
      
      # =========================================================
      # TEXTO
      # =========================================================
      div(
        style = "
          text-align: justify;
          font-size: 12px;
          color: #666;
        ",
        
        "
        O gráfico de Série Temporal apresenta a evolução
        contínua da potência elétrica.
        
        O Perfil de Carga permite comparar o comportamento
        médio dos dias da semana.
        "
      ),
      
      br(),
      
      # =========================================================
      # DOWNLOAD
      # =========================================================
      downloadButton(
        "downloadData",
        "Baixar CSV",
        class = "btn-success btn-sm"
      )
    ),
    
    # =========================================================
    # MAIN PANEL
    # =========================================================
    mainPanel(
      width = 9,
      
      # =========================================================
      # INDICADORES
      # =========================================================
      fluidRow(
        
        column(
          3,
          
          div(
            class = "card-indicador",
            
            h5("Potência Média"),
            htmlOutput("media_kw")
          )
        ),
        
        column(
          3,
          
          div(
            class = "card-indicador",
            
            h5("Potência Máxima"),
            htmlOutput("max_kw")
          )
        ),
        
        column(
          3,
          
          div(
            class = "card-indicador",
            
            h5("Energia Acumulada"),
            htmlOutput("energia")
          )
        ),
        
        column(
          3,
          
          div(
            class = "card-indicador",
            
            h5("Registros"),
            htmlOutput("n_registros")
          )
        )
      ),
      
      br(),
      
      # =========================================================
      # ABAS
      # =========================================================
      tabsetPanel(
        
        # =========================================================
        # Imagem do Diagrama
        # =========================================================
        tabPanel(
          "Diagrama de Blocos",
          
          br(),
          
          tags$div(
            style = "text-align:center;",
            
            img(
              src = "diagrama.jpeg",
              width = "90%",
              style = "
          border-radius: 10px;
          box-shadow: 0 2px 10px rgba(0,0,0,0.2);
        "
            )
          )
        ),
        
        # =========================================================
        # SÉRIE TEMPORAL
        # =========================================================
        tabPanel(
          "Série Temporal",
          
          br(),
          
          plotlyOutput(
            "grafico_tempo",
            height = "450px"
          )
        ),
        
        # =========================================================
        # PERFIL DE CARGA
        # =========================================================
        tabPanel(
          "Perfil de Carga",
          
          br(),
          
          plotlyOutput(
            "grafico_perfil",
            height = "450px"
          )
        ),
        
        # =========================================================
        # TABELA
        # =========================================================
        tabPanel(
          "Base de dados",
          
          br(),
          
          DTOutput("tabela_dados")
        )
      )
    )
  )
)

# =========================================================
# SERVER
# =========================================================
server <- function(input, output, session) {
  
  # =========================================================
  # CONEXÃO
  # =========================================================
  con <- reactiveVal(NULL)
  
  observe({
    
    conexao <- dbConnect(
      MySQL(),
      user = "root",
      password = "root",
      dbname = "scadabr",
      host = "localhost",
      port = 3306
    )
    
    con(conexao)
  })
  
  # =========================================================
  # ENCERRAR CONEXÃO
  # =========================================================
  session$onSessionEnded(function() {
    
    if (!is.null(con())) {
      dbDisconnect(con())
    }
  })
  
  # =========================================================
  # INICIALIZAÇÃO
  # =========================================================
  observe({
    
    req(con())
    
    # =========================================================
    # RANGE DATAS
    # =========================================================
    range_ts <- dbGetQuery(
      con(),
      
      "
      SELECT
        MIN(ts) AS min_ts,
        MAX(ts) AS max_ts
      FROM pointvalues
      "
    )
    
    date_min <- as.Date(
      as.POSIXct(
        range_ts$min_ts / 1000,
        origin = '1970-01-01'
      )
    )
    
    date_max <- as.Date(
      as.POSIXct(
        range_ts$max_ts / 1000,
        origin = '1970-01-01'
      )
    )
    
    updateDateRangeInput(
      session,
      "periodo",
      start = date_min,
      end = date_max,
      min = date_min,
      max = date_max
    )
    
    # =========================================================
    # MEDIDORES DESATIVADOS
    # =========================================================
    medidores_ocultos <- c(
    42, 43, 76, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 91,
    92, 93, 94, 95, 96, 97, 98, 99, 100, 110, 111, 112,113,114,
    115, 116, 117, 118, 119, 121, 122, 127, 128, 129, 130, 131,
    132, 140, 163, 164, 165, 166, 167, 193, 194, 195, 197, 200,
    201, 227, 234, 236, 237, 238, 239, 240, 241, 242, 243, 245,
    246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 257, 259,
    260, 261, 262, 263, 264, 265, 266, 267, 269, 284, 295, 296,
    297, 298, 299, 300, 301, 302, 303, 316, 317, 318
    )
    
    # =========================================================
    # BUSCA DE MEDIDORES
    # =========================================================
    med_ids <- dbGetQuery(
      con(),
      "SELECT DISTINCT dataPointId FROM pointvalues"
    )$dataPointId
    
    # =========================================================
    # REMOVE MEDIDORES OCULTOS
    # =========================================================
    med_ids <- med_ids[!med_ids %in% medidores_ocultos]
    
    # =========================================================
    # MEDIDORES
    # =========================================================
    
    choices_list <- setNames(
      as.list(med_ids),
      
      ifelse(
        paste0("M_", med_ids) %in% names(medidores_map),
        
        medidores_map[paste0("M_", med_ids)],
        
        paste("Medidor", med_ids)
      )
    )
    
    updateSelectizeInput(
      session,
      "medidor",
      choices = choices_list
    )
    
  })
  
  # =========================================================
  # MEDIDORES QUE JÁ SÃO POTÊNCIA
  # =========================================================
  medidores_potencia <- c(
    256
  )
  
  # =========================================================
  # DADOS TRATADOS
  # =========================================================
  dados_tratados <- reactive({
    
    req(
      input$periodo,
      input$medidor,
      con()
    )
    
    # =========================================================
    # QUERY SQL
    # =========================================================
    query <- sprintf(
      "
      SELECT
        ts,
        pointValue
        
      FROM pointvalues
      
      WHERE dataPointId = %s
      
      AND ts BETWEEN
        UNIX_TIMESTAMP('%s') * 1000
        
      AND
        
        UNIX_TIMESTAMP('%s 23:59:59') * 1000
        
      ORDER BY ts
      ",
      
      input$medidor,
      input$periodo[1],
      input$periodo[2]
    )
    
    df <- dbGetQuery(con(), query)
    
    validate(
      need(nrow(df) > 5, "Sem dados disponíveis.")
    )
    
    # =========================================================
    # TRATAMENTO
    # =========================================================
    
    df <- df %>%
      
      mutate(
        
        DateTime = as.POSIXct(
          ts / 1000,
          origin = "1970-01-01",
          tz = "America/Sao_Paulo"
        )
      )
    
    # =========================================================
    # MEDIDORES DE POTÊNCIA DIRETA
    # =========================================================
    if (input$medidor %in% medidores_potencia) {
      
      df <- df %>%
        
        arrange(DateTime) %>%
        
        mutate(
          Potencia_kW = pointValue / 1000
        )
      limite_max <- 15000
      
    } else {
      
      # =======================================================
      # MEDIDORES DE ENERGIA ACUMULADA
      # =======================================================
      df <- df %>%
        
        arrange(DateTime) %>%
        
        mutate(
          
          delta_energia = pointValue - lag(pointValue),
          
          delta_tempo_h = as.numeric(
            difftime(
              DateTime,
              lag(DateTime),
              units = "hours"
            )
          ),
          
          Potencia_kW = (delta_energia / delta_tempo_h) / 1000
        )
      limite_max <- 5000
    }
    
    # =========================================================
    # FILTROS
    # =========================================================
    df <- df %>%
      
      mutate(
        
        Potencia_kW = ifelse(
          !is.finite(Potencia_kW) |
            Potencia_kW < 0 |
            Potencia_kW > limite_max,
          NA,
          Potencia_kW
        )
      ) %>%
      
      filter(!is.na(Potencia_kW)) %>%
      
      mutate(
        
        DateTime = floor_date(
          DateTime,
          unit = "15 minutes"
        )
      ) %>%
      
      group_by(DateTime) %>%
      
      summarise(
        
        Potencia_kW = round(
          mean(Potencia_kW, na.rm = TRUE),
          2
        ),
        
        .groups = "drop"
      ) %>%
      
      mutate(
        
        Dia_Semana = wday(
          DateTime,
          label = TRUE,
          abbr = FALSE
        )
      )
    
    df
  })
  
  # =========================================================
  # DADOS WIDE
  # =========================================================
  dados_wide <- reactive({
    
    dados_tratados() %>%
      
      mutate(
        Data = as.Date(DateTime),
        Hora = format(DateTime, "%H:%M")
      ) %>%
      
      select(
        Data,
        Hora,
        Potencia_kW
      ) %>%
      
      pivot_wider(
        names_from = Hora,
        values_from = Potencia_kW
      ) %>%
      
      mutate(
        Dia_Semana = weekdays(Data)
      ) %>%
      
      relocate(
        Dia_Semana,
        .after = Data
      )
  })
  
  # =========================================================
  # INDICADORES
  # =========================================================
  output$media_kw <- renderUI({
    
    df <- dados_tratados()
    
    HTML(
      paste0(
        "<span class='valor-indicador'>",
        round(mean(df$Potencia_kW, na.rm = TRUE), 2),
        "</span>",
        
        "<span class='label-indicador'>kW</span>"
      )
    )
  })
  
  output$max_kw <- renderUI({
    
    df <- dados_tratados()
    
    HTML(
      paste0(
        "<div class='valor-indicador'>",
        round(max(df$Potencia_kW, na.rm = TRUE), 2),
        "</div>",
        
        "<div class='label-indicador'>kW</div>"
      )
    )
  })
  
  output$energia <- renderUI({
    
    df <- dados_tratados()
    
    energia <- sum(df$Potencia_kW * 0.25, na.rm = TRUE)
    
    HTML(
      paste0(
        "<div class='valor-indicador'>",
        round(energia, 2),
        "</div>",
        
        "<div class='label-indicador'>kWh</div>"
      )
    )
  })
  
  output$n_registros <- renderUI({
    
    df <- dados_tratados()
    
    HTML(
      paste0(
        "<div class='valor-indicador'>",
        nrow(df),
        "</div>",
        
        "<div class='label-indicador'>linhas</div>"
      )
    )
  })
  
  # =========================================================
  # GRÁFICO SÉRIE TEMPORAL
  # =========================================================
  output$grafico_tempo <- renderPlotly({
    
    df <- dados_tratados()
    
    p <- ggplot(
      df,
      
      aes(
        x = DateTime,
        y = Potencia_kW
      )
    ) +
      
      geom_step(
        color = "#2c3e50",
        linewidth = 0.5
      ) +
      
      geom_area(
        fill = "#3498db",
        alpha = 0.25
      ) +
      
      labs(
        title = "Série Histórica Contínua",
        x = "Tempo",
        y = "Potência (kW)"
      ) +
      
      theme_minimal()
    
    ggplotly(p) %>%
      style(hoverinfo = "skip", traces = 2) %>%
      layout(
        hovermode = "x unified"
      )
  })
  
  # =========================================================
  # PERFIL DE CARGA
  # =========================================================
  output$grafico_perfil <- renderPlotly({
    
    df <- dados_tratados()
    
    p <- ggplot(
      df,
      aes(
        x = as_hms(DateTime),
        y = Potencia_kW
      )
    ) +
      
      geom_step(
        aes(group = as.Date(DateTime)),
        color = "gray",
        alpha = 0.08
      ) +
      
      stat_summary(
        aes(
          color = Dia_Semana,
          group = Dia_Semana
        ),
        fun = mean,
        geom = "line",
        linewidth = 1
      ) +
      
      labs(
        title = "Perfil Médio por Dia da Semana",
        x = "Hora do Dia",
        y = "Potência (kW)",
        color = "Dia da Semana"
      ) +
      
      guides(color = guide_legend(title = "Dia da Semana")) +
      
      theme_minimal()
    
    ggplotly(p, tooltip = c("x", "y", "color")) %>%
      layout(
        legend = list(
          orientation = "h",
          xanchor = "center",
          x = 0.5,
          y = -0.25
        ),
        margin = list(b = 70, t = 40)
      )
  })
  
  # =========================================================
  # TABELA
  # =========================================================
  output$tabela_dados <- renderDT({
    
    datatable(
      dados_wide(),
      
      rownames = FALSE,
      filter = "none",
      selection = "none",
      class = 'display nowrap',
      options = list(
        pageLength = 15,
        scrollX = TRUE,
        columnDefs = list(list(className = 'dt-nowrap', targets = "_all"))
      )
    )
  })
  
  # =========================================================
  # DOWNLOAD CSV
  # =========================================================
  output$downloadData <- downloadHandler(
    
    filename = function() {
      
      paste0(
        "Tabela_Wide_",
        input$medidor,
        ".csv"
      )
    },
    
    content = function(file) {
      
      write.csv(
        dados_wide(),
        file,
        row.names = FALSE
      )
    }
  )
}

# =========================================================
# EXECUTAR APP
# =========================================================
shinyApp(ui, server)