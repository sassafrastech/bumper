require "rspec"
require_relative "../lib/bumper"

RSpec.describe "bumper" do
  describe "increment" do
    it "return correct versions" do
      expect(increment("1", "major")).to eq "2.0"
      expect(increment("1.2", "major")).to eq "2.0"
      expect(increment("1.2.3", "major")).to eq "2.0"

      expect(increment("1", "minor")).to eq "1.1"
      expect(increment("1.2", "minor")).to eq "1.3"
      expect(increment("1.2.3", "minor")).to eq "1.3"

      expect(increment("1", "micro")).to eq "1.0.1"
      expect(increment("1.2", "micro")).to eq "1.2.1"
      expect(increment("1.2.3", "micro")).to eq "1.2.4"
    end
  end
end
