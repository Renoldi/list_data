import 'package:flutter/material.dart';
import 'package:list_data/list_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'list_data Example', home: const DemoPage());
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final ListDataComponentController<String> _controller =
      ListDataComponentController<String>();

  // Removed unused helper `_fakeDataSource` to silence analyzer warning.

  // Simulated server-style paged data source.
  // - `offset` is the current loaded count (used as start index on server)
  // - `search` filters server-side before paging
  Future<List<String>> _serverPagedDataSource(
    int offset,
    String? search,
  ) async {
    debugPrint(
      'example._serverPagedDataSource: called offset=$offset search=$search',
    );
    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 500));

    const int pageSize = 10;
    // Simulate a server dataset of 100 items
    final all = List<String>.generate(100, (i) => 'Server Item ${i + 1}');

    // Apply server-side search/filtering first
    final filtered =
        (search != null && search.isNotEmpty)
            ? all
                .where((s) => s.toLowerCase().contains(search.toLowerCase()))
                .toList()
            : all;

    final start = offset;
    if (start >= filtered.length) {
      debugPrint(
        'example._serverPagedDataSource: no more items (start=$start >= ${filtered.length})',
      );
      return <String>[];
    }

    final end = (start + pageSize).clamp(0, filtered.length);
    final page = filtered.sublist(start, end);
    debugPrint(
      'example._serverPagedDataSource: returning ${page.length} items (start=$start end=$end total=${filtered.length})',
    );
    return page;
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('list_data Example')),
      body: Column(
        children: [
          ValueListenableBuilder<ListDataComponentValue<String>>(
            valueListenable: _controller,
            builder: (context, value, child) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'state: ${value.state} — items: ${value.data.length}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    if (value.state == ListDataComponentState.loading)
                      const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: ListDataComponent<String>(
              controller: _controller,
              enableAutoRefreshOnTop: true,
              // Customize refresh indicator appearance from the example
              refreshColor: Theme.of(context).colorScheme.primary,
              refreshBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              refreshDisplacement: 60.0,
              refreshEdgeOffset: 0.0,
              showSearchBox: true,
              searchHint: 'Cari item',

              // Use a simulated server-style paged data source and start empty.
              dataSource:
                  (offset, search) => _serverPagedDataSource(offset, search),
              autoLoad: true,
              itemBuilder: (data, index) {
                final title = data ?? 'Loading...';
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text(title),
                    // subtitle: Text('Index: $index'),
                  ),
                );
              },
              onSelected: (val) {
                if (val != null) _showSnack('Terpilih: $val');
              },
              // Enable drag in the example so the user can reorder items after refresh.
              enableDrag: true,
              // Handle dropped data by reordering the underlying list.
              onReceiveDropedData: (item, targetIndex) {
                final list = _controller.value.data;
                final oldIndex = list.indexOf(item);
                if (oldIndex == -1) return;
                final removed = list.removeAt(oldIndex);
                var insertIndex = targetIndex;
                if (insertIndex > list.length) insertIndex = list.length;
                // Adjust insert index when removing an earlier element.
                if (insertIndex > oldIndex) insertIndex = insertIndex - 1;
                list.insert(insertIndex, removed);
                _controller.commit();
              },
              // Provide a clear textual empty view with a button to load data.
              // emptyWidget: Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'Tidak ada item',
              //         style: Theme.of(context).textTheme.bodyMedium,
              //       ),
              //       const SizedBox(height: 12),
              //       ElevatedButton(
              //         onPressed: () {
              //           if (_controller.value.dataSource == null) {
              //             _controller.value.dataSource =
              //                 (offset, search) =>
              //                     _fakeDataSource(offset, search);
              //           }
              //           _controller.refresh();
              //         },
              //         child: const Text('Muat data'),
              //       ),
              //     ],
              //   ),
              // ),
              emptyDataText: 'Tidak ada item',
              showMoreText: 'Lebih banyak',
              loaderCount: 3,
            ),
          ),
        ],
      ),
      // No floating action button — loading is triggered from the empty view.
    );
  }
}
