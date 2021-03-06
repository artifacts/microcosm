//
//  LevelView+Events.m
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


#import "LevelView+Events.h"
#import "Model.h"
#import "AFGameEditor.h"
#import "Layer.h"
#import "NSColor+Hex.h"
#import "NSImage+Additions.h"

@implementation LevelView (Events)

- (IBAction)bgColorChanged:(id)sender {
	[self setNeedsDisplay:YES];
}

- (IBAction)gridSizeSliderValueChanged:(id)sender
{
	self.gridSize = [gridSizeSlider objectValue];
	[gridSizeLabel setStringValue:[gridSize stringValue]];
	[self setNeedsDisplay:YES];
}

- (IBAction)spriteAplhaValueChanged:(id)sender
{
	[self setNeedsDisplay:YES];
}

- (IBAction)layerAplhaValueChanged:(id)sender
{
	[self setNeedsDisplay:YES];
}

- (IBAction)layerTintValueChanged:(id)sender
{
	[self setNeedsDisplay:YES];
}

- (IBAction)spriteImpactValueChanged:(id)sender
{
	[self setNeedsDisplay:YES];
}

- (IBAction)toggleShowGrid:(id)sender {
	[self setNeedsDisplay:YES];
}

- (void)rightMouseDown:(NSEvent *)theEvent {
	[self mouseDown:theEvent];
}


- (void)keyDown:(NSEvent *)theEvent {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];	 
	if ([[doc.selectedSprites arrangedObjects] count]==0) return;
	
	unichar firstChar = [[theEvent characters] characterAtIndex: 0];	
	if ( ( firstChar == NSDeleteFunctionKey || firstChar == NSDeleteCharFunctionKey || firstChar == NSDeleteCharacter)) {
		[self deleteSprite:nil];
	}
	
    if ([theEvent modifierFlags] & NSNumericPadKeyMask) { // arrow keys have this mask
		int nudgeAmount = 1;		
		if ([theEvent modifierFlags] & NSShiftKeyMask) nudgeAmount = [gridSize floatValue];
        
		NSString *theArrow = [theEvent charactersIgnoringModifiers];
        unichar keyChar = 0;
        if ( [theArrow length] == 0 )
            return;            // reject dead keys
        if ( [theArrow length] == 1 ) {
            keyChar = [theArrow characterAtIndex:0];
            if ( keyChar == NSLeftArrowFunctionKey ) {
				for (Sprite *s in [doc.selectedSprites arrangedObjects]) {
					float x = [s.x floatValue];
					x = fmax(-s.size.width-1, x-nudgeAmount);
					s.x = [NSNumber numberWithFloat:x];					
				}				
				[self setNeedsDisplay:YES];		
                return;
            }
            if ( keyChar == NSRightArrowFunctionKey ) {
				for (Sprite *s in [doc.selectedSprites arrangedObjects]) {
					s.x = [NSNumber numberWithFloat:[s.x floatValue] + nudgeAmount];
				}
				[self setNeedsDisplay:YES];		
                return;
            }
            if ( keyChar == NSUpArrowFunctionKey ) {
				for (Sprite *s in [doc.selectedSprites arrangedObjects]) {
					s.y = [NSNumber numberWithFloat:[s.y floatValue] + nudgeAmount];
				}
				[self setNeedsDisplay:YES];		
                return;
            }
            if ( keyChar == NSDownArrowFunctionKey ) {
				for (Sprite *s in [doc.selectedSprites arrangedObjects]) {
					float y = [s.y floatValue];
					y = fmax(-s.size.height-1, y-nudgeAmount);
					s.y = [NSNumber numberWithFloat:y];
				}
				[self setNeedsDisplay:YES];		
                return;
            }
            [super keyDown:theEvent];
        }
    }
    [super keyDown:theEvent];
}

