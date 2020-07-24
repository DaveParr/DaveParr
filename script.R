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
  pivot_longer(cols = ends_with("_count"),
               names_to = "metric", values_to = "count") %>% 
  ggplot2::ggplot(aes(
    x = reorder(name, -count), 
    y = count)) +
  ggplot2::geom_col() + 
  ggplot2::guides(x = guide_axis(angle = 45)) +
  ggplot2::labs(title = "Stargazers by repo",
                x = "Repo",
                y = "Stargazers") +
  theme_minimal() +
  facet_wrap(~ metric)

ggsave("graph.png")
  
