import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'dart:async';
import 'dart:convert';
import 'details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
  bool isTablet(BuildContext context) => MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1024;
  bool isWeb(BuildContext context) => MediaQuery.of(context).size.width >= 1024;

  List movies = [];
  List topMovies = [];
  bool isLoading = true;
  PageController _pageController = PageController(viewportFraction: 0.5);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchMovies();

    // Auto-scroll for PageView
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_currentPage < (topMovies.length - 1)) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchMovies() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        movies = json.decode(response.body);

        // Sort by rating and take the top 5 movies
        movies.sort((a, b) {
          double ratingA = (a['show']['rating']['average'] ?? 0).toDouble();
          double ratingB = (b['show']['rating']['average'] ?? 0).toDouble();
          return ratingB.compareTo(ratingA);
        });

        topMovies = movies.take(5).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildImage(String? url, {double height = 120}) {
    if (url == null || url.isEmpty) {
      return Image.asset(
        'assets/placeholder.png',
        fit: BoxFit.cover,
        height: height,
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          'assets/placeholder.png',
          fit: BoxFit.cover,
          height: height,
        );
      },
    );
  }

  void _searchMovies(String query) {
    Navigator.pushNamed(
      context,
      SearchScreen.routeName,
      arguments: query,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobileDevice = isMobile(context);
    final isTabletDevice = isTablet(context);
    final isWebDevice = isWeb(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Navigation logic here
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'MovieBlaze',
              style: TextStyle(
                color: Colors.white,
                fontSize: isWebDevice ? 30 : (isTabletDevice ? 26 : 24),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, SearchScreen.routeName);
            },
          ),
        ],

      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isWebDevice ? 60 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Are you ready to surf into movies world?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isWebDevice ? 28 : (isTabletDevice ? 24 : 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Top Movies',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isWebDevice ? 22 : (isTabletDevice ? 20 : 18),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              topMovies.isNotEmpty
                  ? (isWebDevice || isTabletDevice)
                  ? GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(), // To avoid internal scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isWebDevice ? 4 : 3, // More columns for smaller images
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: isWebDevice ? 0.65 : 0.7, // Adjust for smaller images
                ),
                itemCount: topMovies.length,
                itemBuilder: (context, index) {
                  final movie = topMovies[index]['show'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: movie,
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: Image.network(
                                movie['image']?['original'] ?? '',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/placeholder.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(15.0)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      movie['name'] ?? 'Unknown',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: isWebDevice ? 18 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.amber, size: 16),
                                        SizedBox(width: 4),
                                        Text(
                                          '${movie['rating']['average'] ?? 'N/A'}',
                                          style: TextStyle(color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      movie['genres'] != null
                                          ? movie['genres'].join(', ')
                                          : 'N/A',
                                      style: TextStyle(color: Colors.white60, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              )
                  : SizedBox(
                height: 300,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: topMovies.length,
                  itemBuilder: (context, index) {
                    final movie = topMovies[index]['show'];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments: movie,
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.network(
                                  movie['image']?['original'] ?? '',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset(
                                      'assets/placeholder.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15.0)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie['name'] ?? 'Unknown',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Icon(Icons.star, color: Colors.amber, size: 16),
                                          SizedBox(width: 4),
                                          Text(
                                            '${movie['rating']['average'] ?? 'N/A'}',
                                            style: TextStyle(color: Colors.white70),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        movie['genres'] != null
                                            ? movie['genres'].join(', ')
                                            : 'N/A',
                                        style: TextStyle(color: Colors.white60, fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
                  : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'No Top Movies Available',
                  style: TextStyle(color: Colors.white70),
                ),
              ),

              Divider(color: Colors.grey[700]),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'All Movies',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isWebDevice ? 22 : 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                itemCount: movies.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final movie = movies[index]['show'];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        DetailsScreen.routeName,
                        arguments: movie,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: _buildImage(
                              movie['image']?['medium'],
                              height: 100,
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie['name'] ?? 'Unknown',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.star, color: Colors.amber, size: 16),
                                    SizedBox(width: 4),
                                    Text(
                                      '${movie['rating']['average'] ?? 'N/A'}',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 4),
                                Text(
                                  movie['genres'] != null
                                      ? movie['genres'].join(', ')
                                      : 'N/A',
                                  style: TextStyle(color: Colors.white70),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  movie['network'] != null
                                      ? movie['network']['name']
                                      : (movie['webChannel'] != null
                                      ? movie['webChannel']['name']
                                      : 'N/A'),
                                  style: TextStyle(color: Colors.white60),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
