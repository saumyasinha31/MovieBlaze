# MovieBlaze 🎬

MovieBlaze is a simple movie browsing app built with Flutter. It allows users to browse popular movies, view top-rated movies, and search for movies by title. The app fetches data from the RESTapi and displays movie information in a sleek and minimalist UI.

## Features

- **Splash Screen**: Displays a branded splash screen on app startup.
- **Home Screen**: 
  - Shows top-rated movies in an auto-scrolling carousel.
  - Displays a list of all movies available.
- **Search**: Allows users to search for movies by title.
- **Movie Details**: View detailed information about each movie, including rating, genres, and network/channel.
  
## Screenshots

<p align="center">
  
![Screenshot from 2024-11-12 01-59-50](https://github.com/user-attachments/assets/e90e29e8-dc05-4d5f-b8b9-ae4ec312de10)


![Screenshot from 2024-11-12 01-57-50](https://github.com/user-attachments/assets/e3600dbd-f599-4338-a025-9a16f606b404)


![Screenshot from 2024-11-12 01-59-07](https://github.com/user-attachments/assets/7ad1a702-720d-49a8-8893-1b58286bfc53)
![Screenshot from 2024-11-12 01-59-35](https://github.com/user-attachments/assets/d1e82619-8b7f-4b5f-8b6d-9a65ef3b576a)




</p>

## Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/saumyasinha31/MovieBlaze.git
   cd MovieBlaze
   ```

2. **Install dependencies**:

   ```bash
   flutter pub get 
   ```

3. **Run the app**:

   ```bash
   flutter run
   ```

## Usage

### Home Screen

- The home screen is divided into two sections:
  - **Top Movies Carousel**: An auto-scrolling carousel that showcases the top 5 highest-rated movies.
  - **All Movies List**: A list of all movies fetched from the API.

- Tap on any movie to view its details.

### Search

- Tap the search icon in the top right corner of the app bar to search for movies by title.
- Enter a search query and select a movie from the search results to view details.

### Movie Details

- View detailed information about each movie, including:
  - Title
  - Rating
  - Genres
  - Network/Channel

## Code Structure

- **`main.dart`**: The main entry point of the app. Defines the routes and sets up the navigation between screens.
- **`splash_screen.dart`**: Displays the splash screen when the app is launched.
- **`home_screen.dart`**: The primary screen of the app, showcasing top movies and all movies.
- **`search_screen.dart`**: A screen that allows users to search for movies by title.
- **`details_screen.dart`**: Shows detailed information about the selected movie.
- **API Integration**: The app uses the TVMaze API to fetch movie data.

## Dependencies

- [http](https://pub.dev/packages/http): For making HTTP requests to the TVMaze API.
- [flutter](https://flutter.dev): For building the UI and managing state.

## Future Improvements

- **User Authentication**: Add user accounts for personalized recommendations.
- **Favorites**: Allow users to save favorite movies.
- **Enhanced Search**: Implement filters for genre, rating, and release date.



Enjoy browsing movies with **MovieBlaze**! 🚀
