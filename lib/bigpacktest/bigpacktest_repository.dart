import 'package:inavconfiurator/bigpacktest/index.dart';

class BigpacktestRepository {
  final BigpacktestProvider _bigpacktestProvider = BigpacktestProvider();

  BigpacktestRepository();

  void test(bool isError) {
    _bigpacktestProvider.test(isError);
  }
}