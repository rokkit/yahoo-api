require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Yahoo::Api::Finance::Query do
  
  let(:requested_data) { ['quoted_at', 'symbol', 'Ask', 'Bid'] }
  
  shared_examples "successful queries" do |tickers|
    
    subject { Yahoo::Api::Finance::Query.new(tickers) }
    
    its(:response) { should be_kind_of Net::HTTPSuccess }
    its(:count) { should == tickers.size }
    its(:quotes) { should be_instance_of Array }
    its(:number_of_quotes) { should == tickers.size }

    it "wraps each quote in a Hash" do
      subject.quotes.each do |quote|
        quote.should be_instance_of Hash
      end
    end

    it "each quote contain the requested data" do
      subject.quotes.each do |quote|
        requested_data.each do |data|
          quote.has_key?(data).should be_true          
        end
      end
    end        

    it "none of the requested data is empty" do
      subject.quotes.each do |quote|                         
        requested_data.each do |data|
          quote[data].should_not == ""        
        end
      end
    end        
  end
  
  context "of a valid single asset" do
    use_vcr_cassette "single_stock_query", :record => :new_episodes  
    include_examples "successful queries", ["BP.L"]

    it "the quote is for the requested ticker" do
      subject.quotes.first['symbol'].should == 'BP.L'
    end    
  end

  context "of two valid assets" do
    use_vcr_cassette "multi_stock_query", :record => :new_episodes
    include_examples "successful queries", ["BP.L", "BLT.L"]

    it "the quotes are for the requested tickers" do
      subject.quotes.first['symbol'].should == 'BP.L'
      subject.quotes.last['symbol'].should == 'BLT.L'
    end    
  end
  
  context "of a query with no defined assets" do
    it "raises an exception with argument" do
      expect {Yahoo::Api::Finance::Query.new()}.
        to raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "raises an exception with an asset outside an array" do
      expect {Yahoo::Api::Finance::Query.new("BP.L")}.
        to raise_error(ArgumentError, "Tickers must be supplied in an Array")
    end

    it "raises an exception with an empty ticker array" do
      expect {Yahoo::Api::Finance::Query.new([])}. 
        to raise_error(ArgumentError, "At least one ticker must be supplied")
    end
  end

  context "of a query with erroneous tickers" do
    use_vcr_cassette "error_stock_query", :record => :new_episodes
    subject { Yahoo::Api::Finance::Query.new(["BP"]) }
    
    it "returns a set of quotes" do
      subject.count.should == 1
    end

    it "the quote prices have null values" do
      subject.quotes.first['Ask'].should be_nil
      subject.quotes.first['Bid'].should be_nil
    end
  end
        
end