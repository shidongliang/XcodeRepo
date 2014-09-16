//
//  request.h
//  Network
//
//  Created by MacBook Pro on 14-4-11.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface request : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property (nonatomic,retain) NSMutableData *resultData;
@property (nonatomic,strong) void (^ successBlock) (NSMutableData * data);
@property (nonatomic,strong) void (^failBlock) (NSError * error);
-(id)init;
-(void)sendRequest:(NSString *) requestString success:(void (^)(NSMutableData *)) sBlock fail:(void (^)(NSError *)) fBlock;
@end
