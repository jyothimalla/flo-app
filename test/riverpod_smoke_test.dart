import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final helloProvider = StateProvider<int>((ref) => 1);

void main() {
  test('riverpod works', () {
    final c = ProviderContainer();
    expect(c.read(helloProvider), 1);
    c.read(helloProvider.notifier).state = 2;
    expect(c.read(helloProvider), 2);
  });
}
