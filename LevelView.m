//
//  LevelView.m
//  Leveleditor
//
//  Created by Michael Markowski on 23.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "LevelView.h"
#import "Constants.h"
#import "Model.h"
#import "AFGameEditor.h"
#import "Layer.h"
#import "NSColor+Hex.h"
#import "NSImage+Additions.h"

@implementation LevelView

@synthesize trackingArea;
@synthesize gridSize;
//@synthesize selectedSprite;
@synthesize selectedLayer;
@synthesize drawSelectionRectTimer;

- (void)awakeFromNib {
	self.gridSize = [NSNumber numberWithFloat:32.0];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (CGFloat)levelWidthInPixels {
	return self.frame.size.width;
}

- (CGFloat)levelHeightInPixels {
	return self.frame.size.height;
}

- (int)totalNumberOfSprites {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	int num = 0;
	for (Layer *layer in [[[doc.levelArrayController selection] valueForKey:@"layers"] arrangedObjects]) {
		num += [layer.sprites count];
	}
	return num;
}

static NSString *SpriteDataPboardType = @"SpriteDataPboardType";

// For duplicating Expense entities
- (IBAction) copy:(id) sender
{
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	NSUInteger count = [doc.selectedSprites count];
	if (count == 0) return;

	NSMutableArray *copyObjectsArray = [NSMutableArray arrayWithCapacity:count];
//	NSMutableArray *copyStringsArray = [NSMutableArray arrayWithCapacity:count];
	
	for (Sprite *sprite in doc.selectedSprites)
	{
		[copyObjectsArray addObject:[sprite dictionaryRepresentation]];
		NSLog(@"copying sprite: %@", [sprite description]);
//		[copyStringsArray addObject:[sprite stringDescription]];
	}
		
	NSPasteboard *generalPasteboard = [NSPasteboard generalPasteboard];
	[generalPasteboard declareTypes:[NSArray arrayWithObjects:SpriteDataPboardType, NSStringPboardType, nil] owner:self];
	NSData *copyData = [NSKeyedArchiver archivedDataWithRootObject:copyObjectsArray];
	[generalPasteboard setData:copyData forType:SpriteDataPboardType];
//	[generalPasteboard setString:[copyStringsArray componentsJoinedByString:@"\n"] forType:NSStringPboardType];
}

- (IBAction) paste:(id) sender
{
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	
	NSPasteboard *generalPasteboard = [NSPasteboard generalPasteboard];
	NSData *data = [generalPasteboard dataForType:SpriteDataPboardType];
	if (data == nil) return;
	
	NSArray *pastedSpritesArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	NSManagedObjectContext *moc = [doc managedObjectContext];
//	NSArray *stringArray = [[generalPasteboard stringForType:NSStringPboardType] componentsSeparatedByString:@"\n"];
//	NSEntityDescription *cats = [NSEntityDescription entityForName:@"Category" inManagedObjectContext:moc];
//	NSString *predString = [NSString stringWithFormat:@"%@ LIKE %%@", @"name"];
	int i = 0;
	[doc.selectedSprites removeAllObjects];
	//selectionRect.size = NSMakeSize(0, 0);
	for (NSDictionary *spriteDictionary in pastedSpritesArray)
	{
		//create a new Expense entity
		Sprite *newSprite;
		newSprite = (Sprite *)[NSEntityDescription insertNewObjectForEntityForName:@"Sprite" inManagedObjectContext:moc];
		// Dump the values from the dictionary into the new entity
		[newSprite setValuesForKeysWithDictionary:spriteDictionary];
		newSprite.x = [NSNumber numberWithFloat:[newSprite.x floatValue]+20];
		newSprite.y = [NSNumber numberWithFloat:[newSprite.y floatValue]+20];		
		NSMutableArray *sprites = [selectedLayer valueForKey:@"sprites"];
		[sprites addObject:newSprite];
		[doc.selectedSprites addObject:newSprite];
		NSLog(@"pasted sprite: %@", [newSprite description]);		
/*		
		// create a fetch request to get the category whose title matches the one in the array at the current index
		NSFetchRequest *req = [[NSFetchRequest alloc] init];
		// set the entity
		[req setEntity:cats];
		// create the predicate
		NSPredicate *predicate = [NSPredicate predicateWithFormat:predString, [stringArray objectAtIndex:i]];
		// set the predicate
		[req setPredicate:predicate];
		// just in case
		NSError *error = nil;
		// execute the request
		NSArray *fetchResults = [moc executeFetchRequest:req error:&error];
		// acquire a pointer for the correct category
		Category *theCat = [fetchResults objectAtIndex:0];
		// get the expenses set from the category
		NSMutableSet *aSet = [theCat mutableSetValueForKey:@"expenses"];
		// now to add the new expense entity to the category
		[aSet addObject:newExpense];
*/ 
		i++;
	}
	[self setNeedsDisplay:YES];
}

- (void)setSelectedLayer:(Layer*)mngObj {
	if (selectedLayer==mngObj) return;
	[selectedLayer release];
	selectedLayer = [mngObj retain];
	[self setNeedsDisplay:YES];
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
    [self removeTrackingArea:trackingArea];
    [trackingArea release];	
	NSRect rect = self.frame;
	trackingArea = [[NSTrackingArea alloc] initWithRect:rect
												options: (NSTrackingMouseMoved | NSTrackingActiveInKeyWindow )
												  owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (IBAction)layersEdited:(id)sender {
	[self setNeedsDisplay:YES];
	NSArray *layers = [selectedLevel valueForKey:@"layers"];
	for (Layer *layer in layers) {
		BOOL val = [layer.visibleInEditor boolValue];
		NSLog(@"visibleInEditor: %d", val);
	}
}

/*
- (void)resetCursorRects
{
	if (spriteInteractionPending==YES) {
		[self addCursorRect:self.frame cursor:[NSCursor openHandCursor]];
	} else {
		[self addCursorRect:self.frame cursor:[NSCursor arrowCursor]];
	}
}
*/


- (void)deleteSprite:(id)sender {
	NSMutableArray *sprites = [selectedLayer valueForKey:@"sprites"];
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	[sprites removeObject:doc.selectedSprite];
	[selectedLayer setValue:sprites forKey:@"sprites"];
	doc.selectedSprite = nil;
	[self setNeedsDisplay:YES];	
}

- (Sprite*)spriteAtPosition:(NSPoint)aPoint
{
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
//	NSManagedObjectContext *moc = [doc managedObjectContext]; 

//	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"Sprite" inManagedObjectContext:moc]; 	
//	NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease]; 
//	[request setEntity:entityDescription];
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:
//							  @"(layer=%@) AND (x >= %@) AND (x+width <= %@) AND (y >= %@) AND (y+height <= %@)", 
//							  selectedLayer, 
//							  [NSNumber numberWithFloat:aPoint.x], 
//							  [NSNumber numberWithFloat:aPoint.x], 
//							  [NSNumber numberWithFloat:aPoint.y], 
//							  [NSNumber numberWithFloat:aPoint.y]]; 
//	[request setPredicate:predicate];
	
//	NSError *error; 
//	NSArray *array = [moc executeFetchRequest:request error:&error]; 
//	if (error || [array count] == 0) {
//		NSLog(@"Error getting sprite at position (%f, %f)"); //: %@", aPoint.x, aPoint.y, [error description]);
//		return nil;
//	}
//	return (Sprite*)[array objectAtIndex:0];
	
//	for (Layer *layer in [doc.layerArrayController arrangedObjects]) {
		if ([selectedLayer.visibleInEditor boolValue]==NO) return nil;
		NSMutableArray *sprites = [selectedLayer valueForKey:@"sprites"];
		Texture *sdef = nil;
		for (Sprite *s in sprites) {
			sdef = [[doc allTextures] objectForKey:s.key];
			if (NSPointInRect(aPoint, NSMakeRect(s.location.x, s.location.y, sdef.frame.size.width, sdef.frame.size.height))) return s;
		}
//	}
	return nil;
}

- (NSMutableArray*)spritesInRect:(NSRect)rect
{
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	if ([selectedLayer.visibleInEditor boolValue]==NO) return nil;
	NSMutableArray *sprites = [selectedLayer valueForKey:@"sprites"];
	NSMutableArray *result = [NSMutableArray arrayWithCapacity:[sprites count]];
	Texture *sdef = nil;
	for (Sprite *s in sprites) {
		sdef = [[doc allTextures] objectForKey:s.key];
		if (NSIntersectsRect(drawableSelectionRect, NSMakeRect(s.location.x, s.location.y, sdef.frame.size.width, sdef.frame.size.height))) {
			[result addObject:s];
		}
	}
	return result;
}

- (void)drawRect:(NSRect)dirtyRect {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];	
	NSArray *layers =  [doc.layerArrayController arrangedObjects];// [selectedLevel valueForKey:@"layers"];
//	CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];
	[NSBezierPath setDefaultLineWidth:0.5];
	if ([layers count]==0 && !selectedLayer) {
		[HEXCOLOR(0x66666666) set];		
		[NSBezierPath fillRect:dirtyRect];
		return;
	}	

	Level *level = [doc.levelArrayController selection];
	NSNumber *colorAsNumber = [level valueForKey:@"bgColor"];
	if ([colorAsNumber respondsToSelector:@selector(unsignedIntegerValue)]) {
		NSUInteger colorValue = [colorAsNumber unsignedIntegerValue];
		[HEXCOLOR(colorValue) set];
		[NSBezierPath fillRect:dirtyRect];
	}
	
	NSMutableDictionary *sdefs = [doc allTextures];
	
	if ([sdefs count]<1) return;
	for (Layer *layer in [layers reverseObjectEnumerator] ) {
		float alpha = [layer.opacity floatValue]/255.0f;
		if ([layer.visibleInEditor boolValue]==NO) continue;
		NSSet *sprites = layer.sprites;
		Texture *sdef = nil;
		NSRect sourceRect;
		//	NSImage *sourceImg = [Model sharedInstance].currentSpriteDefinition.img;
		for (Sprite *s in sprites) {
			if (!s.key) continue;			
			sdef = [sdefs objectForKey:s.key];
			sourceRect = NSMakeRect(s.location.x, s.location.y, sdef.frame.size.width, sdef.frame.size.height);
			float sAlpha = ([s.opacity floatValue]/255) * alpha;
			
			NSImage *tintedImage;
			if ([s.tintEnabled boolValue]) {
				tintedImage = [sdef.img imageTintedWithColor:[s tintColorAsColor]];
			} else if ([layer.tintEnabled boolValue]){
				tintedImage = [sdef.img imageTintedWithColor:[layer tintColorAsColor]];
			} else {
				tintedImage = sdef.img;
			}			  
			[tintedImage drawInRect:sourceRect fromRect:NSMakeRect(0, 0, sdef.img.size.width, sdef.img.size.height) operation:NSCompositeSourceOver fraction:sAlpha];
			
			if ([[[level valueForKey:@"Game"] valueForKey:@"showBoundsInEditor"] boolValue]) {
				if ([s.impact intValue]>0) {
					[[NSString stringWithFormat:@"+%d", [s.impact intValue]] 
									drawAtPoint:NSMakePoint(s.location.x, s.location.y + sdef.frame.size.height + 2)
								withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:6.0], NSFontNameAttribute, [NSColor greenColor], NSForegroundColorAttributeName, nil]];
				} else if ([s.impact intValue]<0) {
					[[NSString stringWithFormat:@"%d", [s.impact intValue]] 
									drawAtPoint:NSMakePoint(s.location.x, s.location.y + sdef.frame.size.height + 2)
								withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[NSFont systemFontOfSize:6.0], NSFontNameAttribute, [NSColor redColor], NSForegroundColorAttributeName, nil]];
				}
			}					
			
			if ([[[level valueForKey:@"Game"] valueForKey:@"showBoundsInEditor"] boolValue] || s==doc.selectedSprite) {
				if (s==doc.selectedSprite || [doc.selectedSprites containsObject:s]) {
					[[NSColor colorWithDeviceRed:52.0f/255.0f green:132.0f/255.0f blue:246.0f/255.0f alpha:alpha] set];
				} else {
					[[NSColor colorWithDeviceRed:1.0f green:0.0f blue:0.0f alpha:alpha] set];
				}
				[NSBezierPath strokeRect:sourceRect];
			}
			NSRect f = self.frame;
			if (f.size.width < s.location.x + sdef.frame.size.width) f.size.width += sdef.frame.size.width;
			if (f.size.height < s.location.y + sdef.frame.size.height) f.size.height += sdef.frame.size.height;
			self.frame = f;
		}
	}
	[self drawGrid];
	[self drawSelectionRect];
}

