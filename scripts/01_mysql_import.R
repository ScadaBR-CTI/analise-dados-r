# =========================
# Pacotes
# =========================
library(dplyr)
library(tidyr)
library(lubridate)
library(ggplot2)
library(plotly)
library(scales)
library(purrr)
library(hms)
library(DBI)
library(RMySQL)

# ============================
# Renomeação dos Medidores
# ============================
medidores <- c(
  M_2 = "QAC1", 
  M_3 = "QAC2",
  M_4 = "QAC3",
  M_5 = "NT3D",
  M_6 = "THERMOTRON",
  M_7 = "UTA1",
  M_8 = "UTA2",
  M_9  = "SCHNEIDER_9", 
  M_10 = "SCHNEIDER_10",
  M_11 = "SCHNEIDER_11", 
  M_12 = "SCHNEIDER_12", 
  M_13 = "SCHNEIDER_13",
  M_14 = "SCHNEIDER_14", 
  M_15 = "SCHNEIDER_15",
  M_16 = "SCHNEIDER_16", 
  M_17 = "SCHNEIDER_17",
  M_18 = "SCHNEIDER_18", 
  M_19 = "SCHNEIDER_19", 
  M_20 = "SCHNEIDER_20",
  M_21 = "SCHNEIDER_21", 
  M_22 = "SCHNEIDER_22",
  M_23 = "SCHNEIDER_23", 
  M_24 = "SCHNEIDER_24",
  M_26 = "SCHNEIDER_26", 
  M_27 = "SCHNEIDER_27", 
  M_28 = "SCHNEIDER_28",
  M_29 = "SCHNEIDER_29", 
  M_30 = "SCHNEIDER_30",
  M_31 = "SCHNEIDER_31", 
  M_32 = "SCHNEIDER_32",
  M_33 = "SCHNEIDER_33", 
  M_34 = "SCHNEIDER_34", 
  M_35 = "SCHNEIDER_35",
  M_36 = "SCHNEIDER_36", 
  M_37 = "SCHNEIDER_37",
  M_39 = "SCHNEIDER_39", 
  M_42 = "SCHNEIDER_42",
  M_43 = "SCHNEIDER_43",
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
  M_256 = "PMT-02_256",
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

# ============================
# Conexão com o banco de dados
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
# Leitura dos dados
# =========================
dados <- dbGetQuery(con, "
  SELECT 
    ts,
    dataPointId,
    pointValue
  FROM pointvalues
  WHERE ts BETWEEN
   UNIX_TIMESTAMP('2021-03-15') * 1000
   AND UNIX_TIMESTAMP('2021-04-16') * 1000
  ORDER BY dataPointId, ts
")

dbDisconnect(con)

# =========================
# Tratamento dos dados
# =========================
TABELAO <- dados %>%
  select(ts, dataPointId, pointValue) %>%
  
  mutate(
    DateTime = as.POSIXct(
      ts / 1000,
      origin = "1970-01-01",
      tz = "America/Sao_Paulo"
    ),
  ) %>%
  
  arrange(dataPointId, DateTime) %>%
  group_by(dataPointId) %>%
  mutate(
    pointValue = (pointValue - lag(pointValue)) * 4,
    pointValue = ifelse(pointValue < 0 | pointValue > 10000, NA, pointValue)
  ) %>%
  ungroup() %>%
  
  mutate(
    DateTime = floor_date(DateTime, "15 min")
  ) %>%
  
  group_by(DateTime, dataPointId) %>%
  summarise(
    pointValue = ifelse(
      all(is.na(pointValue)),
      NA,
      mean(pointValue, na.rm = TRUE)
    ),
    .groups = "drop"
  ) %>%
  
  mutate(
    Dia_semana = wday(DateTime, label = TRUE, abbr = FALSE)
  ) %>%
  
  filter(!is.na(dataPointId)) %>%
  arrange(dataPointId)

# =============================
# Converter para formato largo
# =============================
TABELAO_WIDER <- TABELAO %>%
  pivot_wider(
    id_cols = c(DateTime, Dia_semana),
    names_from  = dataPointId,
    values_from = pointValue,
    names_prefix = "M_"
  ) %>%
  
  arrange(DateTime)

# =========================
# Converter para formato longo
# + Renomear medidores
# =========================
TABELAO_long <- TABELAO_WIDER %>%
  pivot_longer(
    cols = starts_with("M_"),
    names_to = "medidor",
    values_to = "pointValue"
  ) %>%
  mutate(
    medidor = ifelse(
      medidor %in% names(medidores),
      recode(medidor, !!!medidores),
      medidor
    )
  )

# =========================
# Grafico
# =========================
plots <- TABELAO_long %>%
  split(.$medidor, drop = TRUE) %>%
  map(~ {
    
    if (nrow(.x) == 0) return(NULL)
    if (!"DateTime" %in% names(.x)) return(NULL)
    
    df_plot <- .x %>%
      filter(
        !is.na(DateTime),
        !is.na(pointValue),
        pointValue > 0
      )
    
    if (nrow(df_plot) == 0) return(NULL)
    
    df_plot <- df_plot %>%
      mutate(
        Data = as.Date(DateTime),
        Hora = as_hms(DateTime)
      ) %>%
      arrange(Data, Hora)
    
    p <- ggplot(df_plot, aes(x = Hora, y = pointValue)) +
      
      geom_line(
        aes(group = Data, text = paste("Data:", Data)),
        color = "blue",
        alpha = 0.2,
        size = 0.3
      ) +
      
      stat_summary(
        aes(color = Dia_semana, group = Dia_semana),
        fun = mean,
        geom = "line",
        size = 0.5
      ) +
      
      scale_x_time(
        breaks = hms::hms(hours = seq(0, 24, by = 1)),
        labels = scales::label_time(format = "%H:%M"),
        expand = c(0, 0)
      ) +
      
      labs(
        title = paste0(
          "Perfil de Carga: ", unique(df_plot$medidor),
          " - Período: ", format(min(df_plot$DateTime), "%d/%m/%y"),
          " a ", format(max(df_plot$DateTime), "%d/%m/%y")
        ),
        x = "Hora do Dia",
        y = "Potência (kW)",
        color = "Média por dia"
      ) +
      
      theme_minimal() +
      theme(
        legend.position = "bottom",
        legend.title = element_text(face = "bold"),
        panel.grid.minor = element_blank()
      )
    
    ggplotly(p, tooltip = c("text", "x", "y", "color")) %>%
      layout(
        legend = list(
          orientation = "h",
          xanchor = "center",
          x = 0.5,
          y = -0.2
        )
      )
    
  }) %>%
  compact()

# =========================
# Selecionar medidor
# =========================
plots[["QAC1"]]
