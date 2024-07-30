import 'package:pocketbase/pocketbase.dart';

final AuthStore _store = AuthStore();

final PocketBase pb = PocketBase(
  'https://server-proklinik.fly.dev',
  authStore: _store,
);
