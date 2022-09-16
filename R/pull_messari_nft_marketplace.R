# Pull data from Messari subgraphs - NFT Marketplaces
# Notes: covered Marketplace, Collection, marketplaceDailySnapshots
# todo:
# - Trade, CollectionDailySnapshot, Trade
# - might be better to create new function for CollectionDailySnapshot

pull_messari_nft_marketplace = function(api_key='d15aa0f9f570a7be9dce4412b547e67f', marketplace='x2y2-ethereum', entity='marketplaceDailySnapshots', first=1000, visualize=FALSE, visualize_col='dailyActiveTraders'){
  if( (marketplace == 'x2y2-ethereum' | marketplace == 'X2Y2-ethereum') ){
    subgraph_url = paste0("https://gateway.thegraph.com/api/",api_key,"/subgraphs/id/8ZjJGsaKea7WwLJPJNdHXPGsvXDe3iq2231aRjgBPisi")
  }
  # options: looksrare-ethereum, opensea-v1-ethereum, opensea-v2-ethereum, opensea-seaport-ethereum, sudoswap-ethereum (net deployed on Sep 10)
  else{
    subgraph_url = paste0("https://api.thegraph.com/subgraphs/name/messari/", marketplace)
  }
  # connect to the endpoint
  con = ghql::GraphqlClient$new(
    url = subgraph_url
  )
  # initialize a new query
  graphql_request = ghql::Query$new()
  # Define query
  if ( (entity=='Marketplace' | entity=='marketplace') & visualize==FALSE){
    graphql_request$query('mydata', paste0('{
      marketplaces(first: 5) {
        id
        name
        slug
        network
        collectionCount
        tradeCount
        cumulativeTradeVolumeETH
        marketplaceRevenueETH
        creatorRevenueETH
        totalRevenueETH
        cumulativeUniqueTraders
      }
    }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$marketplaces) #ideally could do something like data$data[entity]
    # return result
    return(data)
  }
  else if ( (entity=='marketplaceDailySnapshots' | entity=='marketplace daily snapshot') & visualize==FALSE){
    graphql_request$query('mydata', paste0('{
      marketplaceDailySnapshots(orderBy: blockNumber, orderDirection: desc, first:',first,') {
        id
        blockNumber
        timestamp
        collectionCount
        cumulativeTradeVolumeETH
        marketplaceRevenueETH
        creatorRevenueETH
        totalRevenueETH
        tradeCount
        cumulativeUniqueTraders
        dailyActiveTraders
        dailyTradedCollectionCount
        dailyTradedItemCount
      }
    }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$marketplaceDailySnapshots) #ideally could do something like data$data[entity]
    # convert timestamp
    data = dplyr::mutate(data, timestamp=as.POSIXct(as.numeric(timestamp), origin="1970-01-01"))
    # return result
    return(data)
  }
  else if(entity=='marketplaceDailySnapshots' & visualize==TRUE){
    graphql_request$query('mydata', paste0('{
      marketplaceDailySnapshots(orderBy: blockNumber, orderDirection: desc, first:',first,') {
        id
        blockNumber
        timestamp
        collectionCount
        cumulativeTradeVolumeETH
        marketplaceRevenueETH
        creatorRevenueETH
        totalRevenueETH
        tradeCount
        cumulativeUniqueTraders
        dailyActiveTraders
        dailyTradedCollectionCount
        dailyTradedItemCount
      }
    }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$marketplaceDailySnapshots) #ideally could do something like data$data[entity]
    # convert timestamp
    data = dplyr::mutate(data, timestamp=as.POSIXct(as.numeric(timestamp), origin="1970-01-01"))
    # visualize
    return(ggplot2::ggplot(data, ggplot2::aes_string("timestamp", visualize_col)) + ggplot2::geom_line())
  }
  else if ( (entity=='Collection' | entity=='collection') & visualize==FALSE){
    graphql_request$query('mydata', paste0('{
        collections(first:',first,') {
          id
          name
          symbol
          totalSupply
          totalSupply
          nftStandard
          royaltyFee
          cumulativeTradeVolumeETH
          marketplaceRevenueETH
          creatorRevenueETH
          totalRevenueETH
          tradeCount
          buyerCount
          sellerCount
        }
      }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$collections) #ideally could do something like data$data[entity]
    # return result
    return(data)
  }
  # example usage: pull_messari_nft_marketplace(entity='collection', first=10, visualize=TRUE, visualize_col='cumulativeTradeVolumeETH')
  else if ( (entity=='Collection' | entity=='collection') & visualize==TRUE){
    graphql_request$query('mydata', paste0('{
        collections(orderBy: cumulativeTradeVolumeETH, orderDirection: desc, first:',first,') {
          id
          name
          symbol
          totalSupply
          totalSupply
          nftStandard
          royaltyFee
          cumulativeTradeVolumeETH
          marketplaceRevenueETH
          creatorRevenueETH
          totalRevenueETH
          tradeCount
          buyerCount
          sellerCount
        }
      }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$collections) #ideally could do something like data$data[entity]
    # visualize
    return(ggplot2::ggplot(data, ggplot2::aes_string(x="name", visualize_col)) +
             ggplot2::geom_bar(stat="identity") +
             ggplot2::theme(axis.text.x=ggplot2::element_text(angle=45,hjust=1,vjust=1)))
  }
  else if ( (entity=='Collection' | entity=='collection') & visualize==FALSE){
    graphql_request$query('mydata', paste0('{
        collections(first:',first,') {
          id
          name
          symbol
          totalSupply
          totalSupply
          nftStandard
          royaltyFee
          cumulativeTradeVolumeETH
          marketplaceRevenueETH
          creatorRevenueETH
          totalRevenueETH
          tradeCount
          buyerCount
          sellerCount
        }
      }'))
    # Run query (pull data)
    data = con$exec(graphql_request$queries$mydata)
    # convert results to JSON
    data = jsonlite::fromJSON(data)
    # extract result
    data = tibble::as_tibble(data$data$collections) #ideally could do something like data$data[entity]
    # return result
    return(data)
  }

}


