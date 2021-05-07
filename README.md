# PTS

A new Flutter project.

1. [Getting Started.](#getting-started)
2. [Project Architecture.](#project-architecture)
3. [BackLogs.](#backlogs)
4. [APIs](#api)

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Project Architecture

<pre><code>
PTS
├── android/ (android app builder)
├── ios/ (ios app builder)
├── lib/
│    ├── Model/
│    │    ├── components/ (customs components)
│    │    ├── services/ (db services)
│    │    └── soiree.dart
│    ├── View/
│    │    ├── Pages/
│    │    │     ├── creation
│    │    │     ├── login/
│    │    │     ├── profil/
│    │    │     ├── search/
│    │    │     └── tests/
│    │    └── Home.dart
│    ├── Constant.dart
│    └── main.dart (main page to run the app)
├── test/
├── web/
├── backlogs.xlsx (fichier Exel contenant les backlogs de l'app)
├── .gitignore
├── .metadata
├── README.md
├── pubspec.lock
└── pubspec.yaml
</pre></code>

## BackLogs

Backlogs list comming soon.

## APIs

- Firebase -> DataBase, credencials

### probably used later :
- ZignSec for Online ID Verification
- Sumsub Identity Verification Services
- Jumio ID Verification
- IDCheck.io ID Verification
