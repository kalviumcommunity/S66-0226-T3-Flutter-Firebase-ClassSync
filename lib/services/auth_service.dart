import 'package:firebase_auth/firebase_auth.dart';

/// AuthService — wraps Firebase Authentication for email/password flows.
///
/// Concepts demonstrated:
///  - async/await with Firebase futures
///  - Null safety (User? return types)
///  - Stream for reactive auth state listening
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ── Auth state stream ────────────────────────────────────────────────────
  /// Emits a [User] whenever auth state changes (login, logout, token refresh).
  /// Used in AuthScreen to reactively rebuild the UI.
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// The currently signed-in user, or null if not logged in.
  User? get currentUser => _auth.currentUser;

  // ── Sign Up ──────────────────────────────────────────────────────────────
  /// Creates a new user account with email and password.
  /// Returns a human-readable error string on failure, or null on success.
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    }
  }

  // ── Sign In ──────────────────────────────────────────────────────────────
  /// Signs in an existing user with email and password.
  /// Returns a human-readable error string on failure, or null on success.
  Future<String?> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _friendlyError(e.code);
    }
  }

  // ── Sign Out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // ── Error helper ─────────────────────────────────────────────────────────
  String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'That email is already registered. Try signing in.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-credential':
        return 'Invalid credentials. Check your email and password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return 'Auth error: $code';
    }
  }
}
