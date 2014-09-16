//
//  request_SEL.m
//  Network
//
//  Created by MacBook Pro on 14-4-12.
//  Copyright (c) 2014年 MacBook Pro. All rights reserved.
//

#import "request_SEL.h"
@interface request_SEL()
@property(nonatomic,retain) NSMutableData *resultData;
@property(nonatomic,assign) SEL success;
@property(nonatomic,assign) SEL fail;
@property(nonatomic,strong) NSURLConnection *connection_SEL;
//@property(nonatomic,retain) NSMutableDictionary *connection_Dic;
@end

@implementation request_SEL
-(id)init
{
    self.resultData = [[NSMutableData alloc] init];
    self.connection_Dic = [[NSMutableDictionary alloc] init];
    return self=[super init];
}

+(request_SEL *)sharedRequest_SEL
{
    static request_SEL *req_SEL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        req_SEL = [[self alloc] init];
    });
    return req_SEL;
}

-(void)postRequest:(NSString *)requestString delegate:(id)delegate successAction:(SEL)success failAction:(SEL)fail
{
    self.delegate = delegate;
    _success = success;
    NSLog(@"%@",(self.success?@"success pass":@"success fail pass"));
    NSLog(@"_success  = %@",NSStringFromSelector(_success));
    _fail = fail;
     NSLog(@"_fail  = %@",NSStringFromSelector(_fail));
    
//    NSRange range;
//    NSString *sub_requestString = nil;
//    range = [requestString rangeOfString:@"?"];
//    sub_requestString = (range.length>0?[requestString substringToIndex:range.location]:requestString);
    if (self.connection_Dic) {
//        NSLog(@"requestString = %@",requestString);
//        NSLog(@" range =  %@",NSStringFromRange(range));
        NSRange range;
        NSString *sub_requestString = nil;
        range = [requestString rangeOfString:@"?"];
        sub_requestString = (range.length>0?[requestString substringToIndex:range.location]:requestString);
        for (NSString *key in [self.connection_Dic allKeys]) {
            NSRange range_key = [key rangeOfString:@"?"];
            NSString *sub_key = nil;
            sub_key = (range_key.length>0?[key substringToIndex:range_key.location]:key);
            if ([sub_key isEqual:sub_requestString]) {
                [[self.connection_Dic objectForKey:key] cancel];
            }
        }
    }
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    self.connection_SEL = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection_Dic setObject:self.connection_SEL forKey:requestString];
    [self.connection_SEL start];


}
-(void)cancelConnnection:(NSString *)connection_URL
{
    [[self.connection_Dic objectForKey:connection_URL] cancel];
}

-(void)cancelAllConnection
{
    if (self.connection_Dic) {
        for (NSURLConnection *con in [self.connection_Dic allValues]) {
            [con cancel];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"connection error! ");
    if (_fail) {
        if (self.delegate) {
            NSLog(@"%@",([self respondsToSelector:self.success]?@"YES":@"NO"));
            NSLog(@"%@",([self.delegate respondsToSelector:self.fail]?@"YES":@"NO"));
             [self.delegate performSelector:self.fail withObject:error];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.resultData appendData:data];
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

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"connection success!");
//    NSLog(@"%@",self.resultData?@"resultData":@"nil");
    if (_success) {
        if (self.delegate) {
            NSLog(@"%@",([self respondsToSelector:self.success]?@"YES":@"NO"));
            NSLog(@"%@",([self.delegate respondsToSelector:self.success]?@"YES":@"NO"));
            [self.delegate performSelector:self.success withObject:self.resultData];
        }
    }
//    [connection cancel];
    NSLog(@"current connection description = %@",[connection description]);
}
@end
