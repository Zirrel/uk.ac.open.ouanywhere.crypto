//
//  CDVCrypto.h
//  OUAnywhere
//
//  Created by Paul.Hogan on 09/07/2013.
//  Copyright (c) 2013 The Open University. All rights reserved.
//

#import <Cordova/CDV.h>

@interface CDVCrypto : CDVPlugin

-(void)encrypt:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;
-(void)decrypt:(NSMutableArray *)arguments withDict:(NSMutableDictionary*)options;

@end
