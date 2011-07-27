//
//  UIColorAdditions.m
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

#import "NSStringAdditions.h"
#import "UIColorAdditions.h"

@implementation UIColor (IdealCocoa)

+ (UIColor *)colorByHtmlColor:(NSString *)color {
	if ( [color characterAtIndex:0] != '#' ) {
		if ( [color isEqualToString:@"clear"] ) return [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
	} else if ( [color length] == 4 ) {
		return [UIColor colorWithRed:[[[color substringFromIndex:1] substringToIndex:1] hexadecimalValue]/15.0f
							   green:[[[color substringFromIndex:2] substringToIndex:1] hexadecimalValue]/15.0f
								blue:[[[color substringFromIndex:3] substringToIndex:1] hexadecimalValue]/15.0f
							   alpha:1.0f];
	} else if ( [color length] == 5 ) {
		return [UIColor colorWithRed:[[[color substringFromIndex:1] substringToIndex:1] hexadecimalValue]/15.0f
							   green:[[[color substringFromIndex:2] substringToIndex:1] hexadecimalValue]/15.0f
								blue:[[[color substringFromIndex:3] substringToIndex:1] hexadecimalValue]/15.0f
							   alpha:[[[color substringFromIndex:4] substringToIndex:1] hexadecimalValue]/15.0f];		
	} else if ( [color length] == 7 ) {
		return [UIColor colorWithRed:[[[color substringFromIndex:1] substringToIndex:2] hexadecimalValue]/255.0f
							   green:[[[color substringFromIndex:3] substringToIndex:2] hexadecimalValue]/255.0f
								blue:[[[color substringFromIndex:5] substringToIndex:2] hexadecimalValue]/255.0f
							   alpha:1.0f];		
	} else if ( [color length] == 9 ) {
		return [UIColor colorWithRed:[[[color substringFromIndex:1] substringToIndex:2] hexadecimalValue]/255.0f
							   green:[[[color substringFromIndex:3] substringToIndex:2] hexadecimalValue]/255.0f
								blue:[[[color substringFromIndex:5] substringToIndex:2] hexadecimalValue]/255.0f
							   alpha:[[[color substringFromIndex:7] substringToIndex:2] hexadecimalValue]/255.0f];		
	}
	return nil;
}

@end
