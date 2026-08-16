class Server_side_event {
	static final Server_side_event instance = Server_side_event._();
	Server_side_event._();

	final ID = "_id";
	final NOTE = "note";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Server_side_event sm_server_side_event = Server_side_event.instance;
