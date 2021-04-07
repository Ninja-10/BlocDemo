import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parrotspellingapp/bloc/user_bloc/user_bloc.dart';
import 'package:parrotspellingapp/services/firebaseauth_service.dart';
import 'package:parrotspellingapp/services/locator.dart';
import 'package:parrotspellingapp/weidgets/shaired/app.dart';
import 'package:parrotspellingapp/services/analytics_service.dart';

part 'authentication_event.dart';

part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  FirebaseAuthService _firebaseAuthService = locator<FirebaseAuthService>();
  AnalyticsService _analyticsService = locator<AnalyticsService>();

  UserBloc _userBloc;

  AuthenticationBloc(this._userBloc) : super(AuthenticationInitial());

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AuthenticationStarted) {
      yield* _mapAuthenticationStartedToState();
    } else if (event is AuthenticationLoggedOut) {
      yield* _mapAuthenticationLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAuthenticationStartedToState() async* {
    if (_firebaseAuthService.isSignedIn()) {
      final user = _firebaseAuthService.getUser();
      await _analyticsService.setUserProperties(userId: user.uid);
      yield AuthenticationSuccess('Logged in Successfully',
          displayName: user.email);
    }   else {
      yield AuthenticationFailure('Signed out successfully');
    }
  }

  Stream<AuthenticationState> _mapAuthenticationLoggedOutToState() async* {
    await _userBloc.logOut();
    await _firebaseAuthService.signOut();
    await _analyticsService.logLogOut();
    yield AuthenticationFailure('Signed out successfully');
  }
}
