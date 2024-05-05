import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_tunes/common/utils.dart';

void main() {
  /// Unit Test for Utility Function that returns a two digit string for showing duration.
  group('Returning two digit string utility function', () {
    test('returns a two-digit string with leading zero for single-digit input',
        () {
      const testInput = 5;

      final result = Utils.twoDigits(testInput);

      // Assertion
      expect(result, '05');
    });

    test('returns the original string for two-digit input', () {
      const testInput = 12;

      final result = Utils.twoDigits(testInput);

      // Assertion
      expect(result, '12');
    });
  });
}
