//
//  DataEncoding.h
//  myscrap
//
//  Created by Hassan Jaffri on 9/16/20.
//  Copyright © 2020 MyScrap. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSData (EasyUTF8)

// Safely decode the bytes into a UTF8 string
- (NSString *)asUTF8String;

@end

NS_ASSUME_NONNULL_END