- (void)mouseDown:(NSEvent *)theEvent {
	spriteInteractionPending = YES;
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	BOOL keepOn = YES;
    BOOL isInside = YES;
	BOOL drawNewSelection = NO;
	NSPoint mouseOffsets[[[doc.selectedSprites arrangedObjects] count]];
	NSPoint mouseDownLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//	NSMutableArray *sprites = [selectedLayer valueForKey:@"sprites"];
	NSManagedObjectContext *moc = [doc managedObjectContext]; 
	NSPoint mouseToSelectionRectOffset = NSMakePoint(mouseDownLocation.x - selectionRect.origin.x,
													 mouseDownLocation.y - selectionRect.origin.y);
	NSSize grid = NSMakeSize([gridSize floatValue], [gridSize floatValue]);

	Sprite *selectedSprite;
	[[self window] makeFirstResponder:self];
	
	switch (doc.editMode) {
		case kEditModeMoveAndDrag:
			selectedSprite = [self spriteAtPosition:mouseDownLocation];
			if (selectedSprite && (selectionRect.size.width==0 && selectionRect.size.height==0)) {			
				if (!([theEvent modifierFlags] & NSCommandKeyMask) && [[doc.selectedSprites arrangedObjects] count]<2) {
					[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
				}
				[doc.selectedSprites addObject:selectedSprite];
			}
			break;
		case kEditModeSelect:
			if (!NSPointInRect(mouseDownLocation, selectionRect)) {				
				selectionRect.origin = mouseDownLocation;
				selectionRect.size = NSMakeSize(0, 0);
				[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
				drawNewSelection = YES;
			}
			break;
		case kEditModeDraw:
		{			
			NSPoint point = mouseDownLocation;
			selectedSprite = [self spriteAtPosition:point];
			if (!selectedSprite && doc.selectedTexture) {
				selectedSprite = [NSEntityDescription insertNewObjectForEntityForName:@"Sprite" inManagedObjectContext:moc];					
				point.x = (int)(point.x - ((int)point.x) % (int)grid.width);
				point.y = (int)(point.y - ((int)point.y) % (int)grid.height);					
				selectedSprite.location = point;
				selectedSprite.key = doc.selectedTexture.key;
				selectedSprite.layer = selectedLayer;
				NSArrayController *controller = doc.textureAtlasArrayController;
				id atlas = [[controller selection] valueForKey:@"self"];
				selectedSprite.textureAtlas = atlas;
				[[[doc managedObjectContext] undoManager] beginUndoGrouping];
				[[[doc managedObjectContext] undoManager] setActionName:@"Undo Draw Sprite"];				
				[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];	
				[doc.selectedSprites addObject:selectedSprite];								
				[[[doc managedObjectContext] undoManager] endUndoGrouping];
			} else {
				[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];	
				[doc.selectedSprites addObject:selectedSprite];				
			}
			break;
		}			
	}
	
	// save distance from mouse pointer to selected sprites
	int count=0;
	for (Sprite *s in [doc.selectedSprites arrangedObjects]) {
		NSPoint mouseOffset = NSMakePoint(mouseDownLocation.x - s.location.x, 
										  mouseDownLocation.y - s.location.y);	
		mouseOffsets[count] = mouseOffset;			
		count++;
	}
	
    while (keepOn) {
		if ([selectedLayer.visibleInEditor boolValue]==NO) {
			NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"No visible layer selected", @"No visible layer selected") 
											 defaultButton:NSLocalizedString(@"Ok", @"Ok Button") 
										   alternateButton:nil 
											   otherButton:nil 
								 informativeTextWithFormat:NSLocalizedString(@"The layer you want to draw on is currently not visible in the editor. \
																			 Please select another layer or turn on visibility.", 
																			 @"Layer not visible for drawing alert.")];

			[alert beginSheetModalForWindow:[self window]
							  modalDelegate:self
							 didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
								contextInfo:NULL];
			keepOn = NO;
		}
        theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask | NSRightMouseUpMask | NSLeftMouseDraggedMask];
        isInside = [self mouse:mouseDownLocation inRect:[self bounds]];
		NSPoint currentMouseLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];	
        switch ([theEvent type]) {
			case NSLeftMouseDragged:
				if (!isInside) break;
				switch (doc.editMode) {
					
					// SELECT MODE
					case kEditModeSelect:
						if (drawNewSelection==YES) {
							// enlarge selection rectangle
							CGFloat width, height;
							width = currentMouseLocation.x-selectionRect.origin.x;
							height = currentMouseLocation.y-selectionRect.origin.y;
							selectionRect.size = NSMakeSize(width, height);
							[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
							[doc.selectedSprites addObjects:[self spritesInRect:selectionRect]];
//							[self scrollPoint:currentMouseLocation];
							[self autoscroll:theEvent];

						} else {							
							// move selection rectangle
							NSPoint newRectLocation = currentMouseLocation;
							//newRectLocation.x = (int)(newRectLocation.x - ((int)newRectLocation.x) % (int)grid.width);
							//newRectLocation.y = (int)(newRectLocation.y - ((int)newRectLocation.y) % (int)grid.height);					
							selectionRect.origin = newRectLocation;
							selectionRect.origin.x -= mouseToSelectionRectOffset.x;
							selectionRect.origin.y -= mouseToSelectionRectOffset.y;
						}
						break;
					
					// DRAW MODE
					case kEditModeDraw:
						[self updateSprites:[doc.selectedSprites arrangedObjects] position:currentMouseLocation mouseOffsets:mouseOffsets];
						break;
						
					// MOVE & DRAG MODE
					case kEditModeMoveAndDrag:						
						[self updateSprites:[doc.selectedSprites arrangedObjects] position:currentMouseLocation mouseOffsets:mouseOffsets];
						break;
				}
				break;
            case NSLeftMouseUp: {
				keepOn = NO;
				break;
			}
			case NSRightMouseUp:
				if ([[doc.selectedSprites arrangedObjects] count]==0) {
					keepOn = NO; 
					break;
				}
				NSMenu *theMenu = [[[NSMenu alloc] initWithTitle:@"Edit Sprite"] autorelease];
				[theMenu insertItemWithTitle:@"Delete" action:@selector(deleteSprite:) keyEquivalent:@"" atIndex:0];	
				[theMenu insertItem:[NSMenuItem separatorItem] atIndex:1];
				[theMenu insertItemWithTitle:@"Send forward" action:@selector(sendSpriteForward:) keyEquivalent:@"" atIndex:2];	
				[theMenu insertItemWithTitle:@"Send backward" action:@selector(sendSpriteBackward:) keyEquivalent:@"" atIndex:3];	
				[theMenu insertItem:[NSMenuItem separatorItem] atIndex:4];
				[theMenu insertItemWithTitle:@"Reset zIndex" action:@selector(resetSpriteZIndex:) keyEquivalent:@"" atIndex:5];	
				[theMenu insertItem:[NSMenuItem separatorItem] atIndex:6];
				[theMenu insertItemWithTitle:@"Send to front" action:@selector(bringSpriteToFront:) keyEquivalent:@"" atIndex:7];	
				[theMenu insertItemWithTitle:@"Send to back" action:@selector(sendSpriteToBack:) keyEquivalent:@"" atIndex:8];	
				
				[NSMenu popUpContextMenu:theMenu withEvent:theEvent forView:self];
				keepOn = NO;
				break;
            default:
				/* Ignore any other kind of event. */
				break;
        }
		[self setNeedsDisplay:YES];					
    };
	[NSCursor pop];
	spriteInteractionPending = NO;
    return;
}

