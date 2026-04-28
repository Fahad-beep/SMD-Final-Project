import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:smd_final_project/src/features/widgets/common_widgets.dart';

void main() {
  testWidgets('section header renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeader(
            title: 'Smart Travel Companion',
            subtitle: 'A polished assignment build.',
          ),
        ),
      ),
    );

    expect(find.text('Smart Travel Companion'), findsOneWidget);
    expect(find.text('A polished assignment build.'), findsOneWidget);
  });
}
