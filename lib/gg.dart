import 'dart:math';

class Bicycle {
  int cadence;
  int _speed = 42;

  int get speed => _speed;
  int gear;

  Bicycle(this.cadence, this.gear);

  @override
  String toString() => "Bicycle: $_speed mph";

  void applyBrake(int decrement) {
    _speed -= decrement;
  }

  void speedUp(int increment) {
    _speed += increment;
  }
}

class Rectangle {
  int width;
  int height;
  Point origin;

  Rectangle({this.origin = const Point(0, 0), this.width = 0, this.height = 0});

  @override
  String toString() =>
      'Origin: (${origin.x}, ${origin.y}), width: $width, height: $height';
}

abstract class Shape {
  num get area;

  factory Shape(String type) {
    if (type == 'circle') return Circle(3);
    if (type == 'square') return Square(2);
    throw 'Can\'t create $type.';
  }
}

class Circle implements Shape {
  final num radius;

  Circle(this.radius);

  num get area => pi * pow(radius, 2);
}

class Square implements Shape {
  final num side;

  Square(this.side);

  num get area => pow(side, 2);
}

class CircleMock implements Circle {
  num area;
  num _radius;

  num get radius => _radius;
}

String scream(int length) => "A${'a' * length}h!";

void main() {
  final bike = Bicycle(2, 1);
  print(bike);
  print(bike.gear);
  print(bike.speed);
  print(bike._speed);

  print(Rectangle(origin: const Point(10, 20), width: 100, height: 200));
  print(Rectangle(origin: const Point(10, 10)));
  print(Rectangle(width: 200));
  print(Rectangle());

  final circle = Shape('circle');
  final square = Shape('square');
  print(circle.area);
  print(square.area);

  final values = [1, 2, 3, 5, 10, 50];
  values.where((i) => i > 5).map(scream).forEach(print);
}
