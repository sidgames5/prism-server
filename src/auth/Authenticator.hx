package auth;

import haxe.crypto.Base64;
import haxe.crypto.Sha224;
import haxe.crypto.Sha256;
import haxe.crypto.Sha1;
import haxe.Int64;
import haxe.Int32;
import haxe.io.Bytes;
import util.Instructions.*;

class Authenticator {
	/**
	 * Validates a user
	 * @param username The username to check
	 * @param password The user's hashed password
	 * @return Key, returns null if the user cannot be validated
	 * @since 0.1
	 */
	public static function login(username:String, password:Bytes):Int {
		var code = FAILURE;

		return code;
	}

	public static function getPasswordHash(username:String):Bytes {
		return null;
	}
}
