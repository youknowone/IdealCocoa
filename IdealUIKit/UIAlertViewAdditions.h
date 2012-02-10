//
//  UIAlertViewAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 6..
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

#if IC_DEBUG
#define UILog(TAG, ...) { if ( TAG ) { __ICLog(__VA_ARGS__, __FILE__, __LINE__); [UIAlertView showLog:[NSString stringWithFormat:__VA_ARGS__] file:__FILE__ line:__LINE__]; } }
#else
#define UILog(TAG, ...)
#endif

@interface UIAlertView (IdealCocoa)

+ (UIAlertView *)showLog:(NSString *)log file:(char *)filename line:(int)line;

- (id)initNoticeWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
+ (UIAlertView *)showNoticeWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
