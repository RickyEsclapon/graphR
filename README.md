# graphR
R helper functions to pull data from The Graph (leveraging [Messari subgraphs](https://github.com/messari/subgraphs))

## Install

First make sure you have `remotes` package installed:
```{r}
install.packages('remotes')
```
Then install `graphR` package:
```{r}
remotes::install_github('RickyEsclapon/graphR')
```

## Usage examples

Pull data:
```{r}
pull_dex(exchange='sushiswap-ethereum')
```

Pull + visualize data:
```{r}
pull_dex(exchange='sushiswap-ethereum', visualize = TRUE)
```

Specify column to visualize:
```{r}
pull_dex(exchange='sushiswap-polygon', visualize = TRUE, visualize_col = 'dailyActiveUsers')
```

## Purpose

The purpose of this package is to make it as simple as possible to extract and visualize data for a variety of protocols leveraging [The Graph](https://thegraph.com/). This is made possible thanks to Messari introducing new subgraphs standardized across different protocols that fall into the same categories. For example, for decentralized exchanges, they will all have a consistent schema. This allows a more catered approach towards a specific schema which will be consistent across a variety of protocols.

## To-do

- [ ] Finalize functions for DEX, accounting for all entities available

- [ ] Create an example flexdashboard allowing the user to pick different protocols and different entities

- [ ] Add the remaining categories/subgraphs using the same approach taken for DEX

- [ ] Polish up package with documentation + smaller touches (testthat, license, etc...)



