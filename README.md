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


## Samples: Google Pay App
```
Output for ./test/libflutter-gp.so: (Taken from Production Google Pay App)

dart run .\lib\main.dart .\test\libflutter-gp.so
Dart version: 3.8.0-24.0.dev
Dart SDK URL: https://dart.googlesource.com/sdk.git/+/refs/tags/3.8.0-24.0.dev?format=JSON
Time: Wed Jan 22 12:05:43 2025 -0800
Commit URL: https://dart.googlesource.com/sdk.git/+/refs/tags/3.8.0-24.0.dev?format=JSON
Commit Message: Version 3.8.0-24.0.dev

Manually Found out Flutter Commit w.r.t this:

https://github.com/flutter/flutter/commit/b2f515f45ef5a51362d9579fc4443cfe8f3ba387

Flutter Version: 3.30.0-x
```