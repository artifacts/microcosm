//
//  NSColorToNumberTransformer.m
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "NumberToColorTransformer.h"
#import "NSColor+Hex.h"

@implementation NumberToColorTransformer

+ (Class)transformedValueClass
{
    return [NSColor class];
}

- (id)transformedValue:(id)value
{
	NSUInteger hex = [value unsignedIntegerValue];
	return HEXCOLOR(hex);
}

- (id)reverseTransformedValue:(id)value
{
    return [value asNumber];
}

@end
