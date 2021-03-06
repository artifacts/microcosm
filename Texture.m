//
//  SpriteDefinition.m
//  Leveleditor
//
//  Created by Michael Markowski on 26.11.09.
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


#import "Texture.h"


@implementation Texture

@synthesize frame;
@synthesize key;
@synthesize img;

- (NSString*)description {
	return [NSString stringWithFormat:@"key: %@, frame: (%f,%f,%f,%f)", key, frame.origin.x, frame.origin.y, frame.size.width, frame.size.height];
}

- (CGFloat)width {
	return frame.size.width;
}

- (CGFloat)height {
	return frame.size.height;
}

- (CGFloat)xPosition {
	return frame.origin.x;
}

- (CGFloat)yPosition {
	return frame.origin.y;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:[NSNumber numberWithFloat:self.xPosition] forKey:@"TextureX"];
    [coder encodeObject:[NSNumber numberWithFloat:self.yPosition] forKey:@"TextureY"];
    [coder encodeObject:[NSNumber numberWithFloat:self.width] forKey:@"TextureWidth"];
    [coder encodeObject:[NSNumber numberWithFloat:self.height] forKey:@"TextureHeight"];
    [coder encodeObject:key forKey:@"TextureKey"];
    [coder encodeObject:img forKey:@"TextureImg"];
}

- (id)initWithCoder:(NSCoder *)coder
{
	NSRect f;
    f.origin.x = [[coder decodeObjectForKey:@"TextureX"] floatValue];
    f.origin.y = [[coder decodeObjectForKey:@"TextureY"] floatValue];
    f.size.width = [[coder decodeObjectForKey:@"TextureWidth"] floatValue];
    f.size.height = [[coder decodeObjectForKey:@"TextureHeight"] floatValue];	
    self.key = [coder decodeObjectForKey:@"TextureKey"];	
    self.img = [coder decodeObjectForKey:@"TextureImg"];	
    return self;
}

@end
