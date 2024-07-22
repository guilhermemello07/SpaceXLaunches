# SpaceXLaunches iOS Project Report

## Project Overview

### Project Name
SpaceXLaunches

### Purpose
The SpaceXLaunches project was developed as part of a technical interview for an iOS Developer role. The app provides information about past and upcoming SpaceX launches, along with detailed information about the rockets and launchpads used in these missions.

### Developer
Guilherme Teixeira de Mello

## Project Structure

The project is organized as follows:
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

## Key Components
* SpaceXLaunchesApp: The entry point of the app, using SwiftUI's App protocol to define the main view.
* URLSessionProtocol: A protocol for URL session, allowing dependency injection and better testability.
* Managers/NetworkManager: Monitors network connectivity using Apple's Network framework.

* Cache/:
  * ImageCache: A simple in-memory cache for storing downloaded images.
  * CacheAsyncImage: A SwiftUI view that fetches images asynchronously and caches them for future use.

* ViewModels/ViewModel: Manages the app's data, including fetching data from the SpaceX API and caching it locally.

* Models/:
  * Launch: Represents a SpaceX launch, with properties for launch details and related data.
  * Rocket: Represents a SpaceX rocket.
  * Launchpad: Represents a SpaceX launchpad.
  * SXError: An error type for handling various network and data issues.

* Views/:
  * ContentView: The main view displaying a list of launches.
  * LaunchImageView: A view for displaying launch images.
  * LaunchView: Displays a summary of a launch.
  * LaunchDetailView: Shows detailed information about a launch.
  * RocketInfoView: Displays information about a rocket.
  * LaunchpadInfoView: Displays information about a launchpad.
 
## Design Decisions

### SwiftUI and Declarative UI
I chose SwiftUI for its declarative UI paradigm, which simplifies the creation of complex UIs with less code and improved readability.

### Protocol-Oriented Programming
The use of URLSessionProtocol allows for better testability by enabling dependency injection. This makes it easy to mock network responses during unit tests, ensuring that the app's data-handling logic can be tested independently of the actual network.

### Network Monitoring
The NetworkManager class utilizes Apple's Network framework to monitor network connectivity. This ensures that the app can gracefully handle changes in network status, such as switching from Wi-Fi to cellular data or losing connection entirely.

### Caching
To improve performance and reduce unnecessary network requests, I implemented a simple in-memory cache (ImageCache) for storing images. The CacheAsyncImage view component leverages this cache, ensuring that images are only downloaded once and reused as needed.

### Local Data Storage
The ViewModel caches data locally in JSON files. This ensures that the app can display previously fetched data when offline, providing a better user experience. The local cache is updated whenever new data is successfully fetched from the SpaceX API.

### Date Handling
Handling dates in multiple time zones is crucial for accurately displaying launch times. The Launch model includes computed properties to convert UTC dates to local and Irish time zones, ensuring users see the correct launch times regardless of their location.

## Challenges Faced

### Error Handling
Handling various types of errors, from network issues to data parsing errors, was crucial for providing a robust user experience. The custom SXError type helped standardize error handling and display user-friendly error messages.

### Offline Support
Implementing offline support required careful consideration of when to load data from the network versus local cache. Ensuring data consistency and providing meaningful feedback to users during network disruptions were key aspects of this challenge.

### Image Caching
Efficiently caching and retrieving images without consuming too much memory or making redundant network requests was a critical requirement. The ImageCache and CacheAsyncImage components provided a simple yet effective solution.

## Areas to Improve

### ViewModel Refactoring 
Refactor the ViewModel to use generics to clean the code and make it more readable and maintainable.
This feature will probably be implemented in a few days, but as I had to deliver the project on a specific date, I decided to make the whole app functional as better as I could with the available time.

### Local and Irish dates
If I had more time, I would have done something like the following:
First, I would get only the UTC date and time, map it to the correspondent Irish date and time, and for the local one, I would get the information from the `Launchapad` model.
Each launchpad has a `region` variable that I could use with an Enum to get the correspondent available TimeZone, for example, the launchpad region of `"florida"` would be mapped to the Timezone of `TimeZone(identifier: "America/New_York")`.

## Conclusion

The SpaceXLaunches project demonstrates a robust, well-architected iOS application built using modern SwiftUI principles, and designed with the MVVM architecture in mind. By using some practices of protocol-oriented programming, effective state management, and efficient caching mechanisms, the app delivers a good user experience even in challenging network conditions. This project helps to demonstrate some of my technical skills, and my ability to design and implement scalable and maintainable iOS applications.
