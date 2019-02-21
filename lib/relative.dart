import 'package:flutter/material.dart';

class Song extends StatelessWidget {
  const Song({this.title, this.author, this.likes});

  final String title;
  final String author;
  final int likes;

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200.withOpacity(0.3),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 4.0, bottom: 4.0, right: 10.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(
                    'http://thecatapi.com/api/images/get?format=src'
                    '&size=small&type=jpg#${title.hashCode}'),
                radius: 20.0,
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(title, style: textTheme.subhead),
                    Text(author, style: textTheme.caption),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: InkWell(
                child: Icon(Icons.play_arrow, size: 40.0),
                onTap: () {},
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              child: InkWell(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.favorite, size: 25.0),
                    Text('${likes ?? ''}'),
                  ],
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Feed extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Song(title: 'Trapadelic lobo', author: 'lillobobeats', likes: 4),
        Song(title: 'Different', author: 'younglowkey', likes: 23),
        Song(title: 'Future', author: 'younglowkey', likes: 2),
        Song(title: 'ASAP', author: 'tha_producer808', likes: 13),
        Song(title: '🌲🌲🌲', author: 'TraphousePeyton'),
        Song(title: 'Something sweet...', author: '6ryan'),
        Song(title: 'Sharpie', author: 'Fergie_6'),
      ],
    );
  }
}

class CustomTabBar extends AnimatedWidget implements PreferredSizeWidget {
  CustomTabBar({this.pageController, this.pageNames})
      : super(listenable: pageController);

  final PageController pageController;
  final List<String> pageNames;

  @override
  final Size preferredSize = Size(0.0, 40.0);

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      height: 40.0,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade800.withOpacity(0.5),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(pageNames.length, (int index) {
          return InkWell(
              child: Text(pageNames[index],
                  style: textTheme.subhead.copyWith(
                    color: Colors.white.withOpacity(
                      index == pageController.page ? 1.0 : 0.2,
                    ),
                  )),
              onTap: () {
                pageController.animateToPage(
                  index,
                  curve: Curves.easeOut,
                  duration: const Duration(milliseconds: 300),
                );
              });
        }).toList(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController(initialPage: 2);

  @override
  build(BuildContext context) {
    final Map<String, Widget> pages = <String, Widget>{
      'My Music': Center(
        child: Text('My Music not implemented'),
      ),
      'Shared': Center(
        child: Text('Shared not implemented'),
      ),
      'Feed': Feed(),
    };
    TextTheme textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.bottomCenter,
              colors: [
                const Color.fromARGB(255, 253, 72, 72),
                const Color.fromARGB(255, 87, 97, 249),
              ],
              stops: [0.0, 1.0],
            )),
            child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'T I Z E',
                    style: textTheme.headline.copyWith(
                      color: Colors.grey.shade800.withOpacity(0.8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ))),
        Scaffold(
          backgroundColor: const Color(0x00000000),
          appBar: AppBar(
            backgroundColor: const Color(0x00000000),
            elevation: 0.0,
            leading: Center(
              child: ClipOval(
                child: Image.network(
                  'http://i.imgur.com/TtNPTe0.jpg',
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
            ],
            title: const Text("tofu's songs"),
            bottom: CustomTabBar(
              pageController: _pageController,
              pageNames: pages.keys.toList(),
            ),
          ),
          body: PageView(
            controller: _pageController,
            children: pages.values.toList(),
          ),
        ),
      ],
    );
  }
}
