package database;

import sys.io.File;
import haxe.Json;
import haxe.io.Path;
import util.structs.DB;

class Database {
	private static final path = Path.join([Sys.getCwd(), "db/db.json"]);

	public static function read():DB {
		return Json.parse(File.getContent(path));
	}

	public static function write(content:DB) {
		File.saveContent(path, Json.stringify(content));
	}
}
