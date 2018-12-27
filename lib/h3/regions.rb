module H3
  # Region functions.
  #
  # @see https://uber.github.io/h3/#/documentation/api-reference/regions
  module Regions
    extend H3::Bindings::Base

    # Derive the maximum number of H3 indexes that could be returned from the input.
    #
    # @param [String, Array<Array<Array<Float>>>] geo_polygon Either a GeoJSON string
    # or a coordinates nested array.
    # @param [Integer] resolution Resolution.
    #
    # @example Derive maximum number of hexagons for given GeoJSON document.
    #   geo_json = "{\"type\":\"Polygon\",\"coordinates\":[[[-1.735839843749998,52.24630137198303],
    #     [-1.8923950195312498,52.05249047600099],[-1.56829833984375,51.891749018068246],
    #     [-1.27716064453125,51.91208502557545],[-1.19476318359375,52.032218104145294],
    #     [-1.24420166015625,52.19413974159753],[-1.5902709960937498,52.24125614966341],
    #     [-1.7358398437499998,52.24630137198303]],[[-1.58203125,52.12590076522272],
    #     [-1.476287841796875,52.12590076522272],[-1.46392822265625,52.075285904832334],
    #     [-1.58203125,52.06937709602395],[-1.58203125,52.12590076522272]],
    #     [[-1.4556884765625,52.01531743663362],[-1.483154296875,51.97642166216334],
    #     [-1.3677978515625,51.96626938051444],[-1.3568115234375,52.0102459910103],
    #     [-1.4556884765625,52.01531743663362]]]}"
    #   H3.max_polyfill_size(geo_json, 9)
    #   33391
    #
    # @example Derive maximum number of hexagons for a nested array of coordinates.
    #   coordinates = [
    #     [
    #       [52.24630137198303, -1.7358398437499998], [52.05249047600099, -1.8923950195312498],
    #       [51.891749018068246, -1.56829833984375], [51.91208502557545, -1.27716064453125],
    #       [52.032218104145294, -1.19476318359375], [52.19413974159753, -1.24420166015625],
    #       [52.24125614966341, -1.5902709960937498], [52.24630137198303, -1.7358398437499998]
    #     ],
    #     [
    #       [52.12590076522272, -1.58203125], [52.12590076522272, -1.476287841796875],
    #       [52.075285904832334, -1.46392822265625], [52.06937709602395, -1.58203125],
    #       [52.12590076522272, -1.58203125]
    #     ],
    #     [
    #       [52.01531743663362, -1.4556884765625], [51.97642166216334, -1.483154296875],
    #       [51.96626938051444, -1.3677978515625], [52.0102459910103, -1.3568115234375],
    #       [52.01531743663362, -1.4556884765625]
    #     ]
    #   ]
    #   H3.max_polyfill_size(coordinates, 9)
    #   33391
    #
    # @return [Integer] Maximum number of hexagons needed to polyfill given area.
    def max_polyfill_size(geo_polygon, resolution)
      geo_polygon = geo_json_to_coordinates(geo_polygon) if geo_polygon.is_a?(String)
      Bindings::Private.max_polyfill_size(build_polygon(geo_polygon), resolution)
    end

    # Derive a list of H3 indexes that fall within a given geo polygon structure.
    #
    # @param [String, Array<Array<Array<Float>>>] geo_polygon Either a GeoJSON string or a
    # coordinates nested array.
    # @param [Integer] resolution Resolution.
    #
    # @example Derive hexagons for given GeoJSON document.
    #   geo_json = "{\"type\":\"Polygon\",\"coordinates\":[[[-1.735839843799998,52.24630137198303],
    #     [-1.8923950195312498,52.05249047600099],[-1.56829833984375,51.891749018068246],
    #     [-1.27716064453125,51.91208502557545],[-1.19476318359375,52.032218104145294],
    #     [-1.24420166015625,52.19413974159753],[-1.5902709960937498,52.24125614966341],
    #     [-1.7358398437499998,52.24630137198303]],[[-1.58203125,52.12590076522272],
    #     [-1.476287841796875,52.12590076522272],[-1.46392822265625,52.075285904832334],
    #     [-1.58203125,52.06937709602395],[-1.58203125,52.12590076522272]],
    #     [[-1.4556884765625,52.01531743663362],[-1.483154296875,51.97642166216334],
    #     [-1.3677978515625,51.96626938051444],[-1.3568115234375,52.0102459910103],
    #     [-1.4556884765625,52.01531743663362]]]}"
    #   H3.polyfill(geo_json, 5)
    #   [
    #     599424968551301119, 599424888020664319, 599424970698784767, 599424964256333823,
    #     599424969625042943, 599425001837297663, 599425000763555839
    #   ]
    #
    # @example Derive hexagons for a nested array of coordinates.
    #   coordinates = [
    #     [
    #       [52.24630137198303, -1.7358398437499998], [52.05249047600099, -1.8923950195312498],
    #       [51.891749018068246, -1.56829833984375], [51.91208502557545, -1.27716064453125],
    #       [52.032218104145294, -1.19476318359375], [52.19413974159753, -1.24420166015625],
    #       [52.24125614966341, -1.5902709960937498], [52.24630137198303, -1.7358398437499998]
    #     ],
    #     [
    #       [52.12590076522272, -1.58203125], [52.12590076522272, -1.476287841796875],
    #       [52.075285904832334, -1.46392822265625], [52.06937709602395, -1.58203125],
    #       [52.12590076522272, -1.58203125]
    #     ],
    #     [
    #       [52.01531743663362, -1.4556884765625], [51.97642166216334, -1.483154296875],
    #       [51.96626938051444, -1.3677978515625], [52.0102459910103, -1.3568115234375],
    #       [52.01531743663362, -1.4556884765625]
    #     ]
    #   ]
    #   H3.polyfill(coordinates, 5)
    #   [
    #     599424968551301119, 599424888020664319, 599424970698784767, 599424964256333823,
    #     599424969625042943, 599425001837297663, 599425000763555839
    #   ]
    #
    # @return [Array<Integer>] Hexagons needed to polyfill given area.
    def polyfill(geo_polygon, resolution)
      geo_polygon = geo_json_to_coordinates(geo_polygon) if geo_polygon.is_a?(String)
      max_size = max_polyfill_size(geo_polygon, resolution)
      out = FFI::MemoryPointer.new(H3_INDEX, max_size)
      Bindings::Private.polyfill(build_polygon(geo_polygon), resolution, out)
      out.read_array_of_ulong_long(max_size).reject(&:zero?)
    end

    # Derive a nested array of coordinates from a list of H3 indexes.
    #
    # @param [Array<Integer>] h3_indexes A list of H3 indexes.
    #
    # @example Get a set of coordinates from a given list of H3 indexes.
    #   h3_indexes = [
    #     599424968551301119, 599424888020664319, 599424970698784767,
    #     599424964256333823, 599424969625042943, 599425001837297663,
    #     599425000763555839
    #   ]
    #   H3.h3_set_to_linked_geo(h3_indexes)
    #   [
    #     [
    #       [52.24425364171531, -1.6470570189756442], [52.19515282473624, -1.7508281227260887],
    #       [52.10973325363767, -1.7265910686763437], [52.06042870859474, -1.8301115887419024],
    #       [51.97490199314513, -1.8057974545517919], [51.9387204737266, -1.6783497689296265],
    #       [51.853128001893175, -1.654344796003053], [51.81682604752331, -1.5274195136674955],
    #       [51.866019925789956, -1.424329996292339], [51.829502535462176, -1.2977583914075301],
    #       [51.87843896218677, -1.1946402363628545], [51.96394676922824, -1.21787542551618],
    #       [52.01267958543637, -1.1145114691876956], [52.09808058649905, -1.1376655003242908],
    #       [52.134791926560325, -1.26456988729442], [52.22012854584846, -1.2880298658365215],
    #       [52.25672060485973, -1.4154623025177386], [52.20787927927604, -1.5192658757247421]
    #     ]
    #   ]
    #
    # @return [Array<Array<Array<Float>>>] Nested array of coordinates.
    def h3_set_to_linked_geo(h3_indexes)
      h3_indexes = h3_indexes.uniq
      linked_geo_polygon = LinkedGeoPolygon.new
      FFI::MemoryPointer.new(H3_INDEX, h3_indexes.size) do |hexagons_ptr|
        hexagons_ptr.write_array_of_ulong_long(h3_indexes)
        Bindings::Private.h3_set_to_linked_geo(hexagons_ptr, h3_indexes.size, linked_geo_polygon)
      end

      extract_linked_geo_polygon(linked_geo_polygon).first
    end

    private

    def extract_linked_geo_polygon(linked_geo_polygon)
      return if linked_geo_polygon.null?

      geo_polygons = [linked_geo_polygon]

      until linked_geo_polygon[:next].null?
        geo_polygons << linked_geo_polygon[:next]
        linked_geo_polygon = linked_geo_polygon[:next]
      end

      geo_polygons.map(&method(:extract_geo_polygon))
    end

    def extract_geo_polygon(geo_polygon)
      extract_linked_geo_loop(geo_polygon[:first]) unless geo_polygon[:first].null?
    end

    def extract_linked_geo_loop(linked_geo_loop)
      return if linked_geo_loop.null?

      geo_loops = [linked_geo_loop]

      until linked_geo_loop[:next].null?
        geo_loops << linked_geo_loop[:next]
        linked_geo_loop = linked_geo_loop[:next]
      end

      geo_loops.map(&method(:extract_geo_loop))
    end

    def extract_geo_loop(geo_loop)
      extract_linked_geo_coord(geo_loop[:first]) unless geo_loop[:first].null?
    end

    def extract_linked_geo_coord(linked_geo_coord)
      return if linked_geo_coord.null?

      geo_coords = [linked_geo_coord]

      until linked_geo_coord[:next].null?
        geo_coords << linked_geo_coord[:next]
        linked_geo_coord = linked_geo_coord[:next]
      end

      geo_coords.map(&method(:extract_geo_coord))
    end

    def extract_geo_coord(geo_coord)
      [
        rads_to_degs(geo_coord[:vertex][:lat]),
        rads_to_degs(geo_coord[:vertex][:lon])
      ]
    end

    def build_polygon(input)
      outline, *holes = input
      geo_polygon = GeoPolygon.new
      geo_polygon[:geofence] = build_geofence(outline)
      len = holes.count
      geo_polygon[:num_holes] = len
      geofences = holes.map(&method(:build_geofence))
      ptr = FFI::MemoryPointer.new(GeoFence, len)
      fence_structs = 0.upto(geofences.count).map do |i|
        GeoFence.new(ptr + i * GeoFence.size)
      end
      geofences.each_with_index do |geofence, i|
        fence_structs[i][:num_verts] = geofence[:num_verts]
        fence_structs[i][:verts] = geofence[:verts]
      end
      geo_polygon[:holes] = ptr
      geo_polygon
    end

    def build_geofence(input)
      geo_fence = GeoFence.new
      len = input.count
      geo_fence[:num_verts] = len
      ptr = FFI::MemoryPointer.new(GeoCoord, len)
      coords = 0.upto(len).map do |i|
        GeoCoord.new(ptr + i * GeoCoord.size)
      end
      input.each_with_index do |(lat, lon), i|
        coords[i][:lat] = degs_to_rads(lat)
        coords[i][:lon] = degs_to_rads(lon)
      end
      geo_fence[:verts] = ptr
      geo_fence
    end
  end
end
