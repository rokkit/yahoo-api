module Yahoo
  module Api
    API_QUERY_URL = "http://query.yahooapis.com/v1/public/yql?q="

    module Finance
      FINANCE_DATABASE = "yahoo.finance.quotes"
      DATATABLE = "&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"

      class QueryURI                 
        def self.build(tickers)
          validate_tickers(tickers)
          URI(build_query_uri(tickers))
        end        

        private  
  
        def self.validate_tickers(tickers)
          if tickers.class != Array
            raise ArgumentError, "Tickers must be supplied in an Array"
          elsif tickers.empty? || tickers.include?("")
            raise ArgumentError, "At least one ticker must be supplied"
          end        
        end
  
        def self.build_query_uri(tickers)
          base_query =  API_QUERY_URL + select_data_from + FINANCE_DATABASE + 
              for_these_symbols(tickers)
          query = URI.encode(base_query) + "&format=json" + DATATABLE
        end     

        def self.for_these_symbols(tickers)
          " where symbol in (\"#{tickers.join("\", \"")}\")"    
        end
  
        def self.select_data_from
          "select symbol, Ask, Bid from "        
        end  
      end
    end
  end
end