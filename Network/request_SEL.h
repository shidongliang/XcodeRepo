//
//  request_SEL.h
//  Network
//
//  Created by MacBook Pro on 14-4-12.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface request_SEL : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,weak) id delegate;
@property(nonatomic,retain) NSMutableDictionary *connection_Dic;
+(request_SEL*)sharedRequest_SEL;
-(id)init;
-(void)postRequest:(NSString *)requestString delegate:(id)delegate successAction:(SEL) success failAction:(SEL) fail;
-(void)cancelConnnection:(NSString *)connection_URL;
-(void)cancelAllConnection;
@end
