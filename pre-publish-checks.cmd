CALL dart analyze
CALL dart format . --fix
CALL dart run test .
CALL cd example && dart test.dart
cd ../
