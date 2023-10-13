## Experimenting with Zentra Cloud data

[![Project Status: Concept – Minimal or no implementation has been done yet, or the repository is only intended to be a limited example, demo, or proof-of-concept.](https://www.repostatus.org/badges/latest/concept.svg)](https://www.repostatus.org/#concept)


This repo is for getting used to working with data downloaded by the `zentracloud` package.

`zentracloud` can be installed with:

```r
install.packages('zentracloud', repos = c('https://cct-datascience.r-universe.dev', 'https://cloud.r-project.org'))
```

Or directly from the GitLab site with:

```r
pak::pkg_install("git::https://gitlab.com/meter-group-inc/pubpackages/zentracloud.git")
```

For these script to work, you'll also need to create a .Renviron file containing the Zentra Cloud API token.

```
ZENTRACLOUD_TOKEN=<token>
```

## Scripts

- `wrangling.R` contains an example of downloading data from multiple sites and combining into one dataset
- `benchmarking.R` is an attempt to figure out why downloading data takes so long.
(replace `<token>` with your API token)