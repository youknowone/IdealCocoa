//
//  UIWebViewAdditions.m
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 18..
//  Copyright 2010 3rddev.org. All rights reserved.
//

#import "UIWebViewAdditions.h"

@implementation UIWebView (IdealCocoa)

- (void)loadRequestForURL:(NSURL *)URL {
	[self loadRequest:[NSURLRequest requestWithURL:URL]];
}
	 
- (void)loadRequestForFilePath:(NSString *)filePath {
	[self loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:filePath]]];
}		 

@end
