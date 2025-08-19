import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalDataSource {
  Future<dynamic> read(String key);
  Future<void> write(String key, Map<String, dynamic> value);
  Future<void> remove(String key);
  Future<bool> containsKey(String key);
}

class LocalDataSourceImpl implements LocalDataSource {
  final Box box;

  LocalDataSourceImpl({required this.box});

  @override
  Future<dynamic> read(String key) async => await box.get(key);

  @override
  Future<void> write(String key, Map<String, dynamic> value) async =>
      await box.put(key, value);

  @override
  Future<void> remove(String key) async {
    return await box.delete(key);
  }

  @override
  Future<bool> containsKey(String key) async {
    return box.containsKey(key);
  }
}
