import 'package:hive_ce_flutter/hive_flutter.dart';

abstract class BaseStorage<Keys, ValueType> {
  String get boxName;

  Future<Box<ValueType>> getBox() async => Hive.openBox<ValueType>(boxName);

  Future<void> saveItem({required Keys key, required ValueType value}) async {
    final box = await getBox();
    await box.put(key.toString(), value);
  }

  Future<void> clear() async {
    final box = await getBox();
    await box.clear();
  }

  Future<ValueType?> getByKey(Keys key) async => (await getBox()).get(key.toString());
}
