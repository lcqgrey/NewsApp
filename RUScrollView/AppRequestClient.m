//
//  AppRequestClient.m
//  RUScrollView
//
//  Created by LCQ on 14-6-23.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "AppRequestClient.h"
//#import "DesCoder.h"
//#import "UIDevice+Category.h"
#import <AFNetworking.h>
#import <JSONModel.h>
#import <JSONModelArray.h>

@implementation AppRequestClient
{
    Reachability *reach;
}

+ (id)shareApiClientInstance {
    static AppRequestClient *instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [AppRequestClient clientWithBaseURL:[NSURL URLWithString:ApiBaseURL]];
    });
    return instance;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (self) {

        //set the default header
        //        [self setDefaultHeader:@"APIToken" value:kApiToken];
//        [self setDefaultHeader:@"Accept" value:@"application/json"];
//        [AFJSONRequestOperation addAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil]];
//        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        //        [self setParameterEncoding:AFFormURLParameterEncoding];//upload the request use the json encoding
    }
    return self;
}

-(void)startNotifierNetWork
{
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [reach startNotifier];
    [self updateInterfaceWithReachability: reach];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

    // 连接改变
- (void) reachabilityChanged: (NSNotification* )note
{
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    [self updateInterfaceWithReachability: curReach];
}


    //处理连接改变后的情况
- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    //对连接改变做出响应的处理动作。
    
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    if (status == NotReachable) {  //网络改变就改变状态
        self.hasNet = NO;
    }
    else {
        self.hasNet = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetChangeNotification object:nil]; //该通知用于需要根据网络随时改变策略的地方
    }
    
}


- (void)sendRequestWithPath:(NSString *)path withRequestMethod:(HttpRequestMethod)method withParams:(NSDictionary *)params withJSONModelStr:(NSString *)jsonModel_str withResponseBlock:(HttpResponseBlock)responseBlock {
    
    __weak typeof(self) weakSelf = self;
    switch (method) {
        case HttpRequestMethodGET:
        {
            [self getPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf parseJSONModelWithResponse:responseObject withClassStr:jsonModel_str withResponseBlock:responseBlock];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf requestFailureWithOperation:operation withResponseBlock:responseBlock];
            }];
        }
            break;
            
        case HttpRequestMethodPOST:
        {
            [self postPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf parseJSONModelWithResponse:responseObject withClassStr:jsonModel_str withResponseBlock:responseBlock];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf requestFailureWithOperation:operation withResponseBlock:responseBlock];
            }];
        }
            break;
            
        case HttpRequestMethodPUT:
        {
            [self putPath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf parseJSONModelWithResponse:responseObject withClassStr:jsonModel_str withResponseBlock:responseBlock];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf requestFailureWithOperation:operation withResponseBlock:responseBlock];
            }];
        }
            break;
            
        case HttpRequestMethodDELETE:
        {
            [self deletePath:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                [weakSelf parseJSONModelWithResponse:responseObject withClassStr:jsonModel_str withResponseBlock:responseBlock];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [weakSelf requestFailureWithOperation:operation withResponseBlock:responseBlock];
            }];
        }
            break;
            
        default:
            break;
    }
}


- (void)parseJSONModelWithResponse:(id)responseObject withClassStr:(NSString *)jsonModelStr withResponseBlock:(HttpResponseBlock)responseBlock {
//    if (jsonModelStr && jsonModelStr.length > 0) {
//        if ([responseObject isKindOfClass:[NSArray class]]) {
//            JSONModelArray *model = [[JSONModelArray alloc] initWithArray:responseObject modelClass:NSClassFromString(jsonModelStr)];
//            responseBlock(ResponseSuccessAndDataExist, model);
//        }else if ([responseObject isKindOfClass:[NSDictionary class]]) {
//            NSError *error = nil;
//            JSONModel *model = [[NSClassFromString(jsonModelStr) alloc] initWithDictionary:responseObject error:&error];
//            if (error) {
//                responseBlock(ResponseSuccessAndDataFormatError, error);
//            }else {
//                responseBlock(ResponseSuccessAndDataExist, model);
//            }
//        }else {
//            responseBlock(ResponseSuccessAndServerError, responseObject);
//        }
//    }
    id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    if ([jsonData isKindOfClass:[NSArray class]]) {
        JSONModelArray *model = [[JSONModelArray alloc] initWithArray:jsonData modelClass:NSClassFromString(jsonModelStr)];
        responseBlock(ResponseSuccessAndDataExist, model);
    }else if ([jsonData isKindOfClass:[NSDictionary class]]) {
        NSError *error = nil;
        JSONModel *model = [[NSClassFromString(jsonModelStr) alloc] initWithDictionary:jsonData error:&error];
        if (error) {
            responseBlock(ResponseSuccessAndDataFormatError, error);
        }else {
            responseBlock(ResponseSuccessAndDataExist, model);
        }
    }else {
        responseBlock(ResponseSuccessAndServerError, jsonData);
    }
}

- (void)requestFailureWithOperation:(AFHTTPRequestOperation *)operation withResponseBlock:(HttpResponseBlock)responseBlock {
    NSString *responseString = operation.responseString;
    responseBlock(ResponseFailure, responseString);
}


@end
