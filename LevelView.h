//
//  LevelView.h
//  Leveleditor
//
//  Created by Michael Markowski on 23.11.09.
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
	BOOL userHoldingCommandKey;
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
- (NSRect)absRect:(NSRect)rect;

@end
