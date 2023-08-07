package database;

import util.structs.Message;

class Messages {
	public static function get():Array<Message> {
		return Database.read().messages;
	}

	public static function append(message:Message) {
		var db = Database.read();
		db.messages.push(message);
		Database.write(db);
	}
}
