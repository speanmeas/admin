class Ws {
	static final Ws instance = Ws._();
	Ws._();

	final ID = "_id";
	final NOTE = "note";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Ws sm_ws = Ws.instance;
