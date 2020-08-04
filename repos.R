library(gh)
library(tibble)
library(tidyr)
library(dplyr)
library(ggplot2)

tibble::tibble(repos = gh::gh("GET /users/:username/repos", username = "daveparr")) %>%
  tidyr::hoist(
    repos,
    name = "name",
    fork = "fork",
    forks_count = "forks_count",
    stargazers_count = "stargazers_count",
    watchers_count = "watchers_count"
  ) -> repos

repos %>%
  dplyr::filter(fork == FALSE) %>%
  dplyr::filter(forks_count > 0 | stargazers_count > 0 | watchers_count > 0) %>% 
  tidyr::pivot_longer(cols = ends_with("_count"),
               names_to = "metric", values_to = "count") %>% 
  dplyr::mutate(metric = str_remove(metric, "_count")) %>% 
  ggplot2::ggplot(aes(
    x = name, 
    y = count,
    fill = metric)) +
  ggplot2::geom_col(position = "dodge") + 
  ggplot2::guides(x = guide_axis(angle = 90)) +
  ggplot2::labs(x = "Repo",
                y = "Stargazers",
                fill = "Metric") +
  ggplot2::theme_minimal()

ggplot2::ggsave("graph.png")
  
