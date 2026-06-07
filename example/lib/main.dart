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

  Future<List<String>> _fakeDataSource(int offset, String? search) async {
    await Future.delayed(const Duration(milliseconds: 600));
    final all = List<String>.generate(50, (i) => 'Item ${i + 1}');
    final start = offset;
    final end = (start + 10).clamp(0, all.length);
    var page = <String>[];
    if (start < end) page = all.sublist(start, end);
    if (search != null && search.isNotEmpty) {
      page =
          page
              .where((s) => s.toLowerCase().contains(search.toLowerCase()))
              .toList();
    }
    return page;
  }

  void _showSnack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('list_data Example')),
      body: ListDataComponent<String>(
        controller: _controller,
        showSearchBox: true,
        searchHint: 'Cari item',
        dataSource: (offset, search) => _fakeDataSource(offset, search),
        itemBuilder: (data, index) {
          final title = data ?? 'Loading...';
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(title),
              subtitle: Text('Index: $index'),
            ),
          );
        },
        onSelected: (val) {
          if (val != null) _showSnack('Terpilih: $val');
        },
        emptyDataText: 'Tidak ada item',
        showMoreText: 'Lebih banyak',
        loaderCount: 3,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _controller.refresh();
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
