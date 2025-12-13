# Weather App

**Weather App** is a simple yet powerful weather application built with **Flutter** that displays the current weather of a city. The app fetches weather data from a remote API and provides features like temperature, humidity, and a 5-day forecast. The app is designed using **Clean Architecture**, **Flutter Bloc**, and other modern Flutter libraries to maintain scalability and readability.

## Features

- **Current Weather:** Displays real-time weather data of the selected city.
- **5-Day Forecast:** Shows the weather forecast for the next 5 days.
- **City Selection:** Allows users to select a city to view its weather.
- **Date Formatting:** Uses **Shamsi Date** for Persian date formatting.
- **Persistent Data:** Saves user settings like the selected city using **SharedPreferences**.
- **Error Handling:** Proper error handling in case of connectivity issues or API errors.

## Architecture & State Management

### **Architecture**

This app follows the **Clean Architecture** pattern, which ensures separation of concerns and a scalable, testable codebase. The architecture consists of three main layers:

1. **Presentation Layer**:
   - Manages the user interface and user interaction.
   - Uses **Flutter Bloc** for state management, with **Equatable** to simplify state comparison and improve performance.
   
2. **Domain Layer**:
   - Contains the business logic, such as fetching weather data, converting temperatures, and managing user preferences.
   - Uses **Dartz** for functional programming techniques like **Either** for error handling and **Option** for optional values.

3. **Data Layer**:
   - Manages data retrieval from remote sources (like APIs) and local storage (via **SharedPreferences**).
   - Handles connectivity checks using **InternetConnectionCheckerPlus** to ensure the app has an active internet connection before making requests.

### **State Management with Flutter Bloc**

The app uses **Flutter Bloc** for managing application state, allowing for a clear separation of UI and business logic. Here's how the state is managed:

- **Weather State:** Holds the current weather information, including the temperature, humidity, and weather description. This state is managed using **Bloc** and updated based on API responses.
- **Connectivity State:** The app checks for an active internet connection using **InternetConnectionCheckerPlus**. If no connection is detected, the app will show an error message.
- **User Settings State:** The selected city is stored in **SharedPreferences**, and its state is managed through a **Bloc**.

### **Key Features of the Architecture:**

- **Use of Bloc:** For managing different states, such as weather data, connectivity, and user settings.
- **Error Handling with Either and Option:** Leveraging **Dartz** for better error handling and dealing with nullable values.
- **Persistance:** User preferences like city selection are stored persistently using **SharedPreferences**.

### **UI Design**

The UI is clean and simple, following **Material Design** principles. It displays the weather data in an easy-to-read format, and **Shamsi Date** is used to show the date in Persian format, enhancing the app's accessibility for Persian-speaking users.

---

## Dependencies

This app uses several Flutter packages to simplify development and improve functionality:

- **flutter_bloc**: For managing the app's state using the **BLoC** pattern.
- **equatable**: Used to easily compare objects, particularly states, in **Flutter Bloc**.
- **dartz**: Functional programming tools for error handling and managing optional values.
- **internet_connection_checker_plus**: Used to check the device's internet connection before making API requests.
- **shared_preferences**: For storing persistent data like the selected city.
- **get_it**: A service locator used to manage dependencies and inject them where needed.
- **intl**: For internationalization and formatting the date and time.
- **shamsi_date**: For converting and displaying dates in the Persian calendar.

### Full List of Dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  dartz: ^0.10.1
  internet_connection_checker_plus: ^2.0.0
  shared_preferences: ^2.5.3
  get_it: ^8.2.0
  intl: ^0.20.2
  shamsi_date: ^1.1.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mockito: ^5.5.1
  build_runner: ^2.9.0
