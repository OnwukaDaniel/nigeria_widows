import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nigerian_widows/repo/chart_entry_repo.dart';

final chartProvider = Provider<ChartEntryRepo>((ref)=> ChartEntryRepo());

final chartFutureProvider = FutureProvider((ref) async {
  return ref.watch(chartProvider).getChartData();
});

