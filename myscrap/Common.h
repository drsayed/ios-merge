//
//  Common.h
//  myscrap
//
//  Created by Hassan Jaffri on 9/16/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataEncoding.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface Common : NSObject
+(NSString *)encodeToBase64String:(UIImage *)image;
@end

NS_ASSUME_NONNULL_END
