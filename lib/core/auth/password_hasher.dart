import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Hashes and verifies user passwords for the local credential store.
///
/// Uses SHA-256 over an application salt plus the password. Suitable for an
/// offline, internal, single-tenant deployment; for a networked system this
/// should be upgraded to a per-user salt with a slow KDF (e.g. bcrypt).
abstract final class PasswordHasher {
  static const String _salt = 'markaz_as_shabab::v1';

  static String hash(String password) {
    final bytes = utf8.encode('$_salt::$password');
    return sha256.convert(bytes).toString();
  }

  static bool verify(String password, String hash) =>
      PasswordHasher.hash(password) == hash;
}
