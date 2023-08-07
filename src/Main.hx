import server.Server;
import haxe.crypto.Sha256;
import haxe.crypto.Sha512;
import haxe.io.Bytes;
import crypto.Encryption;

class Main {
	static function main() {
		Server.init("0.0.0.0", 2222);
	}
}
