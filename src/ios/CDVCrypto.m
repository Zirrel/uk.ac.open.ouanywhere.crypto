//
//  CDVCrypto.m
//  OUAnywhere
//

#import "CDVCrypto.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@implementation CDVCrypto {
    CDVPluginResult *pluginResult;
    NSString *callbackID;
}

-(void)test:(CDVInvokedUrlCommand *)command {
    callbackID = command.callbackId;
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@"Crypto"];
    
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)encrypt:(CDVInvokedUrlCommand *)command {
    callbackID = command.callbackId;
    
    NSMutableDictionary* options = [command.arguments objectAtIndex:0];
    NSError *error = nil;

    NSData *data = [RNEncryptor encryptData:[[options objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                               withSettings:kRNCryptorAES256Settings
                                   password:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] bundleIdentifier], [[NSBundle mainBundle] bundlePath]]
                                      error:&error];

    if (error) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"encryption error"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[data base64EncodedString]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

-(void)decrypt:(CDVInvokedUrlCommand *)command {
    callbackID = command.callbackId;
    
    NSMutableDictionary* options = [command.arguments objectAtIndex:0];
    NSError *error = nil;
    
    NSData *data = [RNDecryptor decryptData:[NSData dataFromBase64String:[options objectForKey:@"data"]]
                               withPassword:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] bundleIdentifier], [[NSBundle mainBundle] bundlePath]]
                                      error:&error];
    
    if (error) {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"decryption error"];
    } else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSString alloc] initWithUTF8String:[data bytes]]];
    }

    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}

@end
