import "package:speanmeas/core/endpoint.g.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/dio.dart"; // ignore: unused_import
import "package:speanmeas/core/utility/pprint.dart"; // ignore: unused_import
import "package:speanmeas/core/widget/snackbar.dart"; // ignore: unused_import
import "package:speanmeas/core/theme/theme_data.dart"; // ignore: unused_import

class Room {
	static final Room instance = Room._();
	Room._();

	final ID = "_id";
	final NUMBER = "number";
	final USD_PER_DAY = "usd_per_day";
	final USD_PER_3H = "usd_per_3h";
	final KIND = "kind";
	final STATUS = "status";
	final NOTE = "note";
	final FRONT_DESK_ID = "front_desk_id";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Room sm_room = Room.instance;
