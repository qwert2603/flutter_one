import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_one/anim.dart';
import 'package:flutter_one/paint.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter One',
      theme: ThemeData(
        primaryColor: Colors.green,
        dividerColor: Colors.deepOrange,
        accentColor: Colors.yellow,
        splashColor: Colors.cyan.withAlpha(42),
      ),
      home: RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = new Set<WordPair>();
  final _biggerFont = const TextStyle(fontSize: 18.0);

  Widget _buildSuggestions() {
    return ListView.builder(
//      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return Divider(height: 0);

        final index = i ~/ 2;
        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }

        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final bool alreadySaved = _saved.contains(pair);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      title: Text(pair.asPascalCase, style: _biggerFont),
      trailing: GestureDetector(
        child: RotatedBox(
          quarterTurns: 1,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                alreadySaved ? Icons.toys : Icons.pie_chart,
                color: alreadySaved ? Colors.green : null,
              ),
              Icon(
                alreadySaved ? Icons.perm_media : Icons.pets,
                color: alreadySaved ? Colors.white : null,
              ),
              Icon(
                alreadySaved ? Icons.favorite : Icons.favorite_border,
                color: alreadySaved ? Colors.red : null,
              ),
            ],
          ),
        ),
        onTapUp: (d) =>
            print("trailing onTapUp ${d.globalPosition} ${d.runtimeType}"),
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }

  void _pushSaved() {
    Navigator.of(context)
        .push(new MaterialPageRoute(builder: (BuildContext context) {
      final Iterable<ListTile> tiles = _saved.map((WordPair pair) {
        return new ListTile(
          title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ),
        );
      });
      final List<Widget> divided = ListTile.divideTiles(
        context: context,
        tiles: tiles,
      ).toList();

      return new Scaffold(
        appBar: new AppBar(
          title: const Text("favs"),
        ),
        body: new ListView(children: divided),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Flutter One"),
        actions: <Widget>[
          IconButton(
            color: Colors.black,
            highlightColor: Colors.blueAccent.withAlpha(42),
            splashColor: Colors.deepOrange.withAlpha(54),
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
          ),
          IconButton(icon: const Icon(Icons.adb), onPressed: _anth),
          IconButton(
              icon: const Icon(Icons.ac_unit),
              tooltip: "snow",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        MyFadeTest(title: "asdfg")));
              }),
          IconButton(
              icon: const Icon(Icons.airplay, color: Colors.redAccent),
              tooltip: "pnt",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        Scaffold(body: Signature())));
              }),
        ],
      ),
      body: _buildSuggestions(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrangeAccent,
        tooltip: "fab tooltip",
        child: Container(
          padding: EdgeInsets.only(left: 6),
          child: Icon(Icons.clear_all),
        ),
        onPressed: () => setState(() => _saved.clear()),
      ),
    );
  }

  void _anth() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) => AnthPage()));
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}

class AnthPage extends StatefulWidget {
  @override
  State createState() => _AnthPageState();
}

class _AnthPageState extends State<AnthPage> {
  bool toggle = true;

  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return Text(
        'Toggle One',
        style: TextStyle(
            fontSize: 32,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold),
      );
    } else {
      return OutlineButton(
        highlightElevation: 0,
        onPressed: () {},
        borderSide: BorderSide(color: Colors.blue),
        child: Text('Toggle Two'),
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(4.0)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: Icon(Icons.update),
      ),
    );
  }
}
