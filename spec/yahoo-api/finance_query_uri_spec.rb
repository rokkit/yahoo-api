require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Yahoo::Api::Finance::QueryURI do 
  shared_examples "valid finance URI" do |valid_ticker_string|
    it "returns a URI object for the Yahoo Finance Query" do
      subject.should be_instance_of URI::HTTP 
    end

    it "should be a Yahoo! API URL" do
      subject.scheme.should == "http"    
      subject.host.should == "query.yahooapis.com"
      subject.path.should == "/v1/public/yql"
    end

    it "should parse the correct URL string" do
      expected = "http://query.yahooapis.com/v1/public/yql?q=select%20symbol,%20Ask,%20Bid%20from%20yahoo.finance.quotes%20where%20symbol%20in%20(#{valid_ticker_string})&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys"
      subject.to_s.should == expected
    end        
  end

  context "with a single ticker provided" do
    subject { Yahoo::Api::Finance::QueryURI.build(["BP.L"]) }   
    include_examples "valid finance URI", '%22BP.L%22'
  end  

  context "with three tickers provided" do
    subject { Yahoo::Api::Finance::QueryURI.build(["BP.L","BLT.L","GSK.L"]) }
    include_examples "valid finance URI", 
      '%22BP.L%22,%20%22BLT.L%22,%20%22GSK.L%22'
  end                                 
  
  context "with invalid tickers provided" do
    it "raises an exception with no ticker array" do
      expect {Yahoo::Api::Finance::QueryURI.build()}.
        to raise_error(ArgumentError, "wrong number of arguments (0 for 1)")
    end
    
    shared_examples "invalid ticker data type" do |data_type|
      it "raises an exception when a #{data_type.class} is provided" do
        expect {Yahoo::Api::Finance::QueryURI.build(data_type)}.
          to raise_error(ArgumentError, "Tickers must be supplied in an Array")
      end      
    end          

    include_examples "invalid ticker data type", "BP.L"
    include_examples "invalid ticker data type", 1
    include_examples "invalid ticker data type", {}
    include_examples "invalid ticker data type", {ticker:"BP.L"}    

    it "raises an exception with an empty ticker array" do
      expect {Yahoo::Api::Finance::QueryURI.build([])}. 
        to raise_error(ArgumentError, "At least one ticker must be supplied")
    end
    
    it "raises an exception with an array of blank tickers" do
      expect {Yahoo::Api::Finance::QueryURI.build(["",""])}. 
        to raise_error(ArgumentError, "At least one ticker must be supplied")
    end
  end
end
