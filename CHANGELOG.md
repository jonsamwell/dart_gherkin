## [1.0.6] - 25/08/2019
* Added 'Scenario Outline' and 'Example' functionality (see: example/features/calculator_scenerio_outline_example.feature)
* Fixed issue with parsing a negative number when using the '{num}' parameter in a step

## [1.0.5] - 23/08/2019
* Fixed complex co-variant issue with step code definitions
* Fixed parsing issue when Background block has no name

## [1.0.4] - 11/07/2019
* Fix for dart analysis covariance complaints with step definition input generic types

## [1.0.3] - 20/06/2019
* Fix dependencies conflict with flutter_test and flutter_driver

## [1.0.2] - 20/06/2019
* Updated dependencies

## [1.0.1] - 20/06/2019
* Added the ability to add attachments which gives the ability to set screenshots or other data against the scenerio
* Added before & after hooks for step execution

## [1.0.0] - 04/06/2019
* Fixed throw Error sub types not getting handle properly and halting test execution fixes https://github.com/jonsamwell/dart_gherkin/issues/2
* Fixed linter warnings
* Made v1 release as api's are stable

## [0.0.4] - 23/04/2019
* Exported missing step and process classes
* Added JSON reporter that can be use to generate HTML reports (PR from @Holloweye)

## [0.0.3] - 15/03/2019
* Fixed up more issues with pubspec.yaml

## [0.0.2] - 15/03/2019
* Fixed up issues with pubspec.yaml

## [0.0.1] - 15/03/2019
* Migration of core Gherkin code from flutter_gherkin package (https://github.com/jonsamwell/flutter_gherkin) so there is not Flutter specific dependencies on the core Gherkin functionality.
