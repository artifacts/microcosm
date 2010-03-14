//
//  SpriteTypeTreeView.m
//  LevelEditor
//
//  Created by Michael Markowski on 29.01.10.
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

