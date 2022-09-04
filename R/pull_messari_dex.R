# Pull data from Messari subgraphs - DEX AMM

pull_messari_dex = function(api_key='d15aa0f9f570a7be9dce4412b547e67f', exchange='sushiswap-ethereum', entity='usageMetricsDailySnapshots', first=1000, visualize=FALSE, visualize_col='dailyTransactionCount'){
  if(exchange == 'sushiswap-ethereum'){
    subgraph_url = paste0("https://gateway.thegraph.com/api/",api_key,"/subgraphs/id/7h1x51fyT5KigAhXd8sdE3kzzxQDJxxz1y66LTFiC3mS")
  }
  else if(exchange == 'sushiswap-polygon'){
    # still needs to be published to decentralized network - for now point to hosted-service
    subgraph_url = "https://api.thegraph.com/subgraphs/name/messari/sushiswap-polygon"
  }
  else{
    subgraph_url = paste0("https://api.thegraph.com/subgraphs/name/messari/", exchange)
  }
  # connect to the endpoint
  con = ghql::GraphqlClient$new(
    url = subgraph_url
  )
  # initialize a new query
  graphql_request = ghql::Query$new()
  # Define query
  if (entity=='usageMetricsDailySnapshots' & visualize==FALSE){
    graphql_request$query('mydata', paste0('{
    usageMetricsDailySnapshots(orderBy: blockNumber, orderDirection: desc, first:',first,'){
      blockNumber
      cumulativeUniqueUsers
      dailyActiveUsers
      dailyDepositCount
      dailySwapCount
      dailyTransactionCount
      dailyWithdrawCount
      id
      totalPoolCount
      timestamp
    }
  }'))
  # Run query (pull data)
  data = con$exec(graphql_request$queries$mydata)
  # convert results to JSON
  data = jsonlite::fromJSON(data)
  # extract result
  data = tibble::as_tibble(data$data$usageMetricsDailySnapshots) #ideally could do something like data$data[entity]
  # convert timestamp
  data = dplyr::mutate(data, timestamp=as.POSIXct(as.numeric(timestamp), origin="1970-01-01"))
  # return result
  return(data)
  }
  else if(entity=='usageMetricsDailySnapshots' & visualize==TRUE){
    graphql_request$query('mydata', paste0('{
    usageMetricsDailySnapshots(orderBy: blockNumber, orderDirection: desc, first:',first,'){
      blockNumber
      cumulativeUniqueUsers
      dailyActiveUsers
      dailyDepositCount
      dailySwapCount
      dailyTransactionCount
      dailyWithdrawCount
      id
      totalPoolCount
      timestamp
    }
  }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$usageMetricsDailySnapshots) #ideally could do something like data$data[entity]
    # convert timestamp
    data = dplyr::mutate(data, timestamp=as.POSIXct(as.numeric(timestamp), origin="1970-01-01"))
    # visualize
    return(ggplot2::ggplot(data, ggplot2::aes_string("timestamp", visualize_col)) + ggplot2::geom_line())
  }
}


