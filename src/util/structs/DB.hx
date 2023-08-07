package util.structs;

import util.structs.Config;
import util.structs.Account;
import util.structs.Message;

typedef DB = {
	messages:Array<Message>,
	users:Array<Account>,
	config:Config
}
