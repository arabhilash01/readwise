import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:readwise/core/local_storage/base_storage.dart';

class UserDetailsStorage<T extends String> extends BaseStorage<UserStorageDetailsKeys, T> {
  @override
  String get boxName => 'user_details_box';

  Box<T>? openedBox() => Hive.isBoxOpen(boxName) ? Hive.box<T>(boxName) : null;
}

enum UserStorageDetailsKeys {
  userName,
  preferences,
  gender,
  dateOfBirth;

  @override
  String toString() => name;
}
