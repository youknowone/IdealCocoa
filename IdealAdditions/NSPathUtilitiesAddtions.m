//
//  NSPathUtilitiesAddtions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 11. 2..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//	This program is free software: you can redistribute it and/or modify
//	it under the terms of the GNU Lesser General Public License as published by
//	the Free Software Foundation, either version 3 of the License, or
//	(at your option) any later version.
//	
//	This program is distributed in the hope that it will be useful,
//	but WITHOUT ANY WARRANTY; without even the implied warranty of
//	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//	GNU Lesser General Public License for more details.
//	
//	You should have received a copy of the GNU Lesser General Public License
//	along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "NSPathUtilitiesAddtions.h"

NSString *NSPathForUserDirectory(NSSearchPathDirectory directory) {
	return [NSSearchPathForDirectoriesInDomains(directory,  NSUserDomainMask, YES) objectAtIndex:0];
}

NSString *NSPathForUserFileInDirectory(NSSearchPathDirectory directory, NSString *filename) {
	return [NSPathForUserDirectory(directory) stringByAppendingPathComponent:filename];
}

NSString *NSPathForHomeFile(NSString *filename) {
	return [NSHomeDirectory() stringByAppendingPathComponent:filename];
}

NSString *NSPathForHomeFileForUser(NSString *filename, NSString *userName) {
	return [NSHomeDirectoryForUser(userName) stringByAppendingPathComponent:filename];
}

NSString *NSUserConfigurationDirectory(void) {
#ifdef TARGET_OS_IPHONE
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
#else
	return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];	
#endif
}

NSString *NSPathForUserConfigurationFile(NSString *filename) {
	return [NSUserConfigurationDirectory() stringByAppendingPathComponent:filename];
}
