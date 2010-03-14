//
//  Sprite.m
//  Leveleditor
//
//  Created by Michael Markowski on 24.11.09.
//  Copyright (c) 2010 Artifacts - Fine Software Development
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "Sprite.h"
#import "AFGameEditor.h"
#import "Texture.h"
#import "NSColor+Hex.h"

@implementation Sprite

- (void)setLocation:(NSPoint)aPoint
{
	self.x = [NSNumber numberWithFloat:aPoint.x];
	self.y = [NSNumber numberWithFloat:aPoint.y];
}

- (NSPoint)location 
{	
	return NSMakePoint([self.x floatValue], [self.y floatValue]);
}

- (NSSize)size
{
	return NSMakeSize([self texture].frame.size.width, [self texture].frame.size.height);
}

- (NSColor*)tintColorAsColor {
	return [NSColor colorFromNumber:self.tintColor];
}

- (NSString*)description {
	return [NSString stringWithFormat: @"Sprite position (%@, %@, %@, %@), key: %@, layer:%@, textureAtlas:%@, objectId:%@", self.x, self.y, self.width, self.height, self.key, [self.layer description], [self.textureAtlas description], [[self objectID] description]];
}

+ (NSArray *) keysToBeCopied
{
	static NSArray *keysToBeCopied = nil;
	if (keysToBeCopied == nil)
	{
		// This will determine which attributes get copied. Must NOT copy relationships or it will copy the actual entity
		// Date has been left out so that the date will default to the current date.
		keysToBeCopied = [[NSArray alloc] initWithObjects:
						  @"hasPhysics",
						  @"height",
						  @"isGhost",
						  @"key",
						  @"width",
						  @"x",
						  @"y",
//						  @"layer",
//						  @"textureAtlas",
						  @"impact",
						  @"opacity",
						  @"tintColor",
						  @"tintEnabled",
						  @"zIndex",
						  @"properties",						  
//						  @"animationSequence",
						  nil];
	}
	return keysToBeCopied;
}

- (NSDictionary *) dictionaryRepresentation
{
	return [self dictionaryWithValuesForKeys:[[self class] keysToBeCopied]];
}
/*
- (NSString *) stringDescription
{
	// This will return the title of the category as a string
	NSString *stringDescription = nil;
	NSManagedObject *category = self.category;
	if (category != nil)
	{
		stringDescription = category.name;
	}
	return stringDescription;
}
*/
@end

@implementation Sprite (HUDInfo)

- (NSImage*)image {
	return [self texture].img;
}

- (Texture*)texture {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	NSMutableDictionary *sdefs = [doc allTextures];
	Texture *texture = [sdefs objectForKey:self.key];	
	return texture;
}

@end

@implementation Sprite (CoreDataGeneratedAccessors)

@dynamic x, y, width, height, hasPhysics, isGhost, layer, key, textureAtlas, opacity, impact, tintColor, tintEnabled;

@end

