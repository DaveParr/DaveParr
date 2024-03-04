library(gh)
library(tibble)
library(tidyr)
library(dplyr)
library(ggplot2)

repos <- tibble::tibble(
  repos = gh::gh("/users/{username}/repos",
    username = "daveparr",
    .limit = 100
  )
)

repos_to_plot <- repos %>%
  tidyr::hoist(
    repos,
    repo_name = "name",
    fork = "fork",
    forks_count = "forks_count",
    stargazers_count = "stargazers_count",
  ) %>%
  dplyr::filter(fork == FALSE) %>%
  dplyr::filter(forks_count > 0 | stargazers_count > 0) %>%
  dplyr::arrange(desc(stargazers_count)) %>%
  tidyr::pivot_longer(
    cols = ends_with("_count"),
    names_to = "metric", values_to = "count"
  ) %>%
  dplyr::arrange(desc(count))

repos_to_plot %>%
  ggplot2::ggplot(aes(
    x = forcats::fct_reorder(repo_name, count, .desc = TRUE),
    y = count,
    fill = metric
  )) +
  ggplot2::geom_col(position = "dodge") +
  ggplot2::guides(x = guide_axis(angle = 90)) +
  ggplot2::labs(
    x = "Repo",
    y = "Stargazers",
    fill = "Metric"
  ) +
  ggplot2::theme_minimal()

ggplot2::ggsave("graph.png")
