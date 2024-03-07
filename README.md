
## Popular Repos

``` r
library(gh)
library(tibble)
library(tidyr)
library(dplyr)
```

    ## 
    ## Attaching package: 'dplyr'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag

    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

``` r
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

plot <- repos_to_plot %>%
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
```

    ## Saving 7 x 5 in image

![](graph.png)

## DaveParr.Info

I have a blog at [DaveParr.info](DaveParr.info).

## Popular Blogs

The blog is reyndicated at [Dev.to](https://dev.to/daveparr). Here are
the most popular articles.

``` r
library(dev.to.ol)
library(dplyr)
library(knitr)

dev.to.ol::get_users_articles() %>%
  dplyr::arrange(dplyr::desc(public_reactions_count)) %>%
  dplyr::slice(1:5) %>%
  dplyr::mutate(article = paste0("[", title, "](", url, ")")) %>%
  dplyr::select(
    article,
    public_reactions_count,
    comments_count,
    page_views_count
  ) %>%
  knitr::kable()
```

    ## Using DEVTO in .Renviron

    ## The API returned the expected success: 200

| article                                                                                                                                                                                       | public_reactions_count | comments_count | page_views_count |
|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-----------------------:|---------------:|-----------------:|
| [I made my dev.to content into a website to find a new job](https://dev.to/daveparr/i-made-my-dev-to-content-into-a-website-to-find-a-new-job-2kn5)                                           |                     37 |              3 |              578 |
| [Why use AWS Lambda for Data Science?](https://dev.to/daveparr/why-use-aws-lambda-for-data-science-421)                                                                                       |                     32 |              3 |             1243 |
| [Posting straight from .Rmd to dev.to (for real this time)](https://dev.to/daveparr/posting-straight-from-rmd-to-dev-to-1j4p)                                                                 |                     15 |              0 |              210 |
| [Writing R packages, fast](https://dev.to/daveparr/writing-r-packages-fast-474c)                                                                                                              |                     12 |              0 |               77 |
| [My GitHub profile shows my popular dev.to posts and GitHub repos automatically](https://dev.to/daveparr/my-github-profile-shows-my-popular-dev-to-posts-and-github-repos-automatically-2n05) |                      9 |              0 |              191 |

## About

This profile is generated by Github Actions and R Markdown.
