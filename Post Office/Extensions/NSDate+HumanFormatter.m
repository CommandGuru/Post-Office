//
//  NSDate+HumanFormatter.m
//  SallyPark
//
//  Created by Andrea Gelati on 3/6/09.
//  Copyright 2009 Doseido. All rights reserved.
//

#import "NSDate+HumanFormatter.h"


@implementation NSDate (HumanFormatter)

- (NSString *)humanDay {
	// Initialize the formatter.
    NSDateFormatter *dateFormatter;
	dateFormatter = [[[NSDateFormatter alloc] init] autorelease];

    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	
    // Initialize the calendar and flags.
    unsigned unitFlags;
	unitFlags = NSYearCalendarUnit | 
				NSMonthCalendarUnit | 
				NSDayCalendarUnit | 
				NSWeekdayCalendarUnit;
	
    NSCalendar *calendar;
	calendar = [NSCalendar currentCalendar];
	
    // Create reference date for supplied date.
    NSDateComponents *dateComponents;
	dateComponents = [calendar components:unitFlags 
								 fromDate:self];

    [dateComponents setHour:0];
    [dateComponents setMinute:0];
    [dateComponents setSecond:0];

    NSDate *suppliedDate;
	suppliedDate = [calendar dateFromComponents:dateComponents];
	
    // Iterate through the eight days (tomorrow, today, and the last six).
    NSInteger i;
    for (i=-1; i<7; i++) {
        // Initialize reference date.
        dateComponents = [calendar components:unitFlags 
									fromDate:[NSDate date]];

        [dateComponents setHour:0];
        [dateComponents setMinute:0];
        [dateComponents setSecond:0];
        [dateComponents setDay:[dateComponents day] - i];

        NSDate *referenceDate;
		referenceDate = [calendar dateFromComponents:dateComponents];

        // Get week day (starts at 1).
        NSInteger weekday;
		weekday = [[calendar components:unitFlags 
							   fromDate:referenceDate] weekday] - 1;
		
        if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == -1) {
            // Tomorrow
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            return NSLocalizedString(@"D0F41083-8903-4EA3-9E93-5BD9E6312C37", @"");
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 0) {
            // Today
            [dateFormatter setDateStyle:NSDateFormatterNoStyle];
            return NSLocalizedString(@"E987F422-3EEF-4280-8BF6-944B51358E96", @"");
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame && i == 1) {
            // Today
			[dateFormatter setDateStyle:NSDateFormatterNoStyle];
			[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
            return NSLocalizedString(@"59BCE6FB-74BD-4CDC-9118-EE9D8A772973", @"");
        } else if ([suppliedDate compare:referenceDate] == NSOrderedSame) {
            // Day of the week
            return [[dateFormatter weekdaySymbols] objectAtIndex:weekday];
        }
    }
	
    // It's not in those eight days.
	return [dateFormatter stringFromDate:self];
}

- (NSString *)humanHour {
	NSDateFormatter *dateFormatter = nil;
	dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
	
	[dateFormatter setTimeStyle:NSDateFormatterShortStyle];

	return [dateFormatter stringFromDate:self];
}

@end
