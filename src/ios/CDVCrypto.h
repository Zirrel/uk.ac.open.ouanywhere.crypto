//
//  CDVCrypto.h
//  OUAnywhere
//

#import <Cordova/CDV.h>

@interface CDVCrypto : CDVPlugin

-(void)encrypt:(CDVInvokedUrlCommand *)command;
-(void)decrypt:(CDVInvokedUrlCommand *)command;

-(void)test:(CDVInvokedUrlCommand *)command;

@end
