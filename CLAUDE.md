# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project context

"Little Lemon" iOS app — the capstone project for the Meta iOS Developer Professional Certificate. The repo is currently the **untouched Xcode SwiftUI scaffold** (`ContentView` is still the "Hello, world!" globe template); essentially all capstone functionality is still to be built.

The course defines the target feature set, so treat these as the app's requirements:

- Onboarding/registration flow for new users, with persisted user state
- Navigation flow between screens (onboarding → menu → item detail → profile)
- Fetch menu data from the network and store it in a local database
- Render the menu with sorting and filtering (e.g. search + category filters)
- UI styled to the Little Lemon brand from Figma wireframes

There is no README, no design assets beyond an empty asset catalog, and no dependency manager — no SPM packages, no CocoaPods/Carthage. Prefer first-party frameworks (SwiftUI, SwiftData or Core Data, `URLSession`) over adding dependencies.

## Commands

Build (verified working):

```bash
xcodebuild -project LittleLemonIos.xcodeproj -scheme LittleLemonIos \
  -destination 'platform=iOS Simulator,name=iPhone 17' build
```

Add `-quiet` for a compile-error-only check. Pipe to `tail` — full xcodebuild output is very long.

Run in the simulator:

```bash
xcrun simctl boot 'iPhone 17' && open -a Simulator
xcrun simctl install booted \
  ~/Library/Developer/Xcode/DerivedData/LittleLemonIos-*/Build/Products/Debug-iphonesimulator/LittleLemonIos.app
xcrun simctl launch booted com.example.LittleLemonIos
```

**Destination constraint:** the deployment target is iOS 26.5, so only simulators on the iOS 26.5 runtime can be used. The iOS 18.0 runtime is also installed on this machine but is too old for this target — a `-destination` resolving to it fails.

**Tests:** there is no test target. `xcodebuild test` fails until one is added via Xcode (File → New → Target → Unit Testing Bundle). Once it exists:

```bash
xcodebuild -project LittleLemonIos.xcodeproj -scheme LittleLemonIos \
  -destination 'platform=iOS Simulator,name=iPhone 17' test \
  -only-testing:LittleLemonIosTests/MyTestSuite/myTestCase   # single test
```

**Linting:** no linter or formatter is configured in the repo (no SwiftLint/SwiftFormat config, no build phase). Compiler warnings from `xcodebuild` are the only static check.

## Project structure and build configuration

These are non-obvious and shape how code must be written:

**Adding files needs no project edits.** The project uses `PBXFileSystemSynchronizedRootGroup` (Xcode 16+ format, `objectVersion = 77`). The entire `LittleLemonIos/` folder is synchronized with the target, so any `.swift` file created anywhere under it — including new subfolders — is compiled automatically. **Never hand-edit `project.pbxproj` to register a file**; just write the file. Corollary: any stray `.swift` file left in that tree will be compiled, so delete scratch files rather than leaving them.

**Everything is `@MainActor` by default.** The target sets `SWIFT_DEFAULT_ACTOR_ISOLATION = MainActor` and `SWIFT_APPROACHABLE_CONCURRENCY = YES` under Swift 5 language mode. Types and functions with no explicit isolation are implicitly main-actor-isolated. When writing networking, JSON decoding, or database work that should run off the main thread, mark it explicitly (`nonisolated`, `actor`, or a `@concurrent`/detached context) — otherwise it silently serializes onto the main actor.

**iOS 26.5 deployment target.** Modern-only APIs (SwiftData, `@Observable`, `NavigationStack`, `.searchable`, string catalogs) are available unconditionally; no `if #available` back-deployment guards are needed.

**Info.plist is generated.** `GENERATE_INFOPLIST_FILE = YES` and there is no `Info.plist` file. To add a plist key (e.g. `NSAppTransportSecurity`, a URL scheme), add the corresponding `INFOPLIST_KEY_*` build setting in `project.pbxproj` rather than creating an `Info.plist`.

**Localization is on.** `SWIFT_EMIT_LOC_STRINGS` and `STRING_CATALOG_GENERATE_SYMBOLS` are enabled, so user-facing `Text` literals are extractable into a String Catalog.

Other configuration: bundle id `com.example.LittleLemonIos`, universal iPhone + iPad (`TARGETED_DEVICE_FAMILY = "1,2"`), automatic signing with a development team already set, single scheme `LittleLemonIos`, single target, Debug/Release only.

## Repo conventions

Ignore rules live in `.git/info/exclude` (local-only, Xcode-generated) — there is no committed `.gitignore`, and `xcuserdata/.../xcschememanagement.plist` is tracked. If adding shared ignore rules, create a real `.gitignore`.
