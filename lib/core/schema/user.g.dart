class User {
  static final User instance = User._();
  User._();

  final ID = "_id";
  final USERNAME = "username";
  final PASSWORD = "password";
  final FULL_NAME = "full_name";
  final PHONE_NUMBER = "phone_number";
  final IS_ADMIN = "is_admin";
  final IS_MANAGER = "is_manager";
  final IS_RECEPTIONIST = "is_receptionist";
  final IS_HOUSEKEEPER = "is_housekeeper";
  final NOTE = "note";
  final ACCESS_TOKEN = "access_token";
  final TOKEN_TYPE = "token_type";
  final CREATED_AT = "created_at";
  final CREATED_BY = "created_by";
  final UPDATED_AT = "updated_at";
  final UPDATED_BY = "updated_by";
  final DELETED_AT = "deleted_at";
  final DELETED_BY = "deleted_by";
}

User sm_user = User.instance;
