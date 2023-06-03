import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_widows/repo/chart_entry_repo.dart';
import '../future_providers/widow_data_provider.dart';
import '../repo/entry_repo.dart';

final homePageControllerProvider = Provider((ref) {
  final entryRepository = ref.watch(entryRepositoryProvider);
  return HomePageController(ref: ref, entryRepository: entryRepository);
});

class HomePageController {
  final ProviderRef ref;
  final EntryRepository entryRepository;

  HomePageController({required this.ref, required this.entryRepository});

  getWidowData({int input = -1}) {
    entryRepository.getWidoData(index: input);
    ref.refresh(entryProvider);
  }
}

final chartControllerProvider = Provider((ref) {
  final chartRepository = ref.watch(chartRepositoryProvider);
  return ChartController(ref: ref, entryRepository: chartRepository);
});

class ChartController {
  final ProviderRef ref;
  final ChartEntryRepo entryRepository;

  ChartController({required this.ref, required this.entryRepository});

  getAllUsers() {
    entryRepository.getChartData();
    ref.refresh(entryProvider);
  }
}