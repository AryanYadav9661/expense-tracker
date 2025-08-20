
# Codemagic & Android embedding v2 — Guide & sanity checks

This repository includes a `codemagic.yaml` workflow designed to build a debug APK on Codemagic and to fail early if common Android embedding (v1) problems are found. Read below for what the workflow checks and how to fix common issues.

## What the CI checks do
1. Runs `flutter doctor -v` to surface obvious environment issues.
2. Looks for references to **`io.flutter.app`** inside `android/app/src/main/kotlin/` which is a common sign of the old Android v1 embedding. If found, the build exits early with an error and displays the offending file/lines.
3. Decodes a base64 `GOOGLE_SERVICES_JSON_BASE64` environment variable (if provided in Codemagic) into `android/app/google-services.json` before the build.
4. Runs `flutter pub get` and then `flutter build apk --debug`.

## Avoiding the "Android v1 embedding" error
If you previously saw an error like **"Build failed due to use of deleted Android v1 embedding"** — this project includes correct MainActivity templates, but CI still checks for any stray v1 references.

### Correct (embedding v2) Kotlin MainActivity example — **this is what you should have**
```kotlin
package com.yourapp.package

import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    // For embedding v2, do NOT call GeneratedPluginRegistrant here
}
```

## If CI fails with embedding error — how to fix quickly
1. Open the file(s) flagged by the CI (path shown in the log). They are usually under `android/app/src/main/kotlin/your/package/`.
2. Replace the imports and class to the embedding v2 style shown above. Remove any `GeneratedPluginRegistrant.registerWith(...)` calls.
3. Commit and push — Codemagic will re-run the workflow.

## How to supply Firebase / secrets safely
- **Do not commit** `google-services.json` into a public repo. Instead encode it as base64 and add it as a secure environment variable in Codemagic named `GOOGLE_SERVICES_JSON_BASE64`.
  - On your machine (Git Bash or Linux):
    ```
    base64 google-services.json > gs.b64
    # then copy the contents of gs.b64 to the Codemagic secure env variable
    ```
  - The `codemagic.yaml` will decode that file into `android/app/google-services.json` before building.

## Keystore & release builds (optional)
For Play Store release you must sign the app. You can upload a keystore in Codemagic UI or store it as a secure base64 variable and decode it in the build script. I can add a `release` workflow once you provide the keystore or choose to use Play App Signing.

