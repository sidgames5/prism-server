package crypto;

import haxe.crypto.Base64;
import haxe.crypto.mode.Mode;
import haxe.crypto.TwoFish;
import haxe.crypto.Aes;
import haxe.io.Bytes;

class Encryption {
	/**
	 * Encrypts data with our algorithm
	 * @param x Data to encrypt
	 * @param key 128, 192, or 256 bit encryption/decryption key
	 * @return Encrypted data
	 * @since 0.1
	 */
	public static function encrypt(x:Bytes, key:Bytes):Bytes {
		var twofish = new TwoFish();
		twofish.init(key);

		var f = Bytes.ofString(Base64.encode(x));
		f = twofish.encrypt(Mode.PCBC, f);
		f = Bytes.ofString(Base64.encode(f));

		return f;
	}

	/**
	 * Decrypts data with our algorithm
	 * @param x Encrypted data
	 * @param key 128, 192, or 256 bit encryption/decryption key
	 * @return Decrypted data
	 * @since 0.1
	 */
	public static function decrypt(x:Bytes, key:Bytes):Bytes {
		var twofish = new TwoFish();
		twofish.init(key);

		var f = Base64.decode(x.toString());
		f = twofish.decrypt(Mode.PCBC, f);
		f = Base64.decode(f.toString());

		return f;
	}
}
