library(tidyverse)
library(gapminder)
data(gapminder, package = "gapminder")

gp <- gapminder %>%
  arrange(desc(year)) %>%
  distinct(country, .keep_all = TRUE)

gp2 <- gapminder %>%
  select(country, year, pop) %>% 
  nest(-country) %>%
  mutate(
    data = map(data, mutate_mapping, hcaes(x = year, y = pop), drop = TRUE),
    data = map(data, list_parse)
  ) %>%
  rename(ttdata = data)

gptot <- left_join(gp, gp2, by = "country")

hchart(
  gptot,
  "point",
  hcaes(lifeExp, gdpPercap, name = country, size = pop, group = continent, name = country)
) %>%
hc_yAxis(type = "logarithmic") %>% 
# here is the magic (inside the function)
hc_tooltip(
  useHTML = TRUE,
  headerFormat = "<b>{point.key}</b>",
  pointFormatter = tooltip_chart(accesor = "ttdata")
)


donutdata2 <- gp %>% 
  select(continent, lifeExp, gdpPercap) %>% 
  nest(-continent) %>% 
  mutate(
    data = map(data, mutate_mapping, hcaes(x = lifeExp, y = gdpPercap), drop = TRUE),
    data = map(data, list_parse)
  ) %>%
  rename(ttdata = data) %>% 
  left_join(donutdata)

hc <- hchart(
  donutdata2,
  "pie",
  hcaes(name = continent, y = pop),
  innerSize = 375
)

hc %>% 
  hc_tooltip(
    useHTML = TRUE,
    headerFormat = "<b>{point.key}</b>",
    pointFormatter = tooltip_chart(
      accesor = "ttdata",
      hc_opts = list(
        chart = list(type = "scatter"),
        credits = list(enabled = FALSE),
        plotOptions = list(scatter = list(marker = list(radius = 2)))
      ),
      height = 225
    ),
    positioner = JS(
      "function () {
      
        /* one of the most important parts! */
        xp =  this.chart.chartWidth/2 - this.label.width/2
        yp =  this.chart.chartHeight/2 - this.label.height/2
      
        return { x: xp, y: yp };
      
      }"),
    shadow = FALSE,
    borderWidth = 0,
    backgroundColor = "transparent",
    hideDelay = 1000
  )