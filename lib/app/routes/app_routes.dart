part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const CRUD = _Paths.CRUD;
  static const TODO = _Paths.TODO;
  static const PAYAPP = _Paths.PAYAPP;
  static const CREDITAPP = _Paths.CREDITAPP;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const CRUD = '/crud';
  static const TODO = '/todo';
  static const PAYAPP = '/payapp';
  static const CREDITAPP = '/creditapp';
}
