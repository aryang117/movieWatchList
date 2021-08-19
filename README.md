# Table of Contents
  - **[Overview](#yellow-class-take-home-task-moviedb)**
    -  [Problem Statement](#problem-statement)
    -  [Status](#status)
  - **[Building And Installation](#building-&-installation)**
    - [Pre-Requistes](#prerequisites)
    - [Cloning/Downloading the Project](#cloning-the-project-repo)
    - [Building the App](#build)
    - [Installation](#installation)
  - **[Technical Discussion](#technical-discussion)**
    - [Packages](#packages-used)
    - [Platform/APIs Used](#platform-and-apis-used)
    - [Tools I Used](#tools-used)
    - [Features Implemented](#features-implmented)

# Yellow Class Take Home Task MovieDB
  This repository was made for Yellow Class's take home task. 
  
  ## Problem Statement 
  Build a simple application using Flutter compatible with Android/iOS devices.

  - Build a simple aesthetic app to add/edit/delete/list movies that a user has watched.
  - Show an infinite scrollable listview containing all the movies that a user has created.
  - Implement a form to add a new movie or edit an existing one. (Fields to keep: Name, Director and a poster image of the movie)
  - Each list item should have a delete icon to remove that movie from the list and an edit icon to allow edit on that movie.
  - Store the data in either hive or sqflite local database.

**Brownie points** for integrating persistent google authentication using firebase and then allowing only logged-in users to add movies.

  ## Assigned To
  Aryan Gupta 18BCE10062

  ## Status
  I have completed the task accomplishing the following -
  - The App allows the user to scroll through all the movie that he/she may have create (infinitely scrolling)
  - The App allows user(s) to Add* / Edit / Delete / List all of the movies (* Only Logged In users can add to the List)
  - The Movie details consist of Name of the movie, Director of the Movie, Poster of the movie
  - The App Stores the Movie data in a **Hive box** 
  - The Poster of the Movie is fetched from the **OMDB** API
  - The App also implements Firebase (Authentication) allowing users to Sign in Anonymously, Sign in via Google or Skip Sign In (Sign in Later option, but user cannot add new movies now)
  - The authentication is persistent, i.e, once the user logs in, he/she will be logged in until he/she logs out, they will be logged-in even if they restart the app (unless they log out)

  # Building & Installation
  ## Prerequisites
  To build this app, you will need -
  - [Flutter SDK](https://flutter.dev)
  - [Firebase Project](https://firebase.google.com) - you will have to create your own project and add your own **google-services.json** (I have not included it in this repo)
    - [Handy Tutorial to add Firebase into your flutter app](https://firebase.flutter.dev) 
  - [OMDB Api Key](http://www.omdbapi.com/) - you will need your own key, I have **not** included mine in this repo


  ## Cloning the Project Repo
  If you like using the terminal
   - Navigate to where you want to clone this repo
   - ```git clone https://github.com/aryang117/yellowclassTest.git```
  <br> </br>
  
  If you wish to clone using the browser only
   - Scroll up to the about section
   - To the left of about section, you will see a button with label ``Code``
   - Click on the code button and then on Download zip
   - Extract the zip and you have the project folder!
    
   [Other ways](https://docs.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository-from-github/cloning-a-repository)
  
  ## Build
  Now, to actually build the app
  - Clone this repo
  - Navigate to the folder where this repo has been cloned
  - ```flutter build apk --release``` to build a release build of the app
  
  ## Installation
  To install this on a real device, after building the app
  - Plug-in your phone via USB
  - In the project folder ``flutter install [device-id]`` (device-id -> device-id of your phone, run ``flutter devices`` to see your device's id)
  It should be installed now! Check it out! (Assuming no errors occured during build)
  
  
  # Technical Discussion
  ## Packages Used
  These are the different 3rd Party Packages I used to complete this project
  - hive (^2.0.0) / hive_flutter (^1.0.0) - To use Hive and it's features
  - hive_generator (^1.1.0) To generate TypeAdapters
  - build_runner(^2.1.1) - to build the TypeAdapter
  - firebase_core(^1.5.0) - firebase core functionality
  - firebase_auth (^3.0.2) - firebase authentication
  - google_sign_in (^5.0.7) - to implement Sign In via Google
  - http (^0.13.3) - to implement API calls
  - flutter_signIn_button (^2.0.0) - To get Ready-Made Sign-in via Google button (only components/button no functionality

  ## Platforms and APIs used
  I had to use some 3rd Party APIs and Platforms to implement some required and optional functionalities of the app
   - [OMDB API](http://www.omdbapi.com/) - to get movie posters
   - [Firebase / Firebase Auth](https://firebase.google.com) - To implement Sign in functionality
  
  ## Tools Used
  Whilst working on this project, I used many different tools
  - Visual Studio Code (My Main Editor)
  - Windows Terminal (Main Terminal)
  - Android Emulator (To debug the apps)

  ## Features Implemented
  
  The app already fulfills all the requirements given in the problem statement. 
  
  ### Optional Features Implemented
  The App allows the user to persistently sign in anonymously or sign in via Google or skip the sign in.
  Only signed in users are allowed to add new movies. 
  
  ### Extra Features Implemented
  I added a few features that were not part of the problem statement, but they were added to help in development and are just tiny QoL (Quality of Life) features to make it easier to perform all operations of the app
  #### Bottom Navigation Bar
  Added a quick Bottom Navigation Bar, that will allow users to 
  - Clear all values of the box
  - Log Out of the App
  #### Placeholder Images
  - I added placeholder images in case if the API doesn't return a link for the movies (such as a N/A), this seems to be an edge case, I encountered while added Iron Man 3 movie.
  - I also added placeholder images in the addToForm screen, it will display that placeholder image until the user enters a movie and the app gets it's poster's link.
  #### Anonymous Sign in
  Don't want to go through the hassle to sign in via Google? Don't worry, I added a Anonymous Sign in button, this will allow you to Sign in anonymously and still use all of the Signed in user functionality (mainly adding new movies) (You will have to enable Anonymouse Sign in in [Firebase console](https://console.firebase.google.com))
