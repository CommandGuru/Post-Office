//
//  UIApplication+Version.m
//  Sharecard
//
//  Created by Andrea Gelati on 8/8/09.
//  Copyright 2009 Doseido. All rights reserved.
//

#import "UIApplication+Version.h"


@implementation UIApplication (Version)

+ (NSString *)applicationVersion {
	NSDictionary *plistDict;
	plistDict = [[NSBundle mainBundle] infoDictionary];
		
	return [plistDict objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)applicationBuild {
	NSDictionary *plistDict;
	plistDict = [[NSBundle mainBundle] infoDictionary];
	
	NSString *bundleVersion;
	bundleVersion = [plistDict objectForKey:@"CFBundleVersion"];
	
	bundleVersion = [bundleVersion stringByReplacingOccurrencesOfString:@"M"
															 withString:@""];
	
	bundleVersion = [bundleVersion stringByReplacingOccurrencesOfString:@"S"
															 withString:@""];
	
	return bundleVersion;
}

+ (NSString *)applicationName {
	NSDictionary *plistDict;
	plistDict = [[NSBundle mainBundle] infoDictionary];
	
	return [plistDict objectForKey:@"CFBundleDisplayName"];
}

@end
