part of 'update_password_bloc.dart';

@immutable
abstract class UpdatePasswordEvent {}

class UpdatePasswordUpdate extends UpdatePasswordEvent {
  final String oldPassword;
  final String newPassword;
  final String conformNewPassword;

  UpdatePasswordUpdate(
      this.oldPassword, this.newPassword, this.conformNewPassword);
}

class UpdatePasswordGet extends UpdatePasswordEvent {}
