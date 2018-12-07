require "bigdecimal"

RSpec.describe H3Ruby do
  describe ".hello_world" do
    subject(:hello_world) { H3Ruby.hello_world }

    let(:result) { "hello world" }

    it "returns the expected result" do
      expect(hello_world).to eq(result)
    end
  end
end
