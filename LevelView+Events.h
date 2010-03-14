//
//  LevelView+Events.h
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
