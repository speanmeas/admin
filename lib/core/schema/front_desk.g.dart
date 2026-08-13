class Front_desk {
	static final Front_desk instance = Front_desk._();
	Front_desk._();

	final ID = "_id";
	final ROOM_ID = "room_id";
	final GUEST_ID = "guest_id";
	final CHECK_IN_DAY = "check_in_day";
	final CHECK_IN_HOUR = "check_in_hour";
	final CHECK_IN_NUMBER = "check_in_number";
	final CHECK_IN_DUE = "check_in_due";
	final CHECK_IN_NOTE = "check_in_note";
	final CHECK_IN_AT = "check_in_at";
	final CHECK_IN_BY = "check_in_by";
	final CANCEL_NOTE = "cancel_note";
	final CANCEL_AT = "cancel_at";
	final CANCEL_BY = "cancel_by";
	final PAY_ROOM = "pay_room";
	final PAY_MINI_BAR = "pay_mini_bar";
	final PAY_OTHER = "pay_other";
	final CHANGE_NOTE = "change_note";
	final CHANGE_AT = "change_at";
	final CHANGE_BY = "change_by";
	final CHECK_OUT_NOTE = "check_out_note";
	final CHECK_OUT_AT = "check_out_at";
	final CHECK_OUT_BY = "check_out_by";
	final CLEAN_NOTE = "clean_note";
	final CLEAN_AT = "clean_at";
	final CLEAN_BY = "clean_by";
	final BROKE_NOTE = "broke_note";
	final BROKE_AT = "broke_at";
	final BROKE_BY = "broke_by";
	final FIX_NOTE = "fix_note";
	final FIX_AT = "fix_at";
	final FIX_BY = "fix_by";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Front_desk sm_front_desk = Front_desk.instance;
