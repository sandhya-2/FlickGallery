# FlickGalleryApp

**PhotoGalleryApp** is an iOS application built in Swift and SwiftUI. It is designed to displays a list of photos using Flickr Api. Here is an overview of its functionality. 

## Features

-**Photo searching -** Searching of photos using keyword input in the search bar  and it filters relevant images from the Flickr API. 
-**Details Screen -** Click on any list item from the list displayed to view more details about that particular photo. The details includes its title, userid and the date along with the lists of tags associated with the photo.
-**Filtering by User ID -** If the user taps on a user ID displayed in Detail screen, the app filters and displays a new lists of photos associated with that specific user ID.
-**Grid View - ** User can navigate to detail screen by tapping on a grid cell to display the details of that photo. 
 
-**Default Search Text -** Upon launching the app, the default search text is set to "yorkshire". Therefore, the initial list displayed is based on the default search text. 
-**User friendly UI -** Built using SwiftUI, the app has user friendly interface along with smooth navigations between screens. 

# Framework
SwiftUI has been is used. 


# Architecture

This app uses the Model View ViewModel (MVVM) architectural pattern. The benefits of this are:

- **Separation of Concerns:** MVVM promotes structural code base, the Model holds the data receive from API, the UI of the app in the View and the business logic stays in the ViewModel. The codes becomes more modular, scalable, readable and cleaner. Since layer are separate it is easy maintain. 

- **Reduced Complexity:** Views are simpler as the business logic are moved to the ViewModel. The ViewModel better expresses the logic for the views.

- **Reusability:** The logic are decoupled from views which makes them reusable component of the app. 

- **Testability:** With MVVM, as the logic is loosely coupled testing of the different components of the app becomes easier. This makes application robust. 

- **Data Binding:** With MVVM data binding is easier. The changes occured in the view model is easily updated on the views similarly changes on the views is updated in the View model.  


# Design Patterns
The network requests are using async/await syntax which enables efficient asynchronous operations. By implementing a generic API call, the netowrk request are reusable for multiple endpoints and handles any data types.


# Testing
Unit tests for success and failure situations. Mocked responses using MockNetworkManager. Testing the Network Manager to ensure the network API call are run, and the data is received as expected with possible use cases.

## Installation

Can be used with Xcode 15.4 

1. Clone or download the repository.
2. Double click the project in Xcode to access the project.
3. Ensure you have the latest Swift and SwiftUI versions installed.
4. Ensure you have the latest iOS version simulator.
5. Build and run the application on your preferred simulator (iOS 17.5) or physical device.


# Screenshots

|Home Screen|Detail Screen|UserID Screen|Unit tests|
|---|---|---|---|

|<img width="300" alt="HomeScreen" src="https://github.com/sandhya-2/FlickGallery/assets/15943310/d3e45c98-5d50-4c6b-8aaf-7312bc72ac50">
<img width="300" alt="DetailScreen" src="https://github.com/sandhya-2/FlickGallery/assets/15943310/c01d4c1b-33a3-46cd-851c-d2b189b82760">|
<img width="300" alt="GridView" src="https://github.com/sandhya-2/FlickGallery/assets/15943310/94e65653-d732-4c7e-8921-bae8e47be6d0">|
<img width="300" alt="UnitTests" src="https://github.com/sandhya-2/FlickGallery/assets/15943310/db60fbcf-5e0e-4d7d-b143-719beeb1e721">|

