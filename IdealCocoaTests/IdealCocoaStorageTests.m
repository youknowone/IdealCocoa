//
//  IdealCocoaStorageTests.m
//  IdealCocoa
//
//  Created by youknowone on 12. 2. 13..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import <IdealCocoa/IdealAdditions.h>
#import <IdealCocoa/IdealCocoa.h>
#import "IdealCocoaStorageTests.h"

@implementation IdealCocoaStorageTests

// All code under test must be linked into the Unit Test bundle
- (void)testSetAndGet
{
    NSString *tstr = @"Hello, World!";
//    NSString *meta = @"Test Hello";
    NSData *data = [tstr dataUsingEncoding:NSUTF8StringEncoding];
    {
        ICMemoryStorage *s = [[ICMemoryStorage alloc] init];
        [s setData:data forKey:@"key"];
        
        STAssertTrue([tstr isEqual:[NSString stringWithUTF8Data:[s dataForKey:@"key"]]], @"get mismatch");
        
        [s release];
    }
    {
        ICUserDefaultsStorage *s = [[ICUserDefaultsStorage alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults] baseKey:@"storage"];
        
        [s setData:data forKey:@"key"];
        [s synchronize];
        
        STAssertTrue([tstr isEqual:[NSString stringWithUTF8Data:[s dataForKey:@"key"]]], @"get mismatch");
        
        [s release];
        
        s = [[ICUserDefaultsStorage alloc] initWithUserDefaults:[NSUserDefaults standardUserDefaults] baseKey:@"storage"];
        STAssertNotNil([s dataForKey:@"key"], @"not saved...");
        NSLog(@"key: %@", [NSString stringWithUTF8Data:[s dataForKey:@"key"]]);
        STAssertTrue([tstr isEqual:[NSString stringWithUTF8Data:[s dataForKey:@"key"]]], @"sync mismatch");
        
        [s removeAllData];
        [s release];
    }
    {
        ICDiskStorage *s = [[ICDiskStorage alloc] initWithBaseDirectory:@"storage"];
        
        [s setData:data forKey:@"key"];
        [s synchronize];
        
        STAssertTrue([tstr isEqual:[NSString stringWithUTF8Data:[s dataForKey:@"key"]]], @"get mismatch");
        
        [s release];
        
        s = [[ICDiskStorage alloc] initWithBaseDirectory:@"storage"];
        STAssertTrue([tstr isEqual:[NSString stringWithUTF8Data:[s dataForKey:@"key"]]], @"sync mismatch");
        [s removeAllData];
        [s release];
    }
}

@end
