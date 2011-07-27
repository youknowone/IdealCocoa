//
//  NSBundleAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 11. 1..
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

IPHARY_EXTERN NSString *NSResourceDirectory(void);
IPHARY_EXTERN NSString *NSPathForResourceFile(NSString *filename);

@interface NSBundle (IdealCocoa)

- (NSString *) pathForResourceFile:(NSString *)filename;
- (NSString *) pathForResource:(NSString *)filename; // legacy

@end
