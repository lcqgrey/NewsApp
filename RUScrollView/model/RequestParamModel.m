//
//  RequestParamModel.m
//  RUScrollView
//
//  Created by LCQ on 14-6-23.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import "RequestParamModel.h"

@implementation RequestParamModel


+ (NSDictionary *)newsListParamDictionaryWithStartRecord:(NSNumber *)startRecord len:(NSString *)len cid:(NSNumber *)cid
{
    NSDictionary *dic = @{@"startRecord": startRecord,@"len": len, @"udid": @"1234567890", @"terminalType": @"Iphone", @"cid": cid};
    
    return dic;
}

@end
