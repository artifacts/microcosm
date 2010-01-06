//
//  LevelView.h
//  Leveleditor
//
//  Created by Michael Markowski on 23.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sprite.h"
#import "Layer.h"

@interface LevelView : NSView {
	NSNumber *gridSize;
	NSTrackingArea *trackingArea;
	IBOutlet NSSlider *gridSizeSlider;
	IBOutlet NSTextField *gridSizeLabel;
	Layer *selectedLayer;
	NSManagedObject *selectedLevel;
	NSManagedObject *selectedTextureAtlas;
	BOOL spriteInteractionPending;
	NSRect selectionRect;
	CGFloat selectionRectPhase;
	NSTimer *drawSelectionRectTimer;
	NSRect drawableSelectionRect;
//	BOOL isSpanningSelectionRect;
//	CGPoint lastMouseDownLocation;
}

@property (nonatomic, retain) NSTrackingArea *trackingArea;
@property (nonatomic, retain) NSNumber *gridSize;
@property (nonatomic, retain) Layer *selectedLayer;
@property (nonatomic, retain) NSTimer *drawSelectionRectTimer;

- (Sprite*)spriteAtPosition:(NSPoint)aPoint;
- (IBAction)layersEdited:(id)sender;

- (CGFloat)levelWidthInPixels;
- (CGFloat)levelHeightInPixels;
- (int)totalNumberOfSprites;
- (void)drawGrid;
- (void)deleteSprite:(id)sender;
- (void)drawSelectionRect;
- (NSMutableArray*)spritesInRect:(NSRect)rect;

@end
