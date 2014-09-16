//
//  request.m
//  Network
//
//  Created by MacBook Pro on 14-4-11.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import "request.h"

@implementation request
-(id)init
{
    self.resultData = [[NSMutableData alloc] init];
    return self = [super init];
}

-(void)sendRequest:(NSString *)requestString success:(void (^)(NSMutableData *))sBlock fail:(void (^)(NSError *))fBlock
{
    self.successBlock = sBlock;
    self.failBlock = fBlock;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (_resultData) {
        _resultData = [[NSMutableData alloc] init];
    }else
    {
        [_resultData setLength:0];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.resultData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (_failBlock) {
        _failBlock(error);
    }
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_successBlock) {
        _successBlock(self.resultData);
    }
//    [connection cancel];
}
@end
