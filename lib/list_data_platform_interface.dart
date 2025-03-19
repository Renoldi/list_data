import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'list_data_method_channel.dart';

abstract class ListDataPlatform extends PlatformInterface {
  /// Constructs a ListDataPlatform.
  ListDataPlatform() : super(token: _token);

  static final Object _token = Object();

  static ListDataPlatform _instance = MethodChannelListData();

  /// The default instance of [ListDataPlatform] to use.
  ///
  /// Defaults to [MethodChannelListData].
  static ListDataPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ListDataPlatform] when
  /// they register themselves.
  static set instance(ListDataPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
