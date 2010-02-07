//
//  LevelView+Events.h
//  LevelEditor
//
//  Created by Michael Markowski on 14.12.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LevelView.h"

@interface LevelView (Events)

- (IBAction)bgColorChanged:(id)sender;
- (IBAction)spriteAplhaValueChanged:(id)sender;
- (IBAction)layerAplhaValueChanged:(id)sender;
- (IBAction)layerTintValueChanged:(id)sender;
- (IBAction)gridSizeSliderValueChanged:(id)sender;
- (IBAction)toggleShowGrid:(id)sender;
- (IBAction)spriteImpactValueChanged:(id)sender;
- (void)updateSprites:(NSArray*)sprites position:(NSPoint)newLocation mouseOffsets:(CGPoint[])mouseOffsets;
- (NSArray*)spritesSortedByZIndex:(BOOL)ascending;
- (void)setSelectedSpritesZIndex:(int)zIndex;

@end
