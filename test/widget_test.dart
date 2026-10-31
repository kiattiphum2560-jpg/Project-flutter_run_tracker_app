
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_run_tracker_app/main.dart';

void main() {
  testWidgets('app starts on the run tracker splash screen', (tester) async {
    await tester.pumpWidget(const Runtwickerapp());

    expect(find.text('RUN TRACKER'), findsOneWidget);
  });
}
