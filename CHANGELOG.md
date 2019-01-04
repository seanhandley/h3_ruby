# Change Log

All notable changes to this project will be documented in this file.

This project adheres to [Semantic Versioning](http://semver.org/).

We track the MAJOR and MINOR version levels of Uber's H3 project (https://github.com/uber/h3) but maintain independent patch levels so we can make small fixes and non breaking changes.

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