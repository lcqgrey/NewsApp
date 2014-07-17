//
//  RequestParamModel.h
//  RUScrollView
//
//  Created by LCQ on 14-6-23.
//  Copyright (c) 2014年 lcqgrey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RequestParamModel : NSObject

+ (NSDictionary *)newsListParamDictionaryWithStartRecord:(NSNumber *)startRecord len:(NSString *)len cid:(NSNumber *)cid;


@end
