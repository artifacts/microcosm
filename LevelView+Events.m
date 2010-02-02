//
//  LevelView+Events.m
//  LevelEditor
//
//  Created by Michael Markowski on 14.12.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "LevelView+Events.h"
#import "Constants.h"
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
				[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
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
	
/*	
	if (s!=nil && ![[doc.selectedSprites arrangedObjects] containsObject:s]) {
		[doc.selectedSprites addObject:s];
	} else {
		[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
	}

	if ([[doc.selectedSprites arrangedObjects] count]>0) {
		[[NSCursor closedHandCursor] push];
		if (selectionRect.size.width==0 || selectionRect.size.height==0) {
			[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
		}
//		if (![doc.selectedSprites containsObject:doc.selectedSprite]) {
//			[doc.selectedSprites removeAllObjects];
//			selectionRect.size = NSMakeSize(0, 0);			
//		}		
		int count = 0;
	} else {
		selectionRect.origin = mouseDownLocation;
		selectionRect.size = NSMakeSize(0, 0);
		[doc.selectedSprites removeObjects:[doc.selectedSprites arrangedObjects]];
	}
 
 */
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

- (void)updateSprites:(NSArray*)sprites position:(NSPoint)position mouseOffsets:(CGPoint[])mouseOffsets {
	int count=0;
	NSPoint newLocation;
	NSSize grid = NSMakeSize([gridSize floatValue], [gridSize floatValue]);
	for (Sprite *s in sprites) {
		newLocation = position;
		newLocation.x -= mouseOffsets[count].x;
		newLocation.y -= mouseOffsets[count].y;
		
		newLocation.x = (int)(newLocation.x - ((int)newLocation.x) % (int)grid.width);
		newLocation.y = (int)(newLocation.y - ((int)newLocation.y) % (int)grid.height);						
		
		CGFloat xSnappedToGrid = ((int)s.location.x/(int)grid.width) * (int)grid.width;
		CGFloat ySnappedToGrid = ((int)s.location.y/(int)grid.height) * (int)grid.height;
		NSPoint spriteToGridOffset = NSMakePoint(s.location.x - xSnappedToGrid,
												 s.location.y - ySnappedToGrid);
		
		newLocation.x += spriteToGridOffset.x;
		newLocation.y += spriteToGridOffset.y;
		s.location = newLocation;
		count++;
	}		
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{    
    [[alert window] orderOut:nil];
}

@end