- (void)drawSelectionRect {
	if (selectionRect.size.width==0 || selectionRect.size.height==0) {
		[drawSelectionRectTimer invalidate];
		self.drawSelectionRectTimer = nil;
		return;
	}
	drawableSelectionRect = selectionRect;
    // Set the line dash pattern.
    CGFloat lineDash[2];
	
    lineDash[0] = 10.0;
    lineDash[1] = 10.0;

	NSBezierPath *thePath = [NSBezierPath bezierPath];
	[thePath setLineDash:lineDash count:2 phase:selectionRectPhase];
	[thePath setLineWidth:0.75];
	
	if (selectionRect.size.width == 0 || selectionRect.size.height == 0) return;
	[[NSColor colorWithDeviceRed:0.0f green:0.0f blue:0.0f alpha:0.85] set];
	
	if (selectionRect.size.width<0) {
		drawableSelectionRect.origin.x += selectionRect.size.width;
		drawableSelectionRect.size.width *= -1;
	}
	if (selectionRect.size.height<0) {
		drawableSelectionRect.origin.y += selectionRect.size.height;
		drawableSelectionRect.size.height *= -1;
	}
	
	//NSLog(@"rect:(%f, %f, %f, %f)", rectToDraw.origin.x, rectToDraw.origin.y, rectToDraw.size.width, rectToDraw.size.height);
	
	[thePath appendBezierPathWithRect:drawableSelectionRect];
	[thePath stroke];
	if (!drawSelectionRectTimer) {
		self.drawSelectionRectTimer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(invalidateSelectionRect:) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:self.drawSelectionRectTimer forMode:NSDefaultRunLoopMode];
	}
}

