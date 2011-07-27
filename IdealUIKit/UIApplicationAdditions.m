//
//  UIApplicationAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 3. 27..
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

#import "UIApplicationAdditions.h"

@implementation UIApplication (IdealCocoa)

- (CGSize) statusBarOrientationReducedSize {
    return [self statusBarSizeForOrientation:self.statusBarOrientation];
}

- (CGSize) statusBarSizeForOrientation:(UIInterfaceOrientation)orientation {
    if ( UIInterfaceOrientationIsPortrait(orientation) ) return self.statusBarFrame.size;
	return CGSizeMake(self.statusBarFrame.size.height, self.statusBarFrame.size.width);
}

@end
