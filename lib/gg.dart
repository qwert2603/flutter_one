import 'dart:async';

printDailyNewsDigest() async {
  try {
    gatherNewsReports().then(print).catchError(print);
    var newsDigest = await gatherNewsReports();
    print(newsDigest);
  } catch (e) {
    print("error: $e");
  }
}

main() {
  printDailyNewsDigest();
  printWinningLotteryNumbers();
  printWeatherForecast();
  printBaseballScore();
}

printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

printWeatherForecast() {
  print("Tomorrow's forecast: 70F, sunny.");
}

printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}

// Imagine that this function is more complex and slow. :)
Future<String> gatherNewsReports() => Future.delayed(
      Duration(seconds: 1),
      () => "<gathered news goes here>${throw 12}",
    );

// Alternatively, you can get news from a server using features
// from either dart:io or dart:html. For example:
//
// import 'dart:html';
//
// Future<String> gatherNewsReportsFromServer() => HttpRequest.getString(
//      'https://www.dartlang.org/f/dailyNewsDigest.txt',
//    );
