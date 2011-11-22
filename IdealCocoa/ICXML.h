//
//  ICXML.h
//  IdealCocoa
//
//  Created by youknowone on 10. 1. 31..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//  
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

@interface ICXMLElement : NSObject<NSCopying>
{
    NSString *space; // not used yet
    NSString *name;
    NSMutableArray *elements;
    NSDictionary *attributes;
    ICXMLElement *parent;    
}

@property(copy) NSString *space, *name;
@property(retain) NSMutableArray *elements;
@property(retain) NSDictionary *attributes;
@property(assign) ICXMLElement *parent;
@property(readonly) NSString *text;

- (id)initWithName:(NSString*)name fromParent:(ICXMLElement *)parent withAttributes:(NSDictionary *)attributes;

- (id)initWithTextElement:(NSString *)xmlText fromParent:(ICXMLElement *)parent;
+ (ICXMLElement *)elementWithTextElement:(NSString*)xmlText fromParent:(ICXMLElement *)parent;

- (void)addElement:(ICXMLElement *)element;
- (BOOL)isRootElement __deprecated;

@end

@interface ICXMLElement (creation)

+ (ICXMLElement *)elementWithData:(NSData *)data;
+ (ICXMLElement *)elementWithContentOfURL:(NSURL *)url;
+ (ICXMLElement *)elementWithDataString:(NSString *)dataString;

+ (ICXMLElement *)elementWithData:(NSData *)data fromParent:(ICXMLElement *)parent;
+ (ICXMLElement *)elementWithContentOfURL:(NSURL *)url fromParent:(ICXMLElement *)parent;
+ (ICXMLElement *)elementWithDataString:(NSString *)dataString fromParent:(ICXMLElement *)parent;

@end

@protocol ICXMLSimpleParserErrorDelegate;
@interface ICXMLSimpleParser : NSXMLParser
#if __MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_5 || __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_3_2
<NSXMLParserDelegate>
#endif
{
    id errorDelegate;
  @protected
    ICXMLElement* rootElement;
    ICXMLElement* currentElement;
}

- (id)initWithContentsOfAbstractPath:(NSString *)path;

+ (void)setSharedErrorDelegate:(id<ICXMLSimpleParserErrorDelegate>)delegate;
+ (id<ICXMLSimpleParserErrorDelegate>)sharedErrorDelegate;

@property(readonly) ICXMLElement *document;
@property(retain) id<ICXMLSimpleParserErrorDelegate> errorDelegate;

@end

@protocol ICXMLSimpleParserErrorDelegate
-(void)simpleParser:(ICXMLSimpleParser *)parser parseErrorOccurred:(NSError *)parseError;
@end

