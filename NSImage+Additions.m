//
//  NSImage+Additions.m
//  LevelEditor
//
//  Created by Michael Markowski on 14.12.09.
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


#import "NSImage+Additions.h"
#import <Quartz/Quartz.h>

@implementation NSImage (Additions)

- (NSImage *)imageTintedWithColor:(NSColor *)tint 
{
    if (tint != nil) {
        NSSize size = [self size];
        NSRect bounds = { NSZeroPoint, size };
        NSImage *tintedImage = [[NSImage alloc] initWithSize:size];
		
        [tintedImage lockFocus];
		
        CIFilter *colorGenerator = [CIFilter filterWithName:@"CIConstantColorGenerator"];
        CIColor *color = [[[CIColor alloc] initWithColor:tint] autorelease];
		
        [colorGenerator setValue:color forKey:@"inputColor"];
		
        CIFilter *monochromeFilter = [CIFilter filterWithName:@"CIColorMonochrome"];
        CIImage *baseImage = [CIImage imageWithData:[self TIFFRepresentation]];
		
        [monochromeFilter setValue:baseImage forKey:@"inputImage"];             
        [monochromeFilter setValue:[CIColor colorWithRed:0.75 green:0.75 blue:0.75] forKey:@"inputColor"];
        [monochromeFilter setValue:[NSNumber numberWithFloat:1.0] forKey:@"inputIntensity"];
		
        CIFilter *compositingFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
		
        [compositingFilter setValue:[colorGenerator valueForKey:@"outputImage"] forKey:@"inputImage"];
        [compositingFilter setValue:[monochromeFilter valueForKey:@"outputImage"] forKey:@"inputBackgroundImage"];
		
        CIImage *outputImage = [compositingFilter valueForKey:@"outputImage"];
		
        [outputImage drawAtPoint:NSZeroPoint
						fromRect:bounds
					   operation:NSCompositeCopy
						fraction:1.0];
		
        [tintedImage unlockFocus];  
		
        return [tintedImage autorelease];
    }
    else {
        return [[self copy] autorelease];
    }
}

- (NSImage*)imageCroppedToRect:(NSRect)rect
{
    NSPoint point = { -rect.origin.x, -rect.origin.y };
    NSImage *croppedImage = [[NSImage alloc] initWithSize:rect.size];
	
    [croppedImage lockFocus];
    {
        [self compositeToPoint:point operation:NSCompositeCopy];
    }
    [croppedImage unlockFocus];
	
    return [croppedImage autorelease];
}

@end
