import 'dart:async';
import 'dart:convert';

Future<int> sumStream(Stream<int> stream) async {
//  print((await stream.toList()).fold(0, (sq, iq) => (sq as int) + iq));
  var sum = 0;
  await for (var value in stream) {
    sum += value;
  }
  return sum;
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
//    if (i == 4) throw 'ex';
    yield i;
  }
}

Stream<T> flatten<T>(Stream<Stream<T>> stream) async* {
  await for (var s in stream) {
    yield* s;
//    await for (var i in s) {
//      yield i;
//    }
  }
}

main() async {
  sumStream(countStream(10))
      .then((i) => print("sumStream $i"))
      .then((_) => 14)
      .then((i) => print("then $i"))
      .catchError(print);

  Stream<int> stream = countStream(10);
  stream = flatten(stream.asyncMap((_) => countStream(10)));
  stream.map((i) => "$i").transform(LineSplitter());
  int sum = await sumStream(stream);
  print("sum = $sum"); // 55
}
