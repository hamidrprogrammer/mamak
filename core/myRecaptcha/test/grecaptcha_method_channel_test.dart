import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_recaptcha/grecaptcha_method_channel.dart';

void main() {
  MethodChannelGrecaptcha platform = MethodChannelGrecaptcha();
  const MethodChannel channel = MethodChannel('grecaptcha');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
