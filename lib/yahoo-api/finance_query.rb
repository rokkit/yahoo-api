require 'json'
require 'net/http'

module Yahoo
  module Api  
    module Finance

      class Query                       
        attr_reader :response
        def initialize(tickers, fields)
          @tickers = tickers                                   
          @response = Net::HTTP.get_response(QueryURI.build(tickers, fields))
        end  

        def count
          parse_response_json['count']    
        end      
        
        alias :number_of_quotes :count

        def quotes                                               
          add_datetime_to_quotes
        end

        def parse_response_json
          JSON.parse(@response.body)['query']
        end

        def get_quotes_as_array 
          quote_data = parse_response_json['results']['quote']
          quote_data = [quote_data] unless quote_data.class == Array                
          quote_data
        end     
  
        def add_datetime_to_quotes
          get_quotes_as_array.each do |quote|
            quote['quoted_at']= parse_response_json['created']
          end              
        end
          
        private :get_quotes_as_array, 
                :add_datetime_to_quotes, 
                :parse_response_json

      end

    end
  end
end
