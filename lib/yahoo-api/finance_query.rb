require 'json'
require 'net/http'

module Yahoo
  module Api  
    module Finance

      class Query                       
        attr_reader :response
        def initialize(tickers)
          @tickers = tickers                                   
          @response = Net::HTTP.get_response(QueryURI.build(tickers))
        end  

        def count
          parse_query_json['count']    
        end

        def quotes                                               
          add_datetime_to_quotes
        end

        private

        def get_quotes_as_array 
          quote_data = parse_query_json['results']['quote']
          quote_data = [quote_data] unless quote_data.class == Array                
          quote_data
        end     
  
        def add_datetime_to_quotes
          get_quotes_as_array.each do |quote|
            quote['quoted_at']= parse_query_json['created']
          end              
        end 
  
        def parse_query_json
          JSON.parse(@response.body)['query']
        end
      end

    end
  end
end
