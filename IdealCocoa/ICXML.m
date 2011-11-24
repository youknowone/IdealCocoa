//
//  ICXML.m
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

#define ICXML_DEBUG FALSE

#import "NSDataAdditions.h"
#import "NSURLAdditions.h"
#import "ICXML.h"

@interface ICXMLElement (private)

- (NSString *)_descriptionWithDepth:(NSInteger)depth;

@end


@implementation ICXMLElement

@synthesize space, name, elements, attributes, parent;

- (id)initWithName:(NSString*)aName attributes:(NSDictionary*)attributeDict elements:(NSArray *)elementsArray {
    self = [super init];
    if (self != nil) {
        self.name = aName;
        self.attributes = attributeDict;
        self.elements = elementsArray ? [NSMutableArray arrayWithArray:elementsArray] : [NSMutableArray array]; // legacy support
    }
    return self;
}

- (void)dealloc {
    self.name = nil;
    self.elements = nil;
    self.attributes = nil;
    [super dealloc];
}

- (BOOL) isRoot {
    return self.parent == nil;
}

+ (id)elementWithName:(NSString *)name attributes:(NSDictionary *)attributes elements:(NSArray *)elements {
    return [[[self alloc] initWithName:name attributes:attributes elements:elements] autorelease];
}

+ (ICXMLElement *)textElementWithString:(NSString*)text {
    ICXMLElement *elem = [[[self alloc] initWithName:nil attributes:nil elements:nil] autorelease];
    elem.elements = (id)text;
    return elem;
}

- (NSString *)text {
    if ( name != nil ) {
        NSMutableString *string = [NSMutableString string];
        for (ICXMLElement *elem in elements) {
            [string appendString:elem.description];
        }
        if ([string isEqualToString:@""]) {
            return nil;
        }
        return string;
    }
    return (NSString *)self->elements;
}

- (BOOL)hasPureText {
    if ([self.elements isKindOfClass:[NSString class]]) return YES;
    if (self.elements.count != 1) return NO;
    return [[[self.elements objectAtIndex:0] elements] isKindOfClass:[NSString class]];
}

- (NSString *)description {
    return [self _descriptionWithDepth:0];
}

- (id) copyWithZone:(NSZone *)zone {
    ICXMLElement *copy;
    if ( self.name != nil ) {
        copy = [[[self class] alloc] initWithName:self.name attributes:self.attributes elements:self.elements];
    } else {
        copy = [[[self class] textElementWithString:self.text] retain];
    }
    return copy;
}

@end

@implementation ICXMLElement (private)

- (NSString *)_descriptionWithDepth:(NSInteger)depth {
    NSMutableString *indent = [[NSMutableString alloc] init];
    for ( NSInteger i = 0; i < depth; i++ ) {
        [indent appendString:@"\t"];
    }
    if ( name == nil ) {
        NSString *desc = [NSString stringWithFormat:@"%@%@", indent, self.text];
        [indent release];
        return desc;
    }
    NSMutableString *attrs = [[NSMutableString alloc] init];
    for ( NSString *key in [attributes keyEnumerator] ) {
        [attrs appendFormat:@" %@=\"%@\"", key, [attributes objectForKey:key]];
    }
    NSMutableString *elems = [[NSMutableString alloc] init];
    for ( ICXMLElement *e in elements ) {
        [elems appendFormat:@"\n%@", [e _descriptionWithDepth:depth+1]];
    }
    if ( [elems length] > 0 ) {
        [elems appendFormat:@"\n%@", indent];
    }
    NSString *desc = [NSString stringWithFormat:@"%@<%@%@>%@</%@>", indent, name, attrs, elems, name];
    [indent release];
    [attrs release];
    [elems release];
    return desc;
}

@end


@implementation ICXMLElement (creation)

+ (ICXMLElement *)elementWithData:(NSData *)data {
    ICXMLSimpleParser *parser = [[[ICXMLSimpleParser alloc] initWithData:data] autorelease];
    return parser.document;
}

+ (ICXMLElement *)elementWithContentOfURL:(NSURL *)url {
    ICXMLSimpleParser *parser = [[[ICXMLSimpleParser alloc] initWithContentsOfURL:url] autorelease];
    return parser.document;
}

+ (ICXMLElement *)elementWithString:(NSString *)dataString {
    return [self elementWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding]];
}

@end


@implementation ICXMLSimpleParser

@synthesize errorDelegate;

- (ICXMLElement *)document {
    #if IC_DEBUG
    if ( [rootElement.elements count] == 0 ) {
        ICLog(1, @"ERROR: root document is blank at %p / %@", rootElement, rootElement);
    }
    #endif
    return [rootElement.elements objectAtIndex:0];
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
    rootElement = [[ICXMLElement alloc] initWithName:nil attributes:nil elements:[NSMutableArray array]];
    currentElement = rootElement;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    ICLog(ICXML_DEBUG, @"<%@> start with attributes: %@", elementName, attributeDict);
    ICXMLElement* childElement = [[ICXMLElement alloc] initWithName:elementName attributes:attributeDict elements:[NSMutableArray array]];
    [(NSMutableArray *)currentElement.elements addObject:childElement];
    childElement.parent = currentElement;
    [childElement release];
    currentElement = childElement;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    ICLog(ICXML_DEBUG, @"</%@> end", elementName);
    //currentElement.elements = [NSArray arrayWithArray:currentElement.elements];
    
    for (NSInteger i = currentElement.elements.count - 1; i >= 0; i--) {
        ICXMLElement *elem = [currentElement.elements objectAtIndex:i];
        if (elem.name == nil) {
            NSString *text = [[NSString stringWithString:(id)elem.elements] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (text.length == 0) {
                [(NSMutableArray *)currentElement.elements removeObjectAtIndex:i];
                continue;
            }
            elem.elements = (id)text;
        }
    }
    currentElement = currentElement.parent;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    ICLog(ICXML_DEBUG, @"characters found: %@", string);
    if (currentElement.elements.count > 0 && [[currentElement.elements.lastObject elements] isKindOfClass:[NSMutableString class]]) {
        ICXMLElement *elem = currentElement.elements.lastObject;
        [(NSMutableString *)elem.elements appendString:string];
    } else {
        [(NSMutableArray *)currentElement.elements addObject:[ICXMLElement textElementWithString:[NSMutableString stringWithString:string]]];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    ICLog(ICXML_DEBUG, @"XML finished");
    self.document.parent = nil;
}

@end
