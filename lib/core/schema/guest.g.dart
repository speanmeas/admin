import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import

class Guest {
	static final Guest instance = Guest._();
	Guest._();

	final ID = "_id";
	final FULL_NAME = "full_name";
	final PHONE_NUMBER = "phone_number";
	final GENDER = "gender";
	final NATIONALITY_ID = "nationality_id";
	final ID_NUMBER = "id_number";
	final PASSPORT_NUMBER = "passport_number";
	final NOTE = "note";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Guest sm_guest = Guest.instance;
