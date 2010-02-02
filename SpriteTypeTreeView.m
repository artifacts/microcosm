//
//  SpriteTypeTreeView.m
//  LevelEditor
//
//  Created by Michael Markowski on 29.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import "SpriteTypeTreeView.h"
#import "Model.h"
#import "TextureController.h"
#import "SpriteType.h"

@implementation SpriteTypeTreeView

@synthesize isDragging;

- (id)initWithCoder:(NSCoder *)coder
{
    /*------------------------------------------------------
	 Init method called for Interface Builder objects
	 --------------------------------------------------------*/
    if(self=[super initWithCoder:coder]){
        //register for all the image types we can display
        [self registerForDraggedTypes:[NSArray arrayWithObject:TextureTypePboardType]];
    }
    return self;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	NSLog(@"draggingEntered");
	isDragging = YES;
	return NSDragOperationLink;
}

- (void)draggingExited:(id <NSDraggingInfo>)sender {
	isDragging = NO;
	NSLog(@"draggingExited");
}

- (void)draggingEnded:(id <NSDraggingInfo>)sender {
	isDragging = NO;
	NSLog(@"draggingEnded");
}

/*
- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [sender draggingSourceOperationMask];
    pboard = [sender draggingPasteboard];
	
    if ( [[pboard types] containsObject:TextureTypePboardType] ) {
		NSData *data = [pboard dataForType:TextureTypePboardType];		
		NSArray *textureArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		TextureController *controller = self.delegate;
		if (![controller.spriteTypeTreeController selection]) return NO;
		SpriteType *spriteType = [[controller.spriteTypeTreeController selection] valueForKey:@"self"];
		NSArray *keys = spriteType.keys;
		NSMutableArray *newKeys = [NSMutableArray arrayWithArray:keys];
		for (Texture *texture in textureArray) {
			[newKeys addObject:texture.key];
		}
		spriteType.keys = newKeys;
		NSLog(@"spriteType %@'s keys: %@", spriteType.name, [spriteType.keys description]);
		[self reloadData];
    }

    return YES;
}
*/

-(void)keyDown:(NSEvent *)theEvent
{
	NSLog(@"SpriteTypeTreeView: keyDown: %c", [[theEvent characters] characterAtIndex:0]);
	
	unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
	
	if (key == NSDeleteCharacter || key == NSBackspaceCharacter)
	{
		NSLog(@"NSDeleteCharacter or NSBackspaceCharacter pressed");
//		NSLog(@"indexSet: %@", [indexSet description]);
		[[NSNotificationCenter defaultCenter] postNotificationName:kDeleteSelectedTexturesNotification object:self];
		return;
	}
    
	[super keyDown:theEvent];
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    /*------------------------------------------------------
	 method to determine if we can accept the drop
	 --------------------------------------------------------*/
/*    highlight=NO;//finished with the drag so remove any highlighting
    [self setNeedsDisplay: YES];
    //check to see if we can accept the data
    return [NSImage canInitWithPasteboard: [sender draggingPasteboard]];
*/	return YES;
} 

@end

