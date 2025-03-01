# BeeWell

![Platform](https://img.shields.io/badge/platform-iOS-blue)
![Swift](https://img.shields.io/badge/swift-6.0-orange)
![Xcode](https://img.shields.io/badge/Xcode-16-blue)

## Overview

**BeeWell** is a well-being app that provides users with a daily motivational quote. Users can favorite quotes and write their thoughts about them. The app minimizes API calls by caching quotes. BeeWell stores quotes from the last 7 days, allowing users to revisit past quotes and add them to favorites.

## Screenshots

Screenshots will be added to here.

## Features

- Displays a new quote every day.
- Users can favorite quotes.
- Users can write thoughts about a quote.
- Quotes are automatically favorited if the user writes about them.
- Caches the daily quote to minimize API calls.
- Stores the last 7 days of quotes.
- Uses Core Data to store favorited quotes.

## Tech Stack

- **Language:** Swift
- **Frameworks:** UIKit, Combine
- **Architecture:** MVVM
- **Data Management:** Core Data, Repository Pattern
- **Dependency Manager:** Package Manager
- **UI Development:** Programmatic UI, SnapKit for layout
- **API Used:** [ZenQuotes API](https://zenquotes.io/api/today)

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/furkanndgn/BeeWell.git
   ```
2. Open the `.xcodeproj` or `.xcworkspace` file.
3. Run the project on the simulator or a real device.

## Project Structure

- `Resources/Models/` - Defines the data structures.
- `ViewControllers/` - Contains ViewControllers and their corresponding ViewModels.
- `Resources/Repositories/` - Manages data fetching and storage.
- `Resources/Networking/` - Handles API calls.
- `Resources/Persistence/` - Manages Core Data operations.

## Dependencies

- [SnapKit](https://github.com/SnapKit/SnapKit) - For UI layout

## How It Works

1. On launch, the app checks if the daily quote is cached.
2. If the quote for the current day is missing, it fetches a new one from https://zenquotes.io/api/today and stores it.
3. Cached quotes from the last 7 days allow users to revisit and favorite them.
4. Users can tap the "Add to Favorites" button or write their thoughts about a quote.
5. If a user writes about a quote, it is automatically added to favorites.
6. Core Data is used to persist favorited quotes.
7. The Repository Pattern is used to facilitate testing and data management.
