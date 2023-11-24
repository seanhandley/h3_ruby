# Change Log

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/).

We track the MAJOR and MINOR version levels of Uber's H3 project (https://github.com/uber/h3) but maintain independent patch levels so we can make small fixes and non breaking changes.

## [3.7.3] - Unreleased
### Fixed
- `H3.from_string(nil)` should not crash

## [3.7.2] - 2020-07-17
### Fixed
- kRing of invalid indexes should not crash.

## [3.7.1] - 2020-10-7
### Added
- Area and haversine distance functions:
    - `cellAreaRads2`
    - `cellAreaKm2`
    - `cellAreaM2`
    - `pointDistRads`
    - `pointDistKm`
    - `pointDistM`
    - `exactEdgeLengthRads`
    - `exactEdgeLengthKm`
    - `exactEdgeLengthM`
 
### Changed
- Speeds up `getH3UnidirectionalEdgeBoundary` by about 3x.

### Fixed
- Finding invalid edge boundaries should not crash. 

## [3.6.4] - 2020-7-2
### Changed
- Reinstate new `polyfill` algorithm for up to 3x perf boost.

## [3.6.2] - 2020-1-8
### Changed
- Revert new polyfill algorithm until reported issues are fixed.
- Remove deprecated methods: (#66)

## [3.6.1] - 2019-11-23
### Fixed
- `compact` handles zero length input correctly.
- `bboxHexRadius` scaling factor adjusted to guarantee containment for `polyfill`.
- `polyfill` new algorithm for up to 3x perf boost.
- Fix CMake targets for KML generation.

## [3.6.0] - 2019-8-14
### Added
- `center_child` method to find center child at given resolution (#62).
- `pentagons` (and `pentagon_count`) method to find pentagons at given resolution (#62).

## [3.5.1] - 2019-8-5
### Changed
- Renamed 26 methods to be more idiomatic with Ruby conventions. The old names are deprecated until 2020 when they will be removed (#59).
- Added Zeitwerk as the code loader.

## [3.5.0] - 2019-7-25
### Added
- `h3_faces` and `max_face_count` support (#56)
### Changed
- New CMake options to prevent unnecessary building of filter apps and benchmarks.

## [3.4.4] - 2019-6-4
### Changed
- Internal h3 bugfixes.

## [3.4.0] - 2019-1-24
### Added
- `res_0_indexes` and `res_0_index_count` support (#51).

## [3.3.1] - 2019-1-4
### Added
- `h3_line` and `h3_line_size` support (#43).
### Changed
- Use FFI types to enforce sane resolution values (#41).
- Internal refactoring (#44).
- Include and compile H3 when gem installs (#45). The gem will use a locally built .so and ignore any H3 versions that are installed on the system. This is achieved by submoduling the H3 C code and updating to the matching version tag.
- Various documentation corrections.

## [3.3.0] - 2019-1-4 (yanked)

## [3.2.0] - 2018-12-21

Initial release.
