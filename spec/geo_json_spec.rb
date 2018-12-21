RSpec.describe H3 do
  # http://geojson.io is helpful for setting up test fixtures
  describe ".geo_json_to_coordinates" do
    let(:input) do
      File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury.json"))
    end
    let(:coordinates) do
      [
        [
          [52.24630137198303, -1.7358398437499998],
          [52.05249047600099, -1.8923950195312498],
          [51.891749018068246, -1.56829833984375],
          [51.91208502557545, -1.27716064453125],
          [52.032218104145294, -1.19476318359375],
          [52.19413974159753, -1.24420166015625],
          [52.24125614966341, -1.5902709960937498],
          [52.24630137198303, -1.7358398437499998]
        ],
        [
          [52.12590076522272, -1.58203125],
          [52.12590076522272, -1.476287841796875],
          [52.075285904832334, -1.46392822265625],
          [52.06937709602395, -1.58203125],
          [52.12590076522272, -1.58203125]
        ],
        [
          [52.01531743663362, -1.4556884765625],
          [51.97642166216334, -1.483154296875],
          [51.96626938051444, -1.3677978515625],
          [52.0102459910103, -1.3568115234375],
          [52.01531743663362, -1.4556884765625]
        ]
      ]
    end

    subject(:geo_json_to_coordinates) { H3.geo_json_to_coordinates(input) }

    it { is_expected.to eq coordinates }

    context "when given a feature" do
      let(:input) do
        File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury_feature.json"))
      end

      it { is_expected.to eq coordinates }
    end

    context "when given a feature collection" do
      let(:input) do
        File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury_feature_collection.json"))
      end

      it { is_expected.to eq coordinates }
    end

    context "when given bad input" do
      let(:input) { "blah" }

      it "raises an error" do
        expect { geo_json_to_coordinates }.to raise_error(ArgumentError)
      end
    end
  end

  describe ".coordinates_to_geo_json" do
    let(:input) do
      [
        [
          [52.24630137198303, -1.7358398437499998],
          [52.05249047600099, -1.8923950195312498],
          [51.891749018068246, -1.56829833984375],
          [51.91208502557545, -1.27716064453125],
          [52.032218104145294, -1.19476318359375],
          [52.19413974159753, -1.24420166015625],
          [52.24125614966341, -1.5902709960937498],
          [52.24630137198303, -1.7358398437499998]
        ],
        [
          [52.12590076522272, -1.58203125],
          [52.12590076522272, -1.476287841796875],
          [52.075285904832334, -1.46392822265625],
          [52.06937709602395, -1.58203125],
          [52.12590076522272, -1.58203125]
        ],
        [
          [52.01531743663362, -1.4556884765625],
          [51.97642166216334, -1.483154296875],
          [51.96626938051444, -1.3677978515625],
          [52.0102459910103, -1.3568115234375],
          [52.01531743663362, -1.4556884765625]
        ]
      ]
    end
    let(:geojson) do
      File.read(File.join(File.dirname(__FILE__), "support/fixtures/banbury.json"))
    end

    subject(:coordinates_to_geo_json) { H3.coordinates_to_geo_json(input) }

    it { is_expected.to eq geojson }

    context "when given bad input" do
      let(:input) { "blah" }

      it "raises an error" do
        expect { coordinates_to_geo_json }.to raise_error(ArgumentError)
      end
    end

    context "when given nested bad input" do
      let(:input) { [[],[[[[]]]]] }

      it "raises an error" do
        expect { coordinates_to_geo_json }.to raise_error(ArgumentError)
      end
    end
  end
end
