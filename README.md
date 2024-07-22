# SpaceXLaunches
SpaceXLaunches is an iOS application that allows users to view information about past and upcoming SpaceX launches. The app fetches data from the [SpaceX-API](https://github.com/r-spacex/SpaceX-API) and displays it in a user-friendly interface. Users can also view detailed information about the rockets and launchpads associated with each launch.

This project was created for an iOS Developer Technical interview.

## Video 



https://github.com/user-attachments/assets/cf5d1072-e7f9-426b-9700-d03930987149


## Features

* Display a list of past and upcoming SpaceX launches.
* View detailed information about each launch, including the rocket used and the launchpad.
* Cached data for offline access.
* Asynchronous image loading with caching for improved performance.

## Requirements

* iOS 15.0+
* Xcode 13.0+
* Swift 5.0+

## Technologies Used

- Swift
- SwiftUI
- Async/Await
- URLSession
- Caching
- FileManager
- JSON Decoding and Encoding
- MapKit
- XCTest
- Network Manager to monitor Internet connection
- MVVM (Model-View-ViewModel) design pattern

## Design Pattern

The project follows the MVVM (Model-View-ViewModel) design pattern, which helps to separate concerns and make the code more maintainable. Here's a brief overview of how it is implemented:

- **Model:** Represents the data structures for Launch, Rocket, and Launchpad.
- **View:** Includes SwiftUI views such as `ContentView`, `LaunchView`, and `LaunchDetailView`, which display the UI.
- **ViewModel:** `ViewModel` handles the business logic, data fetching from the SpaceX-API, and state management.

## Installation

1. Clone the repository:
```bash
git clone https://github.com/guilhermemello07/SpaceXLaunches.git
```
2. Open the project in Xcode:
```bash
cd SpaceXLaunches
open SpaceXLaunches.xcodeproj
```

3. Build and run the project on your preferred simulator or device.

## Project Structure
```bash
SpaceXLaunches/
│
├── SpaceXLaunchesApp      
├── URLSessionProtocol
├── Managers/
│   └── NetworkManager
├── Cache/
│   ├── ImageCache
│   └── CacheAsyncImage
├── ViewModels/
│   └── ViewModel               
├── Models/
│   ├── Launch
│   ├── Rocket
│   ├── Launchpad
│   └── SXError            
├── Views/
│   ├── ContentView
│   ├── LaunchImageView
│   ├── LaunchView
│   ├── LaunchDetailView
│   ├── RocketInfoView
│   └── LaunchpadInfoView
├── Preview Content/
│   └── Preview Assets  
└── Assets
```

## Usage

### ContentView
ContentView is the main view of the application, displaying a list of past or upcoming SpaceX launches. Users can toggle between past and upcoming launches using a toolbar button.

### ViewModel
ViewModel handles data fetching from the SpaceX API and caching for offline access. It uses @Published properties to update the UI when data changes.

### CacheAsyncImage
CacheAsyncImage is a custom view for loading and caching images asynchronously. It uses an in-memory cache to store images, improving performance and reducing network usage.

### Models
* Launch: Model representing a SpaceX launch.
* Rocket: Model representing a SpaceX rocket.
* Launchpad: Model representing a SpaceX launchpad.

### Error Handling
SXError is an enumeration that defines possible errors in the application, such as invalid URL, invalid response, and data decoding errors.

### Sample Data for Previews
The models include static sample data for use in SwiftUI previews, allowing you to preview views without fetching real data.

## Future Improvements
* Refactor ViewModel to use generics and create Managers to handle specific data.
* Add search functionality to filter launches by name or date.
* Add support for push notifications for upcoming launches.
* Improve error handling and user feedback.
* Add localization support for multiple languages.

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue if you have any suggestions or improvements.

## License
This project is licensed under the MIT License. See the LICENSE file for details.
