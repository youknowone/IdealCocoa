//
//  NSTimerAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 5..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU General Public License for more details.
//	
//	You should have received a copy of the GNU General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <IdealCocoa/ICUtility.h>

@interface NSTimer (IdealCocoa)

+ (NSTimer *)zeroDelayedTimerWithTarget:(id)aTarget selector:(SEL)aSelector;
+ (NSTimer *)zeroDelayedTimerWithTarget:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo;
+ (NSTimer *)delayedTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector;

+ (NSTimer *)triggerByTimer:(SEL)proc forTarget:(id)target after:(NSTimeInterval)seconds __ICDEPRECATED;
+ (NSTimer *)triggerByTimer:(SEL)proc forTarget:(id)target __ICDEPRECATED;

@end
