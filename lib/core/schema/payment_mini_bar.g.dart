class Payment_mini_bar {
	static final Payment_mini_bar instance = Payment_mini_bar._();
	Payment_mini_bar._();

	final ID = "_id";
	final FRONT_DESK_ID = "front_desk_id";
	final ITEM_ID = "item_id";
	final ITEM_QUANTITY = "item_quantity";
	final ADD_PRICE = "add_price";
	final SUB_PRICE = "sub_price";
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

Payment_mini_bar sm_payment_mini_bar = Payment_mini_bar.instance;
