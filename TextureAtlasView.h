//
//  SpriteSheetImage.h
//  Leveleditor
//
//  Created by Michael Markowski on 20.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Quartz/Quartz.h>
#import "Texture.h"
#import "LevelView.h"
#import "TextureAtlas.h"

@interface TextureAtlasView : NSView {
	IBOutlet NSDictionary *coords;
	NSImage *image;
	Texture *lastHighlightedTexture;
	Texture *highlightedTexture;	
	NSTrackingArea *trackingArea;
	IBOutlet NSImageView *currentSpriteView;
	IBOutlet LevelView *levelView;
	TextureAtlas *selectedTextureAtlas;
}

@property (nonatomic, retain) IBOutlet NSDictionary *coords;
@property (nonatomic, retain) NSImage *image;
@property (nonatomic, retain) IBOutlet NSImageView *currentSpriteView;

- (Texture*)textureAtPoint:(NSPoint)aPoint;

@end
