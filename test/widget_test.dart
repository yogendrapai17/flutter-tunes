// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tunes/app/bloc/app_bloc.dart';
import 'package:flutter_tunes/common/utils.dart';
import 'package:flutter_tunes/common/widgets/animated_search_bar.dart';
import 'package:flutter_tunes/common/widgets/audio_player.dart';

void main() {
  testWidgets('AnimatedSearchBar widget toggle Open/Close',
      (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<AppBloc>(
            create: (_) => AppBloc(),
            child: const AnimatedSearchBar(),
          ),
        ),
      ),
    );

    // Tap on the search button
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();

    // Verify search bar opens and text field exists in UI
    expect(find.byType(TextField), findsOneWidget);

    // Type in the search bar
    await tester.enterText(find.byType(TextField), 'Test search');
    await tester.pump();

    // Tap on the search button again to close
    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();
  });

  testWidgets('Audio Player Widget Test', (WidgetTester tester) async {
    // Build widget for testing.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AudioPlayer(
              audioURL:
                  'https://firebasestorage.googleapis.com/v0/b/flutter-tunes-app.appspot.com/o/Lost%20Sky%20-%20Where%20We%20Started%20(feat.%20Jex)%20%20Melodic%20Dubstep%20%20NCS%20-%20Copyright%20Free%20Music.mp3?alt=media&token=ad2f243e-cf2f-4b06-8170-5c6d7e68a533'),
        ),
      ),
    );

    // Small delay provided for the player controller to be initialized
    await Future.delayed(const Duration(milliseconds: 500));

    // Check if there is a widget for seeker duration 00:00
    expect(find.text(Utils.durationString(Duration.zero)), findsAny);

    //// Find the play button and simulate its press
    await tester.tap(find.byIcon(Icons.play_arrow));

    await Future.delayed(const Duration(milliseconds: 500)).then((value) {
      // Check if the play button turns into pause button once player is started.
      expect(find.byIcon(Icons.pause), findsOneWidget);
    });
  });
}
