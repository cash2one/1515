//
//  DownLoad.m
//  CarDemo
//
//  Created by Visitor on 14-11-5.
//  Copyright (c) 2014年 Visitor. All rights reserved.
//

#import "DownLoad.h"

@implementation DownLoad

-(void)downLoad
{
    NSString *downLoadStr;
    if (_downLoadPage>=0) {
        downLoadStr = [NSString stringWithFormat:_downLoadString,_downLoadPage];
    }
    else{
        downLoadStr = _downLoadString;
    }
    NSURL *url = [NSURL URLWithString:downLoadStr];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    [connection start];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _downLoadData = [[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_downLoadData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"下载完成");
    [self.delegate downLoadFinishWithClass:self];
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"下载失败");
}

@end
