//
//  CDVCrypto.m
//  OUAnywhere
//
//  Created by Paul.Hogan on 09/07/2013.
//  Copyright (c) 2013 The Open University. All rights reserved.
//

#import "CDVCrypto.h"
#import "RNEncryptor.h"
#import "RNDecryptor.h"

@implementation CDVCrypto {
    
    CDVPluginResult *pluginResult;
    
    NSString *callbackID;
}

-(void)encrypt:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options {
    
    callbackID = [arguments objectAtIndex:0];
    
    NSError *error = nil;
    
    NSData *data = [RNEncryptor encryptData:[[options objectForKey:@"data"] dataUsingEncoding:NSUTF8StringEncoding]
                               withSettings:kRNCryptorAES256Settings
                                   password:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] bundleIdentifier], [[NSBundle mainBundle] bundlePath]]
                                      error:&error];

    if (error) {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"encryption error"];
        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    }
    else {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[data base64EncodedString]];
        
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];        
    }
}

-(void)decrypt:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options {
   
    callbackID = [arguments objectAtIndex:0];
    
    NSError *error = nil;
    
    NSData *data = [RNDecryptor decryptData:[NSData dataFromBase64String:[options objectForKey:@"data"]]
                               withPassword:[NSString stringWithFormat:@"%@%@",[[NSBundle mainBundle] bundleIdentifier], [[NSBundle mainBundle] bundlePath]]
                                      error:&error];
    
    if (error) {
        
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:@"decryption error"];
        
        [self writeJavascript: [pluginResult toErrorCallbackString:callbackID]];
    }
    else {
        
         pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:[[NSString alloc] initWithUTF8String:[data bytes]]];
        
        [self writeJavascript: [pluginResult toSuccessCallbackString:callbackID]];
    }
}

@end
