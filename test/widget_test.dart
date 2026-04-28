import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kadence/theme/kadence_colors.dart';
import 'package:kadence/theme/kadence_theme.dart';

void main() {
  testWidgets('Theme exposes Kadence color tokens', (tester) async {
    const probe = Key('probe');
    await tester.pumpWidget(
      MaterialApp(
        theme: buildKadenceTheme(Brightness.light),
        home: Builder(
          builder: (context) {
            final colors = context.colors;
            return ColoredBox(key: probe, color: colors.bgBase);
          },
        ),
      ),
    );

    expect(find.byKey(probe), findsOneWidget);
  });
}
