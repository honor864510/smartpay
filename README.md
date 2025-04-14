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

- [ ] Localizations Support
  - [ ] Add support for multiple locales/languages
  - [ ] Implement localization utilities
  - [ ] Create translation files for supported languages

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
