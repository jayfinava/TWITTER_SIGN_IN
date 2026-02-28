# twitter_sign_in

[![Pub Version](https://img.shields.io/pub/v/twitter_sign_in?color=blue)](https://pub.dev/packages/twitter_sign_in)  
**📦 Live on pub.dev:** [pub.dev/packages/twitter_sign_in](https://pub.dev/packages/twitter_sign_in)

Flutter Twitter Login Plugin — cross-platform Twitter (X) sign-in with OAuth 1.0a and OAuth 2.0 PKCE.

## Requirements

- Dart SDK: `>=2.14.0 <4.0.0`
- Flutter: `>=3.35.0` (tested with Flutter 3.35.x)
- Android: minSdkVersion 17, AndroidX
- iOS: Swift, Xcode >= 11

## Twitter Configuration

[Twitter Developer](https://developer.twitter.com/)

Create a Twitter App and configure **Callback URLs** for this plugin.

Register a callback URL on Twitter Developer (e.g. `app_name://`).

If the API is not set to get email, `email` may be null. To use email, enable **Request email address from users** in the app settings.

## Android Configuration

### Add intent filters for incoming links

See [example/android/app/src/main/AndroidManifest.xml](https://github.com/jayfinava/twitter_sign_in/blob/master/example/android/app/src/main/AndroidManifest.xml) in the repo.

Replace the scheme with your Callback URL:

```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <!-- Use the scheme registered as Callback URL in your Twitter App -->
  <data android:scheme="example"
        android:host="gizmos" /> <!-- host is optional -->
</intent-filter>
```

### Flutter embedding (pre 1.12 projects)

If your project was created before Flutter 1.12, ensure Flutter embedding v2 is enabled. Add inside the `<application>` tag:

[Upgrading pre 1.12 Android projects](https://github.com/flutter/flutter/wiki/Upgrading-pre-1.12-Android-projects)

```xml
<meta-data
    android:name="flutterEmbedding"
    android:value="2" />
```

## iOS Configuration

### Add URL Scheme

See [example/ios/Runner/Info.plist](https://github.com/jayfinava/twitter_sign_in/blob/master/example/ios/Runner/Info.plist) in the repo.

Replace `example` with your Callback URL scheme:

```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleTypeRole</key>
    <string>Editor</string>
    <key>CFBundleURLName</key>
    <string></string>
    <key>CFBundleURLSchemes</key>
    <array>
      <!-- Registered Callback URL in Twitter App -->
      <string>example</string>
    </array>
  </dict>
</array>
```

## Example

A full sample app is in the [example](https://github.com/jayfinava/twitter_sign_in/tree/master/example) directory.

## Usage

Add `twitter_sign_in` to your app’s `pubspec.yaml`:

- **pub.dev:** [pub.dev/packages/twitter_sign_in#-installing-tab](https://pub.dev/packages/twitter_sign_in#-installing-tab)  
- [Flutter platform plugins](https://flutter.dev/platform-plugins/)

### Example

```dart
import 'package:flutter/material.dart';
import 'package:twitter_sign_in/twitter_login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Twitter Login App'),
        ),
        body: Center(
          child: TextButton(
            onPressed: () async {
              final twitterLogin = TwitterLogin(
                apiKey: 'xxxx',
                apiSecretKey: 'xxxx',
                redirectURI: 'example://',
              );
              final authResult = await twitterLogin.login();
              switch (authResult.status) {
                case TwitterLoginStatus.loggedIn:
                  // success
                  break;
                case TwitterLoginStatus.cancelledByUser:
                  // cancel
                  break;
                case TwitterLoginStatus.error:
                  // error
                  break;
              }
            },
            child: const Text('Login With Twitter'),
          ),
        ),
      ),
    );
  }
}
```

## Links

- **Package & docs:** [pub.dev/packages/twitter_sign_in](https://pub.dev/packages/twitter_sign_in)
- **Source:** [github.com/jayfinava/twitter_sign_in](https://github.com/jayfinava/twitter_sign_in)
- **Issues:** [github.com/jayfinava/twitter_sign_in/issues](https://github.com/jayfinava/twitter_sign_in/issues)
