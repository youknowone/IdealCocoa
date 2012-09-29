//
//  ICXML.h
//  IdealCocoa
//
//  Created by youknowone on 10. 1. 31..
//  Copyright 2010 3rddev.org. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//  
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//  
//  You should have received a copy of the GNU Lesser General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

@interface ICXMLAttributeDictionary: NSDictionary {
    NSDictionary *impl;
}

@end

@interface ICXMLElementArray : NSMutableArray  {
    NSMutableArray *impl;
    
    NSMutableArray *_childrenNames;
    NSMutableDictionary *_childrenDictionary;
}

- (NSArray *)childrenNames;
- (NSArray *)childrenByName:(NSString *)name;
- (NSArray *)childrenByNames:(NSString *)name, ...;
- (id)firstChildByName:(NSString *)name;
//- (id)firstChildByNames:(NSString *)name, ...;

- (NSArray *)textChildren;
- (id)firstTextChild;

@end


@class ICXMLNode;

@protocol ICXMLElement<NSObject, NSCopying>

@property(readonly) NSString *space, *name;
@property(readonly) ICXMLElementArray *children;
@property(readonly) ICXMLElementArray *elements __deprecated;
@property(readonly) ICXMLAttributeDictionary *attributes;
- (void)setAttributes:(ICXMLAttributeDictionary *)attributes __deprecated;
@property(assign) NSObject<ICXMLElement> *parent;
@property(readonly) NSObject<ICXMLElement> *root;
@property(readonly) NSString *text;
@property(readonly) NSString *strippedText;
@property(readonly) NSString *innerText;
@property(readonly) NSString *strippedInnerText;

- (NSString *)descriptionWithIndent:(NSString *)indent;

@end


//// abstract
//@interface ICXMLElement: NSObject<ICXMLElement>
//
//@end


@interface ICXMLNode: NSObject<ICXMLElement> {
    NSObject<ICXMLElement> *_parent;
    NSString *_name;
    ICXMLElementArray *_children;
    ICXMLAttributeDictionary * _attributes;
    
    NSObject<ICXMLElement> *_root;
}

- (id)initWithName:(NSString *)name attributes:(NSDictionary *)attributes children:(NSArray *)elements;
+ (id)nodeWithName:(NSString*)name attributes:(NSDictionary *)attributes children:(NSArray *)elements;

@end

@interface ICXMLNode (creation)

+ (id)nodeWithData:(NSData *)data;
+ (id)nodeWithContentOfURL:(NSURL *)url;
+ (id)nodeWithString:(NSString *)dataString;

@end


@interface ICXMLText: NSObject<ICXMLElement> {
@protected
    NSObject<ICXMLElement> *_parent;
    NSString *_value;
    NSString *_strippedValue;
}

- (id)initWithString:(NSString *)string parent:(NSObject<ICXMLElement> *)parent;
+ (id)textWithString:(NSString *)string parent:(NSObject<ICXMLElement> *)parent;

@end


@interface ICXMLTextBuilder: ICXMLText {
    NSMutableArray *_resources;
}

@property(nonatomic, readonly) NSMutableArray *resources;

@end


@protocol ICXMLSimpleParserErrorDelegate;
@interface ICXMLSimpleParser : NSXMLParser
#if __MAC_OS_X_VERSION_MAX_ALLOWED > __MAC_10_5 || __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_3_2
<NSXMLParserDelegate>
#endif
{
    id errorDelegate;
  @protected
    NSObject<ICXMLElement> *rootElement;
    NSObject<ICXMLElement> *currentElement;
}

- (id)initWithContentsOfAbstractPath:(NSString *)path;

+ (void)setSharedErrorDelegate:(id<ICXMLSimpleParserErrorDelegate>)delegate;
+ (id<ICXMLSimpleParserErrorDelegate>)sharedErrorDelegate;

@property(readonly) ICXMLNode *document;
@property(retain) id<ICXMLSimpleParserErrorDelegate> errorDelegate;

@end

@protocol ICXMLSimpleParserErrorDelegate
-(void)simpleParser:(ICXMLSimpleParser *)parser parseErrorOccurred:(NSError *)parseError;
@end

