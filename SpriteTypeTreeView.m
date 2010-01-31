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
/*
- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	NSLog(@"draggingEntered");
	return NSDragOperationLink;
}

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

