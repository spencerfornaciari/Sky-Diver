//
//  Constants.h
//  Sky Diver
//
//  Created by Spencer Fornaciari on 2/21/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

typedef enum : uint32_t {
    NAME_UNO  = 0x1 << 0,
    NAME_DOS = 0x1 << 1,
} kNAMECATEGORY;

@end
