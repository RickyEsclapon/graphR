# graphR
R helper functions to pull data from The Graph

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


