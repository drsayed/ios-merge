//
//  Common.m
//  myscrap
//
//  Created by Hassan Jaffri on 9/16/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "Common.h"
#import "Base64.h"
@implementation Common

+(NSString *)encodeToBase64String:(UIImage *)image{
   
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    NSString *strEncoded = [Base64 encode:data];
     NSString *strPlusRepacedEncoded = strEncoded;
  //  strPlusRepacedEncoded = [strPlusRepacedEncoded stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
 return strEncoded;
}

@end
