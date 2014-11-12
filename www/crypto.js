require('cordova/argscheck'),
channel = require('cordova/channel'),	    
utils = require('cordova/utils'),
exec = require('cordova/exec'),
cordova = require('cordova');
	
function Crypto(){
};
	
Crypto.prototype.encrypt = function(successCallback, errorCallback, params) {
	var plainText 	= params.text || '';
	var returnTo 	= params.returnTo || function(){};
	exec(successCallback, errorCallback, "Crypto", "encrypt", [{data: plainText}]);
};
	
Crypto.prototype.decrypt = function(successCallback, errorCallback) {
	exec(successCallback, errorCallback, "Crypto", "decrypt", [{data: encString}]);
};

Crypto.prototype.test = function() {
	return "test complete";
};

module.exports = new Crypto();