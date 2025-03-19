import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'list_data_platform_interface.dart';

/// An implementation of [ListDataPlatform] that uses method channels.
class MethodChannelListData extends ListDataPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('list_data');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
