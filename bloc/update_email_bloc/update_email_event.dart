part of 'update_email_bloc.dart';

@immutable
abstract class UpdateEmailEvent {}

class UpdateEmailUpdate extends UpdateEmailEvent {
  final String newEmail;
  final String password;

  UpdateEmailUpdate(this.newEmail, this.password);
}

class UpdateEmailGet extends UpdateEmailEvent {}
