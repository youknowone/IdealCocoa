//
//  ICXML.m
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

#define ICXML_DEBUG FALSE

#import "NSDataAdditions.h"
#import "NSURLAdditions.h"
#import "NSArrayAdditions.h"
#import "ICXML.h"


//@implementation ICXMLElement
//@dynamic space, name, elements, attributes, parent, root, text, strippedText;
//
//+ (id)alloc {
//    assert(NO);
//}
//
//- (id)init {
//    assert(NO);
//}
//
//- (id)copyWithZone:(NSZone *)zone {
//    assert(NO);
//}
//
//- (NSString *)descriptionWithIndent:(NSString *)indent {
//    return nil;
//}
//
//@end


@implementation ICXMLAttributeDictionary

- (id)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)cnt {
    self = [self init];
    if (self != nil) {
        self->impl = [[NSDictionary alloc] initWithObjects:objects forKeys:keys count:cnt];
    }
    return self;
}

- (NSEnumerator *)keyEnumerator {
    ICAssert(self->impl);
    return [self->impl keyEnumerator];
}

- (id)objectForKey:(id)aKey {
    ICAssert(self->impl);
    return [self->impl objectForKey:aKey];
}

- (NSUInteger)count {
    ICAssert(self->impl);
    return [self->impl count];
}

- (NSString *)description {
    return [self->impl description];
}


@end


@implementation ICXMLElementArray

- (void)initAsXMLElementArray {
    self->_childrenDictionary = [[NSMutableDictionary alloc] init];
}

