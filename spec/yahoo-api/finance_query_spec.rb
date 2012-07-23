require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Yahoo::Api::Finance::Query do 
  shared_examples "successful queries" do |tickers|
    subject { Yahoo::Api::Finance::Query.new(tickers) }
    
    it "creates a new Yahoo API query" do
      subject.should be_true
    end

    it "returns a HTTP success response" do
      subject.response.should be_kind_of Net::HTTPSuccess
    end

    it "reports #{tickers.size} results" do
      subject.count.should == tickers.size
    end

    it "returns an array of #{tickers.size} quotes" do
      subject.quotes.should be_instance_of Array
      subject.quotes.size.should == tickers.size
    end

    it "wraps each quote in a Hash" do
      subject.quotes.each do |quote|
        quote.should be_instance_of Hash
      end
    end

    it "each quote contain the requested data" do
      subject.quotes.each do |quote|
        quote.has_key?('quoted_at').should be_true
        quote.has_key?('symbol').should be_true
        quote.has_key?('Ask').should be_true
        quote.has_key?('Bid').should be_true        
      end
    end        

    it "none of the requested data is empty" do
      subject.quotes.each do |quote|
        quote['quoted_at'].should_not == ""
        quote['symbol'].should_not == ""
        quote['Ask'].should_not == ""
        quote['Bid'].should_not == ""        
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
end

describe "Integration between the Query and URL" do
  context "of a query with no assets" do
    it "raises an exception with no ticker array" do
      expect {Yahoo::Api::Finance::Query.new()}.
        to raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end

    it "raises an exception with an empty ticker array" do
      expect {Yahoo::Api::Finance::Query.new([])}. 
        to raise_error(ArgumentError, "At least one ticker must be supplied")
    end
  end      
end