//
//  Sprite.m
//  Leveleditor
//
//  Created by Michael Markowski on 24.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

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

