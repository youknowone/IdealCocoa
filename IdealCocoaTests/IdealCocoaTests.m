//
//  IdealCocoaTests.m
//  IdealCocoaTests
//
//  Created by youknowone on 11. 3. 21..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <IdealCocoa/IdealAdditions.h>
#import <IdealCocoa/IdealCocoa.h>

#import "IdealCocoaTests.h"

@implementation IdealCocoaTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testHexadecimal
{
    NSData *data = [@"SAMPLE" dataUsingEncoding:NSUTF8StringEncoding];
    STAssertTrue([[data hexadecimalString] isEqual:@"53414d504c45"], @"hexadecimal encode");
    
    STAssertTrue([@"SAMPLE" isEqual:[NSString stringWithUTF8Data:[NSData dataWithHexadecimalString:@"53414d504c45"]]], @"hexadecimal decode");
}

@end
