enum LoginStatus {
  /// User exists but not logged in
  unauthenticated,

  /// New user to the application
  newUser,

  /// User logged into the app
  loggedIn,

  /// Unknown status
  unknown,
}