- (id)init {
    self = [super init];
    if (self != nil) {
        self->impl = [[NSMutableArray alloc] init];
        [self initAsXMLElementArray];
    }
    return self;
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt {
    self = [super init];
    if (self != nil) {
        self->impl = [[NSMutableArray alloc] initWithObjects:objects count:cnt];
        [self initAsXMLElementArray];
    }
    return self;
}

- (id)initWithCapacity:(NSUInteger)numItems {
    self = [super init];
    if (self != nil) {
        self->impl = [[NSMutableArray alloc] initWithCapacity:numItems];
        [self initAsXMLElementArray];
    }
    return self;
}

- (void)dealloc {
    [self->_childrenDictionary release];
    [self->_childrenNames release];
    [self->impl release];
    [super dealloc];
}


- (NSUInteger)count {
    ICAssert(self->impl);
    return [self->impl count];
}

- (void)addObject:(id)anObject {
    ICAssert(self->impl);
    [self->impl addObject:anObject];
}

- (id)objectAtIndex:(NSUInteger)index {
    ICAssert(self->impl);
    return [self->impl objectAtIndex:index];
}

- (void)removeObjectAtIndex:(NSUInteger)index {
    ICAssert(self->impl);
    return [self->impl removeObjectAtIndex:index];
}

- (NSString *)description {
    return [self->impl description];
}

- (NSArray *)childrenNames {
    if (self->_childrenNames == nil) {
        self->_childrenNames = [[NSMutableArray alloc] init];

        for (NSObject<ICXMLElement> *elem in self) {
            id key = elem.name;
            if (key == nil) {
                key = [NSNull null];
            }
            if ([self->_childrenNames indexOfObject:elem.name] == NSNotFound) {
                [self->_childrenNames addObject:elem.name];
            }
        }
    }
    return self->_childrenNames;
}

- (NSArray *)childrenByName:(NSString *)name {
    return [self childrenByNames:name, nil];
}

- (NSArray *)childrenByNames:(NSString *)name, ... {
    va_list args;
	va_start(args, name);

    NSMutableArray *names = [NSMutableArray array];
	for (NSString *arg = name; arg != nil; arg = va_arg(args, NSString*))
	{
		[names addObject:arg];
	}
	va_end(args);

    NSString *uniqueKey = [names componentsJoinedByString:@"&"];

    NSArray *result = [self->_childrenDictionary objectForKey:uniqueKey];
    if (result == nil) {
        NSMutableArray *tempResult = [NSMutableArray array];
        for (NSObject<ICXMLElement> *elem in self) {
            id key = elem.name;
            if (key == nil) {
                key = [NSNull null];
            }
            if ([names indexOfObject:elem.name] != NSNotFound) {
                [tempResult addObject:elem];
            }
        }
        result = [NSArray arrayWithArray:tempResult];
        [self->_childrenDictionary setObject:result forKey:uniqueKey];
    }
    return result;
}

- (id)firstChildByName:(NSString *)name {
    return [[self childrenByNames:name, nil] objectAtIndex:0];
}

//- (id)firstChildByNames:(NSString *)name, ... {
//    return [[self childrenByNames:name, ...] objectAtIndex:0];
//}

- (NSArray *)textChildren {
    return [self childrenByName:(id)[NSNull null]];
}

- (id)firstTextChild {
    return [self.textChildren objectAtIndex:0];
}


@end


@implementation ICXMLText

- (id)initWithString:(NSString *)string parent:(NSObject<ICXMLElement> *)parent {
    self = [super init];
    if (self != nil) {
        self->_value = [string copy];
        self->_parent = parent;
    }
    return self;
}

+ (id)textWithString:(NSString*)string parent:(NSObject<ICXMLElement> *)parent {
    return [[[self alloc] initWithString:string parent:parent] autorelease];
}

- (void)dealloc {
    [self->_value release];
    [self->_strippedValue release];
    [super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithString:self->_value parent:self->_parent];
}

- (void)setParent:(NSObject<ICXMLElement> *)parent {
    self->_parent = parent;
}

- (NSObject<ICXMLElement> *)parent {
    return self->_parent;
}

- (NSString *)space {
    return nil;
}

- (NSString *)name {
    return nil;
}

- (NSString *)text {
    return self->_value;
}

- (NSString *)strippedText {
    if (self->_strippedValue == nil) {
        self->_strippedValue = [[self->_value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] retain];
    }
    return self->_strippedValue;
}

- (NSString *)innerText {
    return nil;
}

- (NSString *)strippedInnerText {
    return nil;
}

- (NSString *)childText {
    return nil;
}

- (NSString *)description {
    return self->_value;
}

- (ICXMLAttributeDictionary *)attributes {
    return nil;
}

-(void)setAttributes:(ICXMLAttributeDictionary *)attributes {
    ICAssert(NO);
}

- (ICXMLElementArray *)children {
    return nil;
}

- (ICXMLElementArray *)elements {
    return nil;
}

- (NSObject<ICXMLElement> *)root {
    return self.parent.root;
}

- (NSString *)descriptionWithIndent:(NSString *)indent {
    NSString *desc = [NSString stringWithFormat:@"%@%@", indent, self.strippedText];
    return desc;
}

@end


@implementation ICXMLNode

- (id)initWithName:(NSString *)aName attributes:(NSDictionary *)attributeDict children:(NSArray *)elementsArray {
    self = [super init];
    if (self != nil) {
        self->_name = [aName copy];
        self->_attributes = [[ICXMLAttributeDictionary alloc] initWithDictionary:attributeDict];
        if (elementsArray) {
            self->_children = [[ICXMLElementArray alloc] initWithArray:elementsArray];
        } else {
            self->_children = [[ICXMLElementArray alloc] init];
        }
    }
    return self;
}

- (void)dealloc { 
    self->_name = nil;
    self->_children = nil;
    self->_attributes = nil;
    [super dealloc];
}

- (NSObject<ICXMLElement> *)root {
    if (_root == nil) {
        if (self.parent == nil) {
            _root = self;
        } else {
            _root = self.parent.root;
        }
    }
    return _root;
}

+ (id)nodeWithName:(NSString *)name attributes:(NSDictionary *)attributes children:(NSArray *)elements {
    return [[[self alloc] initWithName:name attributes:attributes children:elements] autorelease];
}

- (NSString *)description {
    return [self descriptionWithIndent:@""];
}

- (id) copyWithZone:(NSZone *)zone {
    return [[[self class] alloc] initWithName:self.name attributes:self.attributes children:self.children];
}

- (void)setParent:(NSObject<ICXMLElement> *)parent {
    self->_parent = parent;
}

- (NSObject<ICXMLElement> *)parent {
    return self->_parent;
}

- (NSString *)space {
    return nil;
}

- (NSString *)name {
    return _name;
}

- (ICXMLElementArray *)children {
    return _children;
}

- (ICXMLElementArray *)elements {
    return self.children;
}

- (ICXMLAttributeDictionary *)attributes {
    return _attributes;
}

- (void)setAttributes:(ICXMLAttributeDictionary *)attributes {
    [self->_attributes autorelease];
    self->_attributes = [attributes retain];
}

- (NSString *)text {
    return nil;
}

- (NSString *)strippedText {
    return nil;
}

- (NSString *)innerText {
    NSMutableString *text = [[NSMutableString alloc] init];
    for (NSObject<ICXMLElement> *elem in self.children) {
        [text appendString:elem.description];
    }
    return [text autorelease];
}

- (NSString *)strippedInnerText {
    return [self.innerText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)descriptionWithIndent:(NSString *)indent {
    NSMutableString *attrs = [[NSMutableString alloc] init];
    for (NSString *key in [self.attributes keyEnumerator]) {
        [attrs appendFormat:@" %@=\"%@\"", key, [self->_attributes objectForKey:key]];
    }
    NSMutableString *elems = [[NSMutableString alloc] init];

    NSString *deeperIndent = [indent stringByAppendingString:@"\t"];
    for (NSObject<ICXMLElement> *e in self->_children) {
        [elems appendFormat:@"\n%@", [e descriptionWithIndent:deeperIndent]];
    }

    if ([elems length] > 0) {
        [elems appendFormat:@"\n%@", indent];
    }
    NSString *desc = [NSString stringWithFormat:@"%@<%@%@>%@</%@>", indent, _name, attrs, elems, _name];
    [attrs release];
    [elems release];
    return desc;
}

@end

@implementation ICXMLNode (creation)

+ (id)nodeWithData:(NSData *)data {
    ICXMLSimpleParser *parser = [[[ICXMLSimpleParser alloc] initWithData:data] autorelease];
    return parser.document;
}

+ (id)nodeWithContentOfURL:(NSURL *)url {
    ICXMLSimpleParser *parser = [[[ICXMLSimpleParser alloc] initWithContentsOfURL:url] autorelease];
    return parser.document;
}

+ (id)nodeWithString:(NSString *)dataString {
    return [self nodeWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

@end


@implementation ICXMLTextBuilder
@synthesize resources=_resources;

- (id)init {
    self = [super init];
    if (self != nil) {
        self->_resources = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc {
    [self->_resources release];
    [super dealloc];
}

- (NSString *)text {
    if (self->_value == nil) {
        self->_value = [[self->_resources componentsJoinedByString:@""] retain];
        [self->_resources release];
        self->_resources = nil;
    }
    return self->_value;
}

- (NSString *)strippedText {
    if (self->_strippedValue == nil) {
        [self text]; // build
        return [super strippedText];
    }
    return self->_strippedValue;
}

@end


@implementation ICXMLSimpleParser

@synthesize errorDelegate;

- (ICXMLNode *)document {
    #if IC_DEBUG
    if (rootElement.children.count == 0) {
        ICLog(1, @"ERROR: root document is blank at %p / %@", rootElement, rootElement);
    }
    #endif
    return [rootElement.children objectAtIndex:0];
}

- (id)initWithContentsOfAbstractPath:(NSString *)path {
    ICLog(ICXML_DEBUG, @"XML from URL: %@", path);
    NSData *data = [NSData dataWithContentsOfAbstractPath:path];
    return [self initWithData:data];
}

id ICXMLSharedErrorDelegate;
+ (void)setSharedErrorDelegate:(id)delegate {
    ICXMLSharedErrorDelegate = delegate;
}

+ (id)sharedErrorDelegate {
    return ICXMLSharedErrorDelegate;
}

#pragma mark -
#pragma mark inherited methods

- (id)initWithContentsOfURL:(NSURL *)url {
    ICLog(ICXML_DEBUG, @"XML from URL: %@", url);
    if ((self = [super initWithContentsOfURL:url]) != nil) {
        [self parse];
    }
    return self;
}

- (id)initWithData:(NSData *)data {
    if ((self = [super initWithData:data]) != nil) {
        [self parse];
    }
    return self;
}

- (void)dealloc {
    [rootElement release];
    self.errorDelegate = nil;
    [super dealloc];
}

- (BOOL) parse {
    [self setDelegate:self];
    [self setShouldProcessNamespaces:NO]; // 
    [self setShouldReportNamespacePrefixes:NO];
    [self setShouldResolveExternalEntities:NO];
    return [super parse];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{%p, document=%@\n}", self, self.document];
}

#pragma mark -
#pragma mark parser delegate;

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    ICLog(ICXML_DEBUG, @"error occured: %@", parseError);
    id<ICXMLSimpleParserErrorDelegate> delegate = self.errorDelegate;
    if ( delegate == nil ) delegate = [ICXMLSimpleParser sharedErrorDelegate];
    [delegate simpleParser:self parseErrorOccurred:parseError];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    ICLog(ICXML_DEBUG, @"parsing started");
    [rootElement release];
    rootElement = [[ICXMLNode alloc] initWithName:nil attributes:nil children:nil];
    currentElement = rootElement;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    ICLog(ICXML_DEBUG, @"<%@> start with attributes: %@", elementName, attributeDict);
    ICXMLNode* childElement = [[ICXMLNode alloc] initWithName:elementName attributes:attributeDict children:nil];
    [(NSMutableArray *)currentElement.children addObject:childElement];
    childElement.parent = currentElement;
    [childElement release];
    currentElement = childElement;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    ICLog(ICXML_DEBUG, @"</%@> end", elementName);
    //currentElement.elements = [NSArray arrayWithArray:currentElement.elements];
    
    for (NSInteger i = currentElement.children.count - 1; i >= 0; i--) {
        NSObject<ICXMLElement> *elem = [currentElement.children objectAtIndex:i];
        if (elem.name == nil) {
            if (elem.strippedText.length == 0) {
                [(NSMutableArray *)currentElement.children removeObjectAtIndex:i];
                continue;
            }
        }
    }
    currentElement = currentElement.parent;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    ICLog(ICXML_DEBUG, @"characters found: %@", string);
    NSObject<ICXMLElement> *lastChild = currentElement.children.lastObject;
    if (currentElement.children.count > 0 && [lastChild isKindOfClass:[ICXMLTextBuilder class]]) {
        ICXMLTextBuilder *builder = (id)lastChild;
        [builder.resources addObject:string];
    } else {
        ICXMLTextBuilder *builder = [[ICXMLTextBuilder alloc] init];
        builder.parent = currentElement;

        ICXMLText *newText = [ICXMLText textWithString:string parent:currentElement];
        [builder.resources addObject:newText];
        [currentElement.children addObject:builder];

        [builder release];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    ICLog(ICXML_DEBUG, @"XML finished");
    self.document.parent = nil;
}

@end
