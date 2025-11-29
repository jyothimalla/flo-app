import 'package:flutter_test/flutter_test.dart';
import 'package:flo_app/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('App starts and shows login', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: FloApp()));
    await tester.pumpAndSettle();

    expect(find.text('Flo — Login'), findsOneWidget);
    expect(find.text('Sign in (demo)'), findsOneWidget);
  });
}
