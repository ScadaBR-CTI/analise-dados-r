# Análise Energética do CTI Renato Archer

Este repositório reúne os estudos, algoritmos e aplicações desenvolvidos para análise de dados energéticos provenientes do sistema supervisório ScadaBR do CTI Renato Archer. O projeto tem como foco a utilização de dados históricos para compreensão do comportamento operacional e energético da infraestrutura monitorada, permitindo transformar informações brutas em indicadores técnicos e visualizações analíticas.

Os dados utilizados são obtidos a partir do banco de dados integrado ao ScadaBR, sendo posteriormente tratados e processados em R. A partir desse fluxo, são realizadas análises temporais, cálculos estatísticos e modelagens voltadas ao acompanhamento do consumo energético, demanda elétrica e comportamento dos grupos consumidores ao longo do tempo.

O desenvolvimento contempla desde a importação e estruturação das bases históricas até a geração de dashboards interativos e relatórios técnicos, permitindo maior rastreabilidade dos dados e suporte à tomada de decisão operacional.

O projeto também busca consolidar uma base analítica reutilizável para futuras aplicações em monitoramento inteligente, detecção de padrões e modelos preditivos.

## Objetivo

Avaliar padrões de consumo, demanda elétrica e comportamento operacional dos grupos consumidores da instituição.

## Algoritmo

Foram desenvolvidos dois algoritmos principais para importação, tratamento e análise dos dados energéticos.

O primeiro consiste em uma aplicação executada diretamente no RStudio, com abordagem mais analítica e individual para cada medidor monitorado. Esse algoritmo permite a geração de gráficos de perfil de carga por dia da semana, além do cálculo de médias de consumo e análises comparativas entre períodos operacionais.

O segundo corresponde a uma aplicação mais completa e interativa desenvolvida com Shiny, incorporando visualizações dinâmicas, séries temporais, tabelas analíticas e dashboards operacionais. Essa aplicação possibilita uma exploração mais ampla dos dados históricos, facilitando o acompanhamento do comportamento energético e a interpretação dos indicadores gerados.

Os algoritmos podem ser acessados nos links abaixo:

* [**1. Acessar programa RStudio**](https://github.com/ScadaBR-CTI/analise-dados-r/blob/main/scripts/01_mysql_import.R)
* [**2. Acessar programa Shinyapp**](https://github.com/ScadaBR-CTI/analise-dados-r/blob/main/scripts/Carga_CTI_Shiny.R)

## Apresentação do Sistema ScadaBR-CTI

A seguir será apresentada uma visão geral do sistema ScadaBR-CTI, ilustrada por três imagens representando as principais funcionalidades da plataforma análise desenvolvida. As interfaces apresentadas demonstram os recursos de visualização, processamento analítico e exploração dos dados operacionais e energéticos coletados pelo sistema.

### *Dashbords* com o Shiny

A imagem a seguir apresenta a tela inicial do *dashboard* analítico desenvolvido em Shiny. Nessa interface, o usuário pode selecionar o período de análise e o ponto de medição desejado, permitindo a exploração dinâmica das informações armazenadas no sistema.

Também são exibidos os indicadores, posicionados na parte superior da interface para facilitar a interpretação rápida dos dados monitorados.

Além disso, observa-se o gráfico de **Série Temporal**, responsável por apresentar a evolução histórica das variáveis monitoradas ao longo do tempo, permitindo identificar padrões de comportamento, tendências operacionais e possíveis características de sazonalidade nos dados coletados.

<p align="center">
  <img src="img/Painel1.png" alt="Paínel ScadaBR CTI" width="100%">
</p>

Aqui observamos o gráfico de Perfil de Carga, responsável por permitir a visualização do comportamento do consumo energético ao longo do período operacional analisado.

Esse tipo de análise possibilita identificar horários de maior demanda, padrões de utilização da infraestrutura e variações de consumo entre diferentes faixas horárias, dias da semana ou períodos específicos de operação.

O gráfico também auxilia na identificação de picos de consumo, comportamentos atípicos e oportunidades de otimização energética, fornecendo suporte para análises comparativas e avaliação da eficiência operacional dos sistemas monitorados.

<p align="center">
  <img src="img/Painel2.png" alt="Paínel ScadaBR CTI" width="100%">
</p>

A tabela de dados consolidados, responsável por apresentar de forma estruturada as informações processadas pelo sistema a partir das séries temporais armazenadas no banco de dados.

Nessa visualização, são exibidos os valores agregados por período de análise, permitindo consultar métricas como consumo, médias operacionais, horários de registro e demais indicadores derivados calculados pela camada analítica.

A tabela também auxilia na validação dos dados monitorados e na realização de análises comparativas, servindo como apoio para interpretações mais detalhadas das informações apresentadas nos gráficos e indicadores do *dashboard*.

<p align="center">
  <img src="img/Painel3.png" alt="Paínel ScadaBR CTI" width="100%">
</p>

---

## Tecnologias Empregadas

O ambiente de desenvolvimento e análise é composto pelas seguintes tecnologias:

- R / RStudio para processamento, modelagem e análise estatística
- MySQL como camada de armazenamento dos dados históricos
- ScadaBR para aquisição e supervisão operacional
- Shiny para construção de dashboards e aplicações web interativas

## Estrutura do Projeto

- Importação de dados históricos
- Tratamento de séries temporais
- Cálculo de potência média
- Dashboards interativos
- Relatórios técnicos

## Resultados Esperados

Com a consolidação das análises, espera-se obter maior visibilidade sobre o comportamento energético da infraestrutura monitorada, permitindo:

- Identificação de padrões de consumo e horários de pico
- Apoio à gestão e eficiência energética
- Suporte à tomada de decisão técnica
- Identificação de anomalias operacionais
- Formação de base histórica para futuras aplicações de Machine Learning e análise preditiva

  **[Página Inicial](https://github.com/ScadaBR-CTI)**
