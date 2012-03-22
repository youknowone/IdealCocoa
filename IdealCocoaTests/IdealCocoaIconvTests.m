//
//  IdealCocoaIconvTests.m
//  IdealCocoa
//
//  Created by youknowone on 11. 3. 22..
//  Copyright 2011 3rddev.org. All rights reserved.
//

#import <IdealCocoa/IdealAdditions.h>
#import <IdealCocoa/IdealCocoa.h>
#import "IdealCocoaTests.h"

@implementation IdealCocoaTests (ICIconv)

- (void) testAsciiToUTF8 {
	NSString *solution = @"Hello, World!";
	NSString *result = [ICIconv convertedStringWithBytes:[solution UTF8String] length:[solution length] fromCode:@"EUC-KR"];
	STAssertNil([result isEqualToString:solution], @"result: |%@| expected: |%@|", result, solution);
}

@end
