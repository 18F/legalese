require_relative "../scan"

describe Scanner do

  let(:good_data_file) { File.expand_path '../../test_urls_good.txt', __FILE__ } 
  let(:bad_data_file) { File.expand_path '../..//test_urls_bad.txt', __FILE__ } 
  let(:good_scan) { Scanner.new(good_data_file) }
  let(:bad_scan) { Scanner.new(bad_data_file) }

  before :each do
    $stdout = StringIO.new
  end

  context "a good data file" do
    it "parses urls file when initialized, and outputs privacy/ToS info" do
      good_scan.run
      expect($stdout.string).to include "http://www.example.org"
      expect($stdout.string).to include "privacy policy:"
      expect($stdout.string).to include "ToS:"
    end
  end

  context "a bad data file" do
    it "parses urls file when initialized, and displays an error for erronious URLs" do
      bad_scan.run
      expect($stdout.string).to include "htttp://www.blarg.com"
      expect($stdout.string).to include "Url htttp://www.blarg.com caused an exception: No such file or directory @ rb_sysopen - htttp://www.blarg.com"
    end

    it "doesn't output text about privacy policy/ToS for bad URLs" do
      bad_scan.run
      expect($stdout.string).to_not include "privacy policy:"
    end
  end

end