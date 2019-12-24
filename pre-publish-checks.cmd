CALL "C:\Google\flutter\bin\cache\dart-sdk\bin\dartanalyzer" --options analysis_options.yaml .
CALL "C:\Google\flutter\bin\cache\dart-sdk\bin\dartfmt" . -w
CALL "C:\Google\flutter\bin\cache\dart-sdk\bin\pub" run test .
CALL cd example && "C:\Google\flutter\bin\cache\dart-sdk\bin\dart" test.dart
cd ../
REM pana --source path ./
