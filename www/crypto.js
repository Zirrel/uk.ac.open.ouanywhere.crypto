cordova.define("uk.ac.open.ouanywhere.crypto", function(require, exports, module) {

	var argscheck = require('cordova/argscheck'),
	    channel = require('cordova/channel'),
	    utils = require('cordova/utils'),
	    exec = require('cordova/exec'),
	    cordova = require('cordova');
	
	Crypto.prototype.encrypt = function(successCallback, errorCallback) {
	    exec(successCallback, errorCallback, "Crypto", "encrypt", []);
	};
	
	Crypto.prototype.decrypt = function(successCallback, errorCallback) {
	    exec(successCallback, errorCallback, "Crypto", "decrypt", []);
	};
	
	module.exports = new Crypto();

}
