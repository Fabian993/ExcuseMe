# excuseme

The ExcuseMe App 

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.



# Dependencies

## Linux

First, get either `gnome-keyring` or `kwalletmanager`, depending desktop manager


```sh
#flutter_secure_storage
sudo apt install libsecret-1-dev clang lld llvm-18
```

# Icons

To generate app icons...

1. place the icon in `assets/`.
2. change the image path in pubspec.yaml (`flutter_launcher_icons`) 
3. run the following command

```sh
flutter pub run flutter_launcher_icons:main
```