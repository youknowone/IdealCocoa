//
//  NSAClass.m
//  IdealCocoa
//
//  Created by youknowone on 12. 10. 16..
//  Copyright (c) 2012 youknowone.org. All rights reserved.
//

#import "NSAClass.h"

@implementation NSAClass

- (id)initWithClass:(Class)class {
    self = [super init];
    if (self != nil) {
        self->_class = class;
    }
    return self;
}

+ (id)classWithClass:(Class)class {
    return [[[self alloc] initWithClass:class] autorelease];
}

@end
