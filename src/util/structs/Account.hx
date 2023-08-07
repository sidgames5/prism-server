package util.structs;

import haxe.io.Bytes;

typedef Account = {
	username:String,
	userID:Int,
	password:String,
	profile:{
		displayName:String, pfp:Bytes, bio:String
	}
}
