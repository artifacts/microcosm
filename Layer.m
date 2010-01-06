//
//  Layer.m
//  Leveleditor
//
//  Created by Michael Markowski on 29.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "Layer.h"
#import "NSColor+Hex.h"

@implementation Layer

- (NSString*)descriptionForHUD
{
	return [NSString stringWithFormat: @"%@, viewPosition: %d", self.name, self.viewPosition];
}

@end

@implementation Layer (CoreDataGeneratedAccessors)

@dynamic name, visibleInEditor, visibleInScenery, level, sprites, viewPosition, opacity, tintColor, tintEnabled;

- (NSColor*)tintColorAsColor {
	return [NSColor colorFromNumber:self.tintColor];
}

@end
