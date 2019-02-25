import 'package:meta/meta.dart';

class A {
  const A();
}

class B extends A {
  const B();
}

class C extends B {}

int fib({@required int n}) => n > 2 ? fib(n: n - 1) + fib(n: n - 2) : 1;

fk({int n}) => "fk $n";

void main() {
  final List<B> q = const [B()];
  const q2 = const B();
  print(q);
  print(q2);
  print(true ? 1 : 2);

  const foo = const [];
//  foo = [1, 2, 3];

  const List<Object> constantList = const [1, 2.0, 3, false, "", B()];

  const Map<Object, String> gifts = {
    'first': 'partridge',
    'second': 'turtledoves',
    'fifth': 'golden rings',
    B(): ""
  };

  final Map<int, String> nobleGases = Map<int, String>();
  nobleGases[2] = 'helium';
  nobleGases[10] = 'neon';
  nobleGases[18] = 'argon';

  print(nobleGases);

  for (var i in [1, 2, 3, 4, 5, 6, 7, 8, 9]) {
    print("$i ${fib(n: i)}");
  }

  const f = fib;

  print(fk());
  print(fk(n: 4));

  print(51 / 2);
  print(51 ~/ 2);
  print(51 % 2);

  try {
    throw FormatException("ex");
  } on FormatException catch (e, s) {
    print(e);
    print(s);
  }

  print("$q ${q.runtimeType}");
  print("$q2 ${q2.runtimeType}");

  print(Z("f").f());

  List<int> a1 = List<int>()..length = 10;
  List<int> a2 = <int>[1, 2, 3];
  a1.add(12);
  a2.add(12);
  print(a1);
  print(a2);
  a1.length = 2;
  print(a1);
}

abstract class Z {
  int f();

  factory Z(String s) => X();
}

class X implements Z {
  @override
  int f() => 26141918;
}
