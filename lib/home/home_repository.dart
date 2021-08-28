import 'package:inavconfiurator/home/index.dart';

class HomeRepository {
  final HomeProvider _homeProvider = HomeProvider();

  HomeRepository();

  void test(bool isError) {
    _homeProvider.test(isError);
  }
}