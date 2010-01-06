//
//  NSImage+Additions.h
//  LevelEditor
//
//  Created by Michael Markowski on 14.12.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSImage (Additions)

- (NSImage *)imageTintedWithColor:(NSColor *)tint;
- (NSImage*)imageCroppedToRect:(NSRect)rect;

@end
