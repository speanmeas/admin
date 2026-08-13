class Setting {
	static final Setting instance = Setting._();
	Setting._();

	final ID = "_id";
	final KEY = "key";
	final VALUE = "value";
	final NOTE = "note";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Setting sm_setting = Setting.instance;
