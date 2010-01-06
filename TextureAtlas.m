//
//  TextureAtlas.m
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "TextureAtlas.h"
#import "Texture.h"

@implementation TextureAtlas

@synthesize cachedTextures;

- (NSMutableDictionary*)textures {
	if ([cachedTextures count] == 0) {
		self.cachedTextures = [NSMutableDictionary dictionary];
		NSImage *sheet = self.spriteSheetImage;
		NSDictionary *coords = self.coordinates;
		NSDictionary *framesDict = [coords objectForKey:@"frames"];
		for(NSString *frameDictKey in framesDict) {
			NSDictionary *frameDict = [framesDict objectForKey:frameDictKey];
			CGFloat x = [[frameDict objectForKey:@"x"] floatValue];
			CGFloat y = [[frameDict objectForKey:@"y"] floatValue];
			CGFloat w = [[frameDict objectForKey:@"width"] floatValue];
			CGFloat h = [[frameDict objectForKey:@"height"] floatValue];
			y = sheet.size.height - y - h;
			NSRect frame = NSMakeRect(x, y, w, h);
			Texture *s = [Texture new];
			s.key = frameDictKey;
			s.frame = frame;
			
			s.img = [[[NSImage alloc] initWithSize:s.frame.size] autorelease];
			[s.img lockFocus];
			[sheet drawInRect:NSMakeRect(0, 0, s.frame.size.width, s.frame.size.height) fromRect:s.frame operation:NSCompositeSourceOver fraction:1.0];
			[s.img unlockFocus];
			
			[cachedTextures setObject:s forKey:frameDictKey];
			[s release];
		}
	}
	return cachedTextures;
}

@end

@implementation TextureAtlas (CoreDataGeneratedPrimitiveAccessors)

- (void)setCoordinates:(id)value 
{
    [self willChangeValueForKey:@"coordinates"];
    [self setPrimitiveCoordinates:value];
    [self didChangeValueForKey:@"coordinates"];
	self.cachedTextures = nil;
}

- (void)setName:(NSString *)value 
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveName:value];
    [self didChangeValueForKey:@"name"];
	self.cachedTextures = nil;
}

- (void)setSpriteSheetImage:(id)value 
{
    [self willChangeValueForKey:@"spriteSheetImage"];
    [self setPrimitiveSpriteSheetImage:value];
    [self didChangeValueForKey:@"spriteSheetImage"];
	self.cachedTextures = nil;
}

@end

