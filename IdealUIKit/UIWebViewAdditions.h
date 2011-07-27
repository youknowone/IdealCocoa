//
//  UIWebViewAdditions.h
//  IdealCocoa
//
//  Created by youknowone on 10. 10. 18..
//  Copyright 2010 3rddev.org. All rights reserved.
//

@interface UIWebView (IdealCocoa)

- (void)loadRequestForURL:(NSURL *)URL;
- (void)loadRequestForURLString:(NSString *)URLString;
- (void)loadRequestForFilePath:(NSString *)filePath;

@end
