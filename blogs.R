library(dev.to.ol)
library(dplyr)

dev.to.ol::get_users_articles() %>%
  dplyr::arrange(dplyr::desc(public_reactions_count)) %>%
  dplyr::slice(1:5) %>%
  dplyr::mutate(article = paste0('[', title, '](', url, ')')) %>%
  dplyr::select(article,
                public_reactions_count,
                comments_count,
                page_views_count) %>% 
  print()