class Payment_room {
	static final Payment_room instance = Payment_room._();
	Payment_room._();

	final ID = "_id";
	final ADD_PRICE = "add_price";
	final SUB_PRICE = "sub_price";
	final ADD_CASH = "add_cash";
	final ADD_BANK = "add_bank";
	final SUB_RETURN = "sub_return";
	final NOTE = "note";
	final FRONT_DESK_ID = "front_desk_id";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Payment_room sm_payment_room = Payment_room.instance;
