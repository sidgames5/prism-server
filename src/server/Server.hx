package server;

import database.Messages;
import util.structs.Message;
import util.structs.Author;
import haxe.crypto.Hmac;
import auth.Authenticator;
import util.Instructions;
import crypto.Encryption;
import haxe.Json;
import haxe.io.Bytes;
import haxe.crypto.Sha256;
import util.structs.Request;
import hx_webserver.HTTPResponse;
import hx_webserver.HTTPRequest;
import hx_webserver.HTTPServer;
import util.Instructions.*;

class Server {
	private static var server:HTTPServer;

	public static function init(host:String, port:Int) {
		server = new HTTPServer(host, port, true);
		server.onClientConnect = handle;
	}

	public static function handle(d:HTTPRequest) {
		var r = new HTTPResponse();
		var dfkey = Sha256.make(Bytes.ofString("DEFAULT"));
		var key:Bytes = Sha256.make(Bytes.ofString("DEFAULT"));
		if (Std.parseInt(d.getHeaderValue("Prism/Encrypted")) == TRUE) {
			var username = Bytes.ofHex(d.getHeaderValue("Prism/Username"));
			key = Authenticator.getPasswordHash(username.toString());
		}

		if (Std.parseInt(d.getHeaderValue("Prism/API_Level")) >= Version.CURRENT.getLevel()) {
			var username = Bytes.ofHex(d.getHeaderValue("Prism/Username"));
			key = Authenticator.getPasswordHash(username.toString());
			var data:Request;
			if (Std.parseInt(d.getHeaderValue("Prism/Encrypted")) == FALSE) {
				key = Sha256.make(Bytes.ofString("DEFAULT"));
			}
			data = Json.parse(Encryption.decrypt(Bytes.ofHex(d.postData), key).toString());

			switch (data.instruction) {
				case LOGIN:
					var username:String = "";
					var password:Bytes = null;
					for (param in data.params) {
						if (param.key == USERNAME)
							username = param.value;
						if (param.key == PASSWORD)
							password = Bytes.ofHex(param.value);
					}
					if (username != null || password != null) {
						var c:Request = {instruction: REPLY, params: []};
						var at = Authenticator.login(username, password);
						c.params.push({key: STATUS, value: at});
						r.content = Json.stringify(c);
					} else {
						r.content = "Missing data";
						r.statusCode = 400;
					}
				case PING:
					var c:Request = {
						instruction: REPLY,
						params: [{key: TIME, value: Sys.time()}]
					};
					r.content = Json.stringify(c);
				case READ:
					if (key != dfkey) {
						var count = 1;
						for (param in data.params) {
							if (param.key == COUNT)
								count = Std.parseInt(param.value);
						}
						var c:Request = {
							instruction: REPLY,
							params: []
						};
						// TODO: Get message history
						r.content = Json.stringify(c);
					} else {
						var c:Request = {
							instruction: REPLY,
							params: [{key: ERROR, value: RESTRICTED}]
						};
						r.content = Json.stringify(c);
					}
				case WRITE:
					if (key != dfkey) {
						var message:Message = null;
						for (param in data.params)
							if (param.key == MESSAGE)
								message = param.value;
						Messages.append(message);
					} else {
						var c:Request = {
							instruction: REPLY,
							params: [{key: ERROR, value: RESTRICTED}]
						};
						r.content = Json.stringify(c);
					}
				default:
					r.content = "Unsupported";
					r.statusCode = 501;
			}
		} else {
			r.content("Incompatible API");
			r.statusCode = 426;
		}

		r.content = Encryption.encrypt(Bytes.ofString(r.content), key).toHex();

		d.replyRaw(r.prepare());
	}
}
