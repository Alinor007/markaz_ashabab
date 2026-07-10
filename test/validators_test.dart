// Unit tests for the shared form validators. A trivial widget is pumped only to
// obtain a BuildContext (validators resolve their messages via context.trRead);
// there are no animations to settle.

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:markazosshabab/core/util/validators.dart';

void main() {
  testWidgets('Validators enforce required/numeric/email rules', (tester) async {
    late BuildContext c;
    await tester.pumpWidget(
      Builder(builder: (ctx) {
        c = ctx;
        return const SizedBox();
      }),
    );

    // required — rejects empty/whitespace, accepts content.
    expect(Validators.required(c, ''), isNotNull);
    expect(Validators.required(c, '   '), isNotNull);
    expect(Validators.required(c, null), isNotNull);
    expect(Validators.required(c, 'Aisha'), isNull);

    // optionalInt — empty ok; non-numbers and out-of-range rejected.
    expect(Validators.optionalInt(c, ''), isNull);
    expect(Validators.optionalInt(c, 'abc'), isNotNull);
    expect(Validators.optionalInt(c, '5', min: 1), isNull);
    expect(Validators.optionalInt(c, '0', min: 1), isNotNull);
    expect(Validators.optionalInt(c, '13', max: 12), isNotNull);

    // optionalAmount — empty ok; non-numbers and negatives rejected.
    expect(Validators.optionalAmount(c, ''), isNull);
    expect(Validators.optionalAmount(c, 'abc'), isNotNull);
    expect(Validators.optionalAmount(c, '-1'), isNotNull);
    expect(Validators.optionalAmount(c, '12.5'), isNull);

    // optionalYear — empty ok; range enforced.
    expect(Validators.optionalYear(c, ''), isNull);
    expect(Validators.optionalYear(c, '1800'), isNotNull);
    expect(Validators.optionalYear(c, '${DateTime.now().year}'), isNull);

    // optionalEmail — empty ok; malformed rejected.
    expect(Validators.optionalEmail(c, ''), isNull);
    expect(Validators.optionalEmail(c, 'foo@'), isNotNull);
    expect(Validators.optionalEmail(c, 'foo@bar'), isNotNull);
    expect(Validators.optionalEmail(c, 'a@b.co'), isNull);

    // password — required + min length.
    expect(Validators.password(c, ''), isNotNull);
    expect(Validators.password(c, 'abc'), isNotNull);
    expect(Validators.password(c, 'abcd'), isNull);
  });
}
