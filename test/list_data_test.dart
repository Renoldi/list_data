// import 'package:flutter_test/flutter_test.dart';
// import 'package:list_data/list_data.dart';
// import 'package:list_data/list_data_platform_interface.dart';
// import 'package:list_data/list_data_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockListDataPlatform
//     with MockPlatformInterfaceMixin
//     implements ListDataPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final ListDataPlatform initialPlatform = ListDataPlatform.instance;

//   test('$MethodChannelListData is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelListData>());
//   });

//   test('getPlatformVersion', () async {
//     ListData listDataPlugin = ListData();
//     MockListDataPlatform fakePlatform = MockListDataPlatform();
//     ListDataPlatform.instance = fakePlatform;

//     expect(await listDataPlugin.getPlatformVersion(), '42');
//   });
// }
