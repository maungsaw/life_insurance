/// Guest vs signed-in prototype session (docs/74). No Core token.
abstract final class GuestSession {
  static bool signedIn = false;

  static bool get isGuest => !signedIn;

  static void signIn() => signedIn = true;

  static void signOut() => signedIn = false;
}
