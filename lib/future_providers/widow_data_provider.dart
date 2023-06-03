import 'package:riverpod/riverpod.dart';

import '../repo/entry_repo.dart';

final entryProvider = Provider<EntryRepository>((ref) => EntryRepository());

final widowDataProvider = FutureProvider((ref) async {
  return ref.watch(entryProvider).getWidoData();
});
