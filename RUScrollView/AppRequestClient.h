//
//  AppRequestClient.h
//  RUScrollView
//
//  Created by LCQ on 14-6-23.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "AFHTTPClient.h"

@interface AppRequestClient : AFHTTPClient

typedef NS_ENUM(NSUInteger, HttpRequestMethod) {
    HttpRequestMethodGET = 0,
    HttpRequestMethodPOST = 1,
    HttpRequestMethodPUT = 2,
    HttpRequestMethodDELETE = 3,
};

typedef NS_ENUM (NSUInteger, ResponseType) {
    ResponseSuccessAndDataExist,
    ResponseSuccessAndDataFormatError,
    ResponseSuccessAndServerError,
    ResponseFailure
};

//@{@"errorMsg": [error description], @"popMsg":@"数据解析错误", @"type":@"1"}
//如果success=NO,那么responseData返回的时上述的dict信息，type:0网络异常,1:解析错误,2:服务器返回的不是正确的JSON格式数据
typedef void(^HttpResponseBlock)(ResponseType responseType, id responseData);


typedef void (^HttpSuccessBlock)(AFHTTPRequestOperation * operation, id responseData);
typedef void (^HttpFailureBlock)(AFHTTPRequestOperation * operation,NSError * error);

typedef void (^HttpJsonModelBlock)(id model,NSError *error);

@property (nonatomic) BOOL hasNet;

- (void)startNotifierNetWork;//开始监听网络

+ (id)shareApiClientInstance;

- (void)sendRequestWithPath:(NSString *)path withRequestMethod:(HttpRequestMethod)method withParams:(NSDictionary *)params withJSONModelStr:(NSString *)jsonModel_str withResponseBlock:(HttpResponseBlock)responseBlock;

@end
