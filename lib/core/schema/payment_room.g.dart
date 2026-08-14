class Payment_room {
	static final Payment_room instance = Payment_room._();
	Payment_room._();

	final ID = "_id";
	final FRONT_DESK_ID = "front_desk_id";
	final PAY_PRICE = "pay_price";
	final PAY_CASH = "pay_cash";
	final PAY_BANK = "pay_bank";
	final PAY_RETURN = "pay_return";
	final PAY_NOTE = "pay_note";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Payment_room sm_payment_room = Payment_room.instance;
