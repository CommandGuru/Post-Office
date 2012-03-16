//
//  UIApplication+Version.h
//  Sharecard
//
//  Created by Andrea Gelati on 8/8/09.
//  Copyright 2009 Doseido. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (Version)
+ (NSString *)applicationVersion;
+ (NSString *)applicationBuild;
+ (NSString *)applicationName;
@end
