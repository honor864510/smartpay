# SmartPay

A Flutter mobile payment application with local and server-side data management.

## Introduction

SmartPay is a comprehensive payment solution that allows users to manage bank cards, send and receive payments via QR codes, and track transaction history. The application supports multiple languages, theme modes, and secure user authentication.

## Features & Tasks

### Core Infrastructure

- [ ] Create project structure
  - [ ] Organize code into feature-based modules
  - [X] Set up dependency injection
  - [ ] Implement clean architecture patterns

- [X] Localizations Support
  - [X] Add support for multiple locales/languages
  - [X] Implement localization utilities
  - [X] Create translation files for supported languages

- [ ] Theme Mode Support
  - [ ] Implement dark and light theme modes
  - [ ] Create theme controllers and providers
  - [ ] Add user preference for theme selection

### Data Management

- [ ] Database Integration
  - [ ] Integrate Sembast database for local data persistence
  - [ ] Set up database configuration and initialization
  - [ ] Implement database migration strategies

- [ ] Local Bank Cards Data Management
  - [ ] Create models for bank card data
  - [ ] Implement CRUD operations for bank cards
  - [ ] Add secure storage for sensitive card information

- [ ] Backend Integration with Parse Server
  - [ ] Add support for parse_server_sdk
  - [ ] Configure server connection and authentication
  - [ ] Implement data synchronization between local and server

- [ ] Data Modeling
  - [ ] Create Entities, DTOs (Data Transfer Objects), and DAOs (Data Access Objects)
  - [ ] Integrate with parse_server_sdk and its built-in objects
  - [ ] Implement data validation and transformation logic

### User Management

- [ ] User Authentication
  - [ ] Implement user login functionality
  - [ ] Create user registration flow
  - [ ] Add logout functionality
  - [ ] Implement password reset and recovery

- [ ] User State Management
  - [ ] Create sealed class structure with the following states:
    - [ ] UserAuthenticated
    - [ ] UserUnauthenticated (default)
    - [ ] UserAuthenticationIncomplete
  - [ ] Save user state in shared preferences

- [ ] Authentication Guard
  - [ ] Create navigation guard based on authentication status
  - [ ] Redirect users to appropriate screens based on auth state
  - [ ] Handle session expiration and token refresh

### Payment Features

- [ ] Transactions History
  - [ ] Implement feature to record user transactions
  - [ ] Create transaction listing and filtering
  - [ ] Add transaction details view

- [ ] Receiving Transactions
  - [ ] Implement QR code scanner
  - [ ] Create flow to open and scan QR codes
  - [ ] Add validation and processing of received transaction data
  - [ ] Implement submission of received transaction data

- [ ] Sending Transactions
  - [ ] Create QR code generation for transactions
  - [ ] Implement flow to read QR codes
  - [ ] Add validation and confirmation steps
  - [ ] Implement submission of outgoing transaction data

### Application Settings

- [ ] Settings Controller
  - [ ] Develop controller to manage application settings
  - [ ] Implement settings persistence
  - [ ] Create settings UI

## Documentation

- [ ] API Documentation
  - [ ] Document all public APIs
  - [ ] Create API reference guide

- [ ] User Guide
  - [ ] Create user onboarding guide
  - [ ] Document all user-facing features

- [ ] Developer Documentation
  - [ ] Document architecture and design decisions
  - [ ] Create setup and contribution guidelines
  - [ ] Add code style and best practices documentation

## Developer Guide

### Dependency Injection

The application uses a simple but effective dependency injection system. To add a new dependency to the project, follow these two steps:

1. **Add a field in the Dependencies class**
   - Open `lib/src/common/model/dependencies.dart`
   - Add a new field to the `Dependencies` class
   - Example: `late final YourService yourService;`

2. **Initialize the dependency in _initializationSteps**
   - Open `lib/src/feature/initialization/data/initialize_dependencies.dart`
   - Add a new entry to the `_initializationSteps` map
   - Example:
     ```dart
     'Initialize YourService':
         (dependencies) async =>
             dependencies.yourService = await YourService.initialize(),
     ```

This two-step process ensures that all dependencies are properly initialized during app startup and are available throughout the application via the `Dependencies.of(context)` method.


### Localization

The application uses the `flutter_intl` VSCode extension to manage localizations. To add new strings to the localization files, follow these steps:

1. **Locate the ARB files**
   - ARB files are located in the `lilib/src/common/localization` directory
   - Each supported locale has its own file (e.g., `intl_en.arb` for English, `intl_tk.arb` for Turkmen, `intl_ru.arb` for Russian)

2. **Add a new string**
   - Open the base ARB file (usually `intl_en.arb`)
   - Add a new key-value pair in the JSON format:
     ```json
     "yourStringKey": "Your string value",
     "@yourStringKey": {
       "description": "Description of how this string is used"
     }
     ```

3. **Generate Dart code**
   - Save the ARB file
   - The flutter_intl extension will automatically generate the necessary Dart code (if not, head to [here](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl))

4. **Use the new string in your code**
   - Import the generated file: `import 'package:smartpay/generated/l10n.dart';`
   - For best practice, assign the localization to a variable in your build method, then use it:
     ```dart
     @override
     Widget build(BuildContext context) {
       final localization = Localization.of(context);

       return Text(localization.welcomeMessage);
     }
     ```

> **Note:** Before getting started, please install and read the documentation for the [Flutter Intl extension](https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl) to understand all available features and configuration options.

Example:

1. Add to `intl_en.arb`:
   ```json
   "welcomeMessage": "Welcome to SmartPay!",
   "@welcomeMessage": {
     "description": "Greeting shown on the home screen"
   }
