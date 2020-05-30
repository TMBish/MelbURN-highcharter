library(highcharter)

highchart() %>% 
  hc_chart(type = "bubble") %>% 
  hc_yAxis(min = 0, max = 6) %>%
  hc_add_series_list(
    list(
      list(
      
      name = "Smiles",
      data = list(
        
        list(
          sequence = 
            list(
              list(name = "tom", y = 2, z = 1),
              list(name = "tom", y = 3, z = 2),
              list(name = "tom", y = 5, z = 3)
            )
        ),             
        
        list(
          sequence = 
            list(
              list(name = "hannah", y = 4, z = 3),
              list(name = "hannah", y = 3, z = 2),
              list(name = "hannah", y = 2, z = 1)
            )
        )
      )
    )
    )
  ) %>%
  hc_motion(enabled = TRUE,
            labels = 2000:2003,
            series = c(0,1)) %>%
  hc_xAxis(categories = c("tom", "hannah"))