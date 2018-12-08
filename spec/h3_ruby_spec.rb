require "bigdecimal"

RSpec.describe H3Ruby do
  describe ".hello_world" do
    subject(:hello_world) { H3Ruby.hello_world }

    let(:result) { "hello world" }

    it "returns the expected result" do
      expect(hello_world).to eq(result)
    end
  end

  describe ".max_kring_size" do
    subject(:max_kring_size) { H3Ruby.max_kring_size(2) }

    let(:result) { 19 }

    it "returns the expected result" do
      expect(max_kring_size).to eq(result)
    end
  end
end
