//
//  TextureImageBrowser.m
//  LevelEditor
//
//  Created by Michael Markowski on 27.01.10.
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

#import "TextureController+Browser.h"
//#import "IKImageBrowserView.h"
#import "Texture.h"
#import "Model.h"

/* Our datasource object : represents one item in the browser */
@interface TextureImageItem : NSObject { // <IKImageBrowserItem> {
	NSImage *img;
	NSString *subtitle;
}
@property (nonatomic, retain) NSImage *img;
@property (nonatomic, retain) NSString *subtitle;

@end

@implementation TextureImageItem

@synthesize img;
@synthesize subtitle;

- (void) dealloc {
    [img release];
	[subtitle release];
    [super dealloc];
}

- (NSString *)imageRepresentationType {
	return IKImageBrowserNSImageRepresentationType;
}

- (id)imageRepresentation {
	return img;
}

- (NSString*)imageUID {
	return [NSString stringWithFormat:@"%d", [img hash]];
}

- (BOOL)isSelectable {
	return YES;
}

- (NSString*)imageSubtitle {
	return subtitle;
}

@end

@implementation TextureController (Browser)

- (IBAction) zoomSliderDidChange:(id)sender
{
    [imageBrowser setZoomValue:[sender floatValue]];
	[imageBrowser setNeedsDisplay:YES];
}

- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) view
{
	int count = [[textureArrayController arrangedObjects] count];
    return count;
}

- (id) imageBrowser:(IKImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index; {
    NSImage *img = [[[textureArrayController arrangedObjects] objectAtIndex:index] valueForKey:@"img"];
    NSString *key = [[[textureArrayController arrangedObjects] objectAtIndex:index] valueForKey:@"key"];
	if (img) {
		TextureImageItem *ti = [TextureImageItem new];
		ti.img = img;
		ti.subtitle = key;
		return ti;
	}
	return nil;
}

- (NSUInteger) imageBrowser:(IKImageBrowserView *) aBrowser writeItemsAtIndexes:(NSIndexSet *) itemIndexes toPasteboard: (NSPasteboard *)pasteboard 
{
	NSInteger index;
	
	// tell the pasteboard what to expect - required!
	[pasteboard declareTypes:[NSArray arrayWithObject:TextureTypePboardType] owner:nil];	// amended 11-04-09 
	
	NSMutableArray *copyObjectsArray = [NSMutableArray arrayWithCapacity:[itemIndexes count]];
	
	for (index = [itemIndexes lastIndex]; index != NSNotFound; index = [itemIndexes indexLessThanIndex:index]) 
	{
		Texture *texture = [[textureArrayController content] objectAtIndex:index]; 
		[copyObjectsArray addObject:texture];
	}
	NSData *copyData = [NSKeyedArchiver archivedDataWithRootObject:copyObjectsArray];
	[pasteboard setData:copyData forType:TextureTypePboardType]; 
	
	return [copyObjectsArray count];
}

#pragma mark -
#pragma mark  drag'n drop

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
	NSLog(@"draggingEntered");
	
	return [self draggingUpdated:sender];
}


- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
	if ([sender draggingSource] == imageBrowser) {
		NSLog(@"foo");
	} else {
		NSLog(@"bar");
	}
    return NSDragOperationLink;
}


- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender
{
	/*    [self willChangeValueForKey: @"totalNumberOfItems"];
	 NSData *data = nil;
	 NSString *errorDescription;
	 
	 // if we are dragging from the browser itself, ignore it
	 if ([sender draggingSource] == imageBrowser) 
	 return NO;
	 
	 NSPasteboard *pasteboard = [sender draggingPasteboard];
	 
	 if ([[pasteboard types] containsObject:NSFilenamesPboardType]) 
	 data = [pasteboard dataForType:NSFilenamesPboardType];
	 
	 if(data){
	 NSArray *filenames = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:kCFPropertyListImmutable format:nil errorDescription:&errorDescription];		
	 
	 int i, n;
	 n = [filenames count];
	 for(i=0; i<n; i++){
	 MyImageObject *item = [[MyImageObject alloc] init];
	 [item setPath:[filenames objectAtIndex:i]];	
	 [images insertObject:item atIndex:[imageBrowser indexAtLocationOfDroppedItem]];
	 [item release];
	 }
	 
	 [imageBrowser reloadData];
	 }
	 
	 [self didChangeValueForKey: @"totalNumberOfItems"];
	 */
	NSLog(@"performDragOperation");
	
	return YES;
}


#pragma mark -
#pragma mark optional datasource methods : reordering / removing

- (void) imageBrowser:(IKImageBrowserView *) aBrowser removeItemsAtIndexes: (NSIndexSet *) indexes
{
}

- (BOOL) imageBrowser:(IKImageBrowserView *) aBrowser moveItemsAtIndexes: (NSIndexSet *)indexes toIndex:(NSUInteger)destinationIndex
{	
	return YES;
}


@end