- (NSInteger)highestZIndex {
	NSArray *sprites = [self spritesSortedByZIndex:NO];
	NSNumber *maxZIndex = [[sprites objectAtIndex:0] valueForKey:@"zIndex"];
	NSLog(@"highest zIndex: %@", maxZIndex);
	return [maxZIndex integerValue];
}

- (NSArray*)spritesSortedByZIndex:(BOOL)ascending {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	if ([[doc.spriteArrayController arrangedObjects] count]==0) return 0;
	
	NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"zIndex" ascending:ascending] autorelease];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];	
	[doc.spriteArrayController setSortDescriptors:sortDescriptors];	
	NSArray *result = [doc.spriteArrayController arrangedObjects];
	[doc.spriteArrayController setSortDescriptors:nil];
	[sortDescriptors release];
	return result;
}

- (NSInteger)lowestZIndex {
	NSArray *sprites = [self spritesSortedByZIndex:YES];
	NSNumber *minZIndex = [[sprites objectAtIndex:0] valueForKey:@"zIndex"];
	NSLog(@"lowest zIndex: %@", minZIndex);
	return [minZIndex integerValue];
}

- (void)sendSpriteForward:(id)sender {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	for (Sprite *sprite in [doc.selectedSprites arrangedObjects]) {
		NSInteger currentZIndex = [[sprite valueForKey:@"zIndex"] integerValue];		
		currentZIndex++;
		[sprite setValue:[NSNumber numberWithInteger:currentZIndex] forKey:@"zIndex"];
		NSLog(@"sprite: %@", [sprite valueForKey:@"zIndex"]);
	}
	[self setNeedsDisplay:YES];
}

- (void)sendSpriteBackward:(id)sender {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	for (Sprite *sprite in [doc.selectedSprites arrangedObjects]) {
		NSInteger currentZIndex = [[sprite valueForKey:@"zIndex"] integerValue];
		currentZIndex--;
		[sprite setValue:[NSNumber numberWithInteger:currentZIndex] forKey:@"zIndex"];
	}
	[self setNeedsDisplay:YES];
}

- (void)bringSpriteToFront:(id)sender {
	NSInteger z = [self highestZIndex]; z++;
	[self setSelectedSpritesZIndex:z];
}

- (void)sendSpriteToBack:(id)sender {
	NSInteger z = [self lowestZIndex]; z--;	
	[self setSelectedSpritesZIndex:z];
}

- (void)resetSpriteZIndex:(id)sender {
	[self setSelectedSpritesZIndex:0];
}

- (void)setSelectedSpritesZIndex:(int)zIndex {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	for (Sprite *sprite in [doc.selectedSprites arrangedObjects]) {
		[sprite setValue:[NSNumber numberWithInteger:zIndex] forKey:@"zIndex"];
	}
	[self setNeedsDisplay:YES];
}

- (void)updateSprites:(NSArray*)sprites position:(NSPoint)position mouseOffsets:(CGPoint[])mouseOffsets {
	int count=0;
	NSPoint newLocation;
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	if ([doc.game.showGridInEditor boolValue]==YES) {
		NSSize grid = NSMakeSize([gridSize floatValue], [gridSize floatValue]);
		CGFloat xSnappedToGrid = ((int)position.x/(int)grid.width) * (int)grid.width;
		CGFloat ySnappedToGrid = ((int)position.y/(int)grid.height) * (int)grid.height;	
		position.x = xSnappedToGrid;
		position.y = ySnappedToGrid;
	}
	
	for (Sprite *s in sprites) {
		newLocation = position;
		newLocation.x -= mouseOffsets[count].x;
		newLocation.y -= mouseOffsets[count].y;
		s.location = newLocation;
		count++;
	}		
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{    
    [[alert window] orderOut:nil];
}

@end
