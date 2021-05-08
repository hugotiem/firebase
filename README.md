# PTS

A new Flutter project.

1. [Getting Started.](#getting-started)
2. [Project Architecture.](#project-architecture)
3. [BackLogs.](#backlogs)
4. [APIs](#apis)

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
- [ZignSec for Online ID Verification](https://zignsec.com/products/online-id-verification/)
- [Sumsub Identity Verification Services](https://sumsub.com/identity-verification/?utm_source=google&utm_medium=cpc&utm_campaign=Target_search_requests_Germany_France_Israel_Spain&utm_term=identity%20verification&utm_content=119238569925||)
- [Jumio ID Verification](https://www.jumio.com/fr/produits/id-verification/)
- [IDCheck.io ID Verification](https://fr.idcheck.io/)
