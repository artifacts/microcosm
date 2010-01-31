//
//  TextureController#.h
//  LevelEditor
//
//  Created by Michael Markowski on 29.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TextureController.h"

@interface TextureController (Tree)

- (void)outlineViewAction:(id)sender;
- (IBAction)addSpriteTypeAction:(id)obj;
- (IBAction)removeSpriteTypeAction:(id)obj;
- (NSImage*)imageThumbnailFromImage:(NSImage*)sourceImage;

@end
