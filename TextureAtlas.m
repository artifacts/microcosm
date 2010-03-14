//
//  TextureAtlas.m
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
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


#import "TextureAtlas.h"
#import "Texture.h"

@implementation TextureAtlas


- (NSMutableDictionary*)textures {
	if (_cachedTextures==nil || [_cachedTextures count] == 0) {
		_cachedTextures = [[NSMutableDictionary dictionary] retain];
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
			
			[_cachedTextures setObject:s forKey:frameDictKey];
			[s release];
		}
	}
	return _cachedTextures;
}

@end

@implementation TextureAtlas (CoreDataGeneratedPrimitiveAccessors)

- (void)setCoordinates:(id)value 
{
    [self willChangeValueForKey:@"coordinates"];
    [self setPrimitiveCoordinates:value];
    [self didChangeValueForKey:@"coordinates"];
	_cachedTextures = nil;
}

- (void)setName:(NSString *)value 
{
    [self willChangeValueForKey:@"name"];
    [self setPrimitiveName:value];
    [self didChangeValueForKey:@"name"];
	_cachedTextures = nil;
}

- (void)setSpriteSheetImage:(id)value 
{
    [self willChangeValueForKey:@"spriteSheetImage"];
    [self setPrimitiveSpriteSheetImage:value];
    [self didChangeValueForKey:@"spriteSheetImage"];
	_cachedTextures = nil;
}

@end

