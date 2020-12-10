//
//  DataEncoding.m
//  myscrap
//
//  Created by Hassan Jaffri on 9/16/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

#import "DataEncoding.h"

@implementation NSData (EasyUTF8)

- (NSString *)asUTF8String {
    return [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
}

@end