- (void)invalidateSelectionRect:(NSTimer*)timer {
	selectionRectPhase += 1;
	NSRect r1, r2, r3, r4;
	r1 = NSMakeRect(drawableSelectionRect.origin.x, drawableSelectionRect.origin.y-1, drawableSelectionRect.size.width, 2);
	r2 = NSMakeRect(drawableSelectionRect.origin.x+drawableSelectionRect.size.width-1, drawableSelectionRect.origin.y, 2, drawableSelectionRect.size.height);
	r3 = NSMakeRect(drawableSelectionRect.origin.x-1, drawableSelectionRect.origin.y, 2, drawableSelectionRect.size.height);
	r4 = NSMakeRect(drawableSelectionRect.origin.x, drawableSelectionRect.origin.y+drawableSelectionRect.size.height-1, drawableSelectionRect.size.width, 2);
	[self setNeedsDisplayInRect:r1];
	[self setNeedsDisplayInRect:r2];
	[self setNeedsDisplayInRect:r3];
	[self setNeedsDisplayInRect:r4];	
}

- (void)drawGrid {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];	
	//Level *level = [doc.levelArrayController selection];	
	NSSize grid = NSMakeSize([gridSize floatValue], [gridSize floatValue]);
	
	if ([doc.game.showGridInEditor boolValue]) {
		
		NSColor *color = HEXCOLOR(0x54a4f6aa);
		[color set];
		for (int row=0; row<self.frame.size.width/grid.width; row++) {
			NSPoint p1 = NSMakePoint(0, row*grid.width); 
			NSPoint p2 = NSMakePoint(self.frame.size.width, row*grid.width); 
			[NSBezierPath strokeLineFromPoint:p1 toPoint:p2];
		}
		
		for (int col=0; col<self.frame.size.width/grid.height; col++) {
			NSPoint p1 = NSMakePoint(col*grid.height, 0); 
			NSPoint p2 = NSMakePoint(col*grid.height, self.frame.size.height); 
			[NSBezierPath strokeLineFromPoint:p1 toPoint:p2];
		}
	}	
}

@end
