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
	if (!doc.selectedSprite) return;

	
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
				for (Sprite *s in doc.selectedSprites) {
					float x = [s.x floatValue];
					x = fmax(-s.size.width-1, x-nudgeAmount);
					s.x = [NSNumber numberWithFloat:x];					
				}				
				[self setNeedsDisplay:YES];		
                return;
            }
            if ( keyChar == NSRightArrowFunctionKey ) {
				for (Sprite *s in doc.selectedSprites) {
					s.x = [NSNumber numberWithFloat:[s.x floatValue] + nudgeAmount];
				}
				[self setNeedsDisplay:YES];		
                return;
            }
            if ( keyChar == NSUpArrowFunctionKey ) {
				for (Sprite *s in doc.selectedSprites) {
					s.y = [NSNumber numberWithFloat:[s.y floatValue] + nudgeAmount];
				}
				[self setNeedsDisplay:YES];		
                return;
            }
            if ( keyChar == NSDownArrowFunctionKey ) {
				for (Sprite *s in doc.selectedSprites) {
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
	//	[self.window invalidateCursorRectsForView:self];
	BOOL keepOn = YES;
    BOOL isInside = YES;
	BOOL mayCreateNewOnMouseUp = YES;
	CGPoint mouseOffsets[[doc.selectedSprites count]];
    NSPoint mouseLoc;
	NSPoint mouseDownLocation = [self convertPoint:[theEvent locationInWindow] fromView:nil];
//	lastMouseDownLocation = point;
	NSMutableArray *sprites = [selectedLayer valueForKey:@"sprites"];
	doc.selectedSprite = [self spriteAtPosition:mouseDownLocation];
	NSManagedObjectContext *moc = [doc managedObjectContext]; 
	NSPoint mouseToSelectionRectOffset = NSMakePoint(mouseDownLocation.x - selectionRect.origin.x,
													 mouseDownLocation.y - selectionRect.origin.y);
	[[self window] makeFirstResponder:self];
	if (doc.selectedSprite) {
		[[NSCursor closedHandCursor] push];
		if (selectionRect.size.width==0 || selectionRect.size.height==0) {
			[doc.selectedSprites removeAllObjects];
		}
		if (![doc.selectedSprites containsObject:doc.selectedSprite]) {
			[doc.selectedSprites removeAllObjects];
			selectionRect.size = NSMakeSize(0, 0);			
			[doc.selectedSprites addObject:doc.selectedSprite];
		}		
		int count = 0;
		for (Sprite *s in doc.selectedSprites) {
			NSPoint mouseOffset = NSMakePoint(mouseDownLocation.x - s.location.x, 
											  mouseDownLocation.y - s.location.y);	
			mouseOffsets[count] = mouseOffset;			
			count++;
		}
	} else {
		selectionRect.origin = mouseDownLocation;
		selectionRect.size = NSMakeSize(0, 0);
		[doc.selectedSprites removeAllObjects];
	}
    while (keepOn) {
		if ([selectedLayer.visibleInEditor boolValue]==NO) {
			NSAlert *alert = [NSAlert alertWithMessageText:NSLocalizedString(@"No visible layer selected", @"No visible layer selected") 
							defaultButton:NSLocalizedString(@"Ok", @"Ok Button") 
						  alternateButton:nil otherButton:nil informativeTextWithFormat:NSLocalizedString(@"The layer you want to draw on is currently not visible in the editor. Please select another layer or turn on visibility.", @"The layer you want to draw on is currently not visible in the editor. Please select another layer or turn on visibility.")];
			[alert beginSheetModalForWindow:[self window]
							  modalDelegate:self
							 didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:)
								contextInfo:NULL];
			keepOn = NO;
		}
        theEvent = [[self window] nextEventMatchingMask: NSLeftMouseUpMask | NSRightMouseUpMask |
					NSLeftMouseDraggedMask];
        mouseLoc = [self convertPoint:[theEvent locationInWindow] fromView:nil];
        isInside = [self mouse:mouseLoc inRect:[self bounds]];
		NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];	
		NSSize grid = NSMakeSize([gridSize floatValue], [gridSize floatValue]);
		//		NSLog(@"Mouse pointer: %f,%f. Sprite location: %f,%f.", point.x, point.y, selectedSprite.location.x, selectedSprite.location.y);		
		
        switch ([theEvent type]) {
			case NSLeftMouseDragged:
				if (!isInside) break;
				if (doc.selectedSprite) {

					// move selection rectangle
					NSPoint newRectLocation = point;
					newRectLocation.x = (int)(newRectLocation.x - ((int)newRectLocation.x) % (int)grid.width);
					newRectLocation.y = (int)(newRectLocation.y - ((int)newRectLocation.y) % (int)grid.height);					
					selectionRect.origin = newRectLocation;
					selectionRect.origin.x -= mouseToSelectionRectOffset.x;
					selectionRect.origin.y -= mouseToSelectionRectOffset.y;
					
					int count = 0;
					for (Sprite *s in doc.selectedSprites) {
						NSPoint newLocation = point;
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
						// only snap to grid if sprite was aligned to grid before
						// otherwise, fine-tuned sprite positions (via nudging) would be lost
//						if (((int)s.location.x) % (int)grid.width == 0 &&
//							((int)s.location.y) % (int)grid.height == 0) {
//							newLocation.x = (int)(newLocation.x - ((int)newLocation.x) % (int)grid.width);
//							newLocation.y = (int)(newLocation.y - ((int)newLocation.y) % (int)grid.height);
//						}
						//NSRect f = self.frame;
						/*
						// enlarge horizontally if necessary
						if ((point.x + doc.selectedSprite.size.width*2) > f.size.width) {
							f.size.width += doc.selectedSprite.size.width;
							self.frame = f;
							[self setNeedsDisplay:YES];
						}
						// enlarge vertically if necessary
						if ((point.y + doc.selectedSprite.size.height*2) > f.size.height) {
							f.size.height += doc.selectedSprite.size.height;
							self.frame = f;
							[self setNeedsDisplay:YES];
						}
						*/
					
						//	NSLog(@"point.x: %f, sprite width: %f, size: %f", point.x, doc.selectedSprite.size.width, f.size.width);					
						//	NSLog(@"selectedSprite: %@", doc.selectedSprite);
						s.location = newLocation;
						count++;
					}					
				} else {
					CGFloat width, height;
					width = point.x-selectionRect.origin.x;
					height = point.y-selectionRect.origin.y;
					selectionRect.size = NSMakeSize(width, height);
					doc.selectedSprites = [self spritesInRect:selectionRect];
				}
				mayCreateNewOnMouseUp = NO;				
				break;
            case NSLeftMouseUp: {
				// use sprite at position, if there is any
				Sprite *spriteToDraw = [self spriteAtPosition:point];
				// else create a new one
				if (!spriteToDraw && doc.selectedTexture && mayCreateNewOnMouseUp) {
					spriteToDraw = [NSEntityDescription insertNewObjectForEntityForName:@"Sprite" inManagedObjectContext:moc];
					
					point.x = (int)(point.x - ((int)point.x) % (int)grid.width);
					point.y = (int)(point.y - ((int)point.y) % (int)grid.height);
					
					spriteToDraw.location = point;
					spriteToDraw.key = doc.selectedTexture.key;
					spriteToDraw.layer = selectedLayer;
					NSArrayController *controller = doc.textureAtlasArrayController;
					id atlas = [[controller selection] valueForKey:@"self"];
					spriteToDraw.textureAtlas = atlas;
					[sprites addObject:spriteToDraw];
				}
				doc.selectedSprite = spriteToDraw;				
//				if (spriteToDraw.key) {
//					[selectedLayer setValue:sprites forKey:@"sprites"];
//				}
//				TextureAtlas *atlas = [doc.textureAtlasArrayController selection];				
//				[atlas setValue:sprites forKey:@"sprites"];
				keepOn = NO;				
				break;
			}
			case NSRightMouseUp:
				if (!doc.selectedSprite) {
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

- (void)alertDidEnd:(NSAlert *)alert returnCode:(int)returnCode contextInfo:(void *)contextInfo
{    
    [[alert window] orderOut:nil];
}

@end
