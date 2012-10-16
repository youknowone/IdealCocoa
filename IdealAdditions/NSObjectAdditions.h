//
//  NSObjectAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 12. 10. 16..
//  Copyright (c) 2012 youknowone.org All rights reserved.
//

#import <IdealAdditions/NSAClass.h>

@interface NSObject (IdealCocoa)

- (NSAClass *)classObject;

- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3;
- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2 withObject:(id)object3 withObject:(id)object4;

@end
