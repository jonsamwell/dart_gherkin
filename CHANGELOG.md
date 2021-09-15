## [2.0.5+1] - 15/09/2021

* Fixed first/last flag on `FeatureFileVisitor`
* Fixed find feature files regex pattern fdr windows in example project

## [2.0.5] - 15/09/2021

* Added json reporter test case for multi-scenario
* Added first/last flag on `FeatureFileVisitor`

## [2.0.4] - 21/06/2021

* Fixed late initialization error when invoking hooks

## [2.0.3] - 01/06/2021

* Updated float parameter parser so an exception is not thrown during parsing

## [2.0.2] - 25/05/2021

* Fix #45 executing feature files outside of the current working directory

## [2.0.1] - 02/05/2021

* BREAKING CHANGE: `TestFailure` is no longer thrown when an `expect` fails. Instead, use `GherkinTestFailure` when catching errors (i.e. replace `on TestFailure catch` with `on GherkinTestFailure catch`) (#37).

## [2.0.0] - 15/04/2021

NOTE: Massive changes here due to the migration to null-safety and laying the foundation for code generation to enable testing Flutter apps using the `integration_test` package.

* BREAKING CHANGE: Migration to null-safety, some parameter have become nullable which may lead to subtle unexpected results. Please file any issue you come across.
* BREAKING CHANGE: `Table` has been renamed to `GherkinTable` to avoid naming clashes
* BREAKING CHANGE: Null-safety updated all libs to their stable null-safety releases
* BREAKING CHANGE: `exitAfterTestRun` configuration option has been removed as it need to import `dart:io` which is not available under certain environments (dartjs for example).
* BREAKING CHANGE: `exitAfterTestFailed` configuration option renamed to `stopAfterTestFailed`
* BREAKING CHANGE: `Reporter->onException()` exception parameter is now an object rather than an exception
* POSSIBLE BREAKING CHANGE: Feature file discovery has been refactored to abstract it from the external `Glob` dependency.  It now support the three native dart `Patterns` (String, RegExp & Glob).  There is potential here your patterns may not work anymore due as the default `IoFeatureFileAccessor` assumes the current directory is the working directory to search from. Thanks to @marcin-jelenski for the PR
* Execution order can now be sorted alphabetically to ensure a consistent order thanks to @bartonhammond
* Fixed #22 Tags are not taking into account after an `Example` block
* Fixed #23: Multiline strings to support YAML format thanks to @tshedor for the PR!
* Fixed #29: French keyword "Lorsqu'il" makes parser crash

## [1.1.10] - 06/01/2021

* Scenario outline examples can now include variables which are replace to create more explicit scenario names, thanks to @irundaia for the PR!

## [1.1.9] - 24/11/2020

* Added the ability to have multiple example blocks with tags per scenario outline

## [1.1.8+5] - 26/10/2020

* Ensured world is disposed after last hooks are run

## [1.1.8+4] - 20/09/2020

* Fixes issues with function style step definitions not having access to the default timeout period https://github.com/jonsamwell/flutter_gherkin/issues/81

## [1.1.8+3] - 05/08/2020

* Fixes issues with non-alpha-numeric characters in multiline strings and comments https://github.com/jonsamwell/dart_gherkin/issues/14 https://github.com/jonsamwell/dart_gherkin/issues/15 https://github.com/jonsamwell/dart_gherkin/issues/16

## [1.1.8+2] - 17/07/2020

* Added shorthand steps `given(), when1(), then2() etc` to reduce boilerplate code and the need to create a class for every step.  Heavily inspired from the excellent ideas in https://github.com/technogise/flutter_gherkin_addons
* Added a default static method to the `TestConfiguration` class to again reduce common boilerplate configuration

## [1.1.8+1] - 11/05/2020

* Fixed issue with `JsonReporter` that would throw an error if an exception was logged before any scenarios have run

## [1.1.8] - 10/05/2020

* Fixed issue with `JsonReporter` that would throw an error if an exception was logged before any features have run

## [1.1.7] - 04/03/2020

* Pass scenario tags into scenario level hooks to allow for custom actions - this is a breaking changed to the `Hook` interface and hook implementations will need to be updated to cope with the extra parameter

## [1.1.6+4] - 03/02/2020

* Fixed issue with empty cells in scenario table parameters
* Fixed issue with a leading comment in feature files

## [1.1.6+3] - 14/01/2020

* Fixed issue with scenario not being parsed correctly when under a scenario outline in the same feature file

## [1.1.6+2] - 13/01/2020

* Fixed issue with non-capturing regex groups in step patterns and made the well known pluralization parameter '(s)' a non-capturing regex group

## [1.1.6+1] - 10/01/2020

* Ensured async errors when executing a scenario do not cause the whole test run to crash from an unhandled exception or error - each scenario is now run in its own zone

## [1.1.6] - 10/01/2020

* Ensured async errors when executing a scenario do not cause the whole test run to crash from an unhandled exception - each scenario is now run in its own zone
* Surfaced library exception types

## [1.1.5+2] - 07/01/2020

* Ensured stack traces are propagated when an error occurs during test execution
* Fixed error with message from GherkinStepNotDefinedException that would include the Gherkin keyword in the example regex pattern

## [1.1.5+1] - 24/12/2019

* Require Dart 2.3.0 or greater
* Fixed various analysis errors

## [1.1.5] - 05/12/2019

* Fixed lint errors

## [1.1.4] - 05/12/2019

* Allowed comments at the end of a table line
* Moved `onBeforeScenario` hook to run after the scenario world has been created to allow the hook to access the world

## [1.1.3] - 27/09/2019

* Relaxed constraint on the test lib

## [1.1.2] - 22/09/2019

* Fixed issue with scenario outline name being reported incorrectly

## [1.1.1] - 22/09/2019

* Added `asMap` helper method to a table so a table can be represented as a map to help with serialization to types

## [1.1.0] - 20/09/2019

* Implemented languages - features can now be written in different languages / dialects! See https://cucumber.io/docs/gherkin/reference/#overview for supported dialects.

## [1.0.12] - 18/09/2019

* Fixed version constraint analysis errors

## [1.0.11] - 18/09/2019

* Fixed path dependency to be backwards compatible with flutter_driver

## [1.0.10] - 18/09/2019

* Updated test dependency

## [1.0.9] - 16/09/2019

* Fixed issue where tags were not allowed on features
* Refactor of the way tags are handled so they are inherited by children if required (see https://cucumber.io/docs/cucumber/api/#tag-inheritance)
* Fixed the JSON reporter so that is adheres to to the cucumber json reporter spec.

## [1.0.8] - 13/09/2019

* Fix an issue where line terminators where not allowed in well known {string} parameters

## [1.0.7] - 25/08/2019

* Fix path dependency resolution

## [1.0.6] - 25/08/2019

* Added 'Scenario Outline' and 'Example' functionality (see: example/features/calculator_scenario_outline_example.feature)
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

* Added the ability to add attachments which gives the ability to set screenshots or other data against the scenario
* Added before & after hooks for step execution

## [1.0.0] - 04/06/2019

* Fixed throw Error sub types not getting handle properly and halting test execution fixes https://github.com/jonsamwell/dart_gherkin/issues/2
* Fixed linter warnings
* Made v1 release as apis are stable

## [0.0.4] - 23/04/2019

* Exported missing step and process classes
* Added JSON reporter that can be use to generate HTML reports (PR from @Holloweye)

## [0.0.3] - 15/03/2019

* Fixed up more issues with pubspec.yaml

## [0.0.2] - 15/03/2019

* Fixed up issues with pubspec.yaml

## [0.0.1] - 15/03/2019

* Migration of core Gherkin code from flutter_gherkin package (https://github.com/jonsamwell/flutter_gherkin) so there is not Flutter specific dependencies on the core Gherkin functionality.
