class Web_socket {
	static final Web_socket instance = Web_socket._();
	Web_socket._();

	final ID = "_id";
	final NOTE = "note";
	final CREATED_AT = "created_at";
	final CREATED_BY = "created_by";
	final UPDATED_AT = "updated_at";
	final UPDATED_BY = "updated_by";
	final DELETED_AT = "deleted_at";
	final DELETED_BY = "deleted_by";
}

Web_socket sm_web_socket = Web_socket.instance;
