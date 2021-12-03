import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scrobbler/scrobbler.dart';

void main() {
  const MethodChannel channel = MethodChannel('scrobbler');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return true;
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Scrobbler.canStart(), true);
  });
}
