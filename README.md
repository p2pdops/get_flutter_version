## Get Flutter Version from Production APK


> Not Fully implemented yet! 

> For now we can extract Dart Version from APK

> And manually check with Flutter Repo to find out which commit/version is used

> Sample libflutter.so files are present in ./test folder

### Steps To Get Flutter Version:

1. Git clone this project
2. Run `dart pub get`
3. Run `dart run ./lib/main.dart <path-to-libflutter.so>`

### Steps To Extract libflutter.so file from APK

1. Extract apk as ZIP using 7ZIP or any similar tool.
2. Navigate to <extracted-folder>/libs/armeabi-v7a/ or similar platform folder
3. You will find libflutter.so here.