//
//  SpriteDefinition.m
//  Leveleditor
//
//  Created by Michael Markowski on 26.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

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

@end
