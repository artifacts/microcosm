//
//  AFGameEditor+LayerManagement.m
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "AFGameEditor+LayerManagement.h"
#import "CoreDataHelper.h"
#import "AFGameEditor.h"

@implementation AFGameEditor (LayerManagement)

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	[levelView setNeedsDisplay:YES];
}

- (BOOL)tableView:(NSTableView *)tv writeRowsWithIndexes:(NSIndexSet *)rowIndexes toPasteboard:(NSPasteboard*)pasteboard
{
	NSData *data = [NSKeyedArchiver archivedDataWithRootObject:rowIndexes];
	[pasteboard declareTypes:[NSArray arrayWithObject:LayerItemsDropType] owner:self];
	[pasteboard setData:data forType:LayerItemsDropType];
	return YES;
}

- (NSDragOperation)tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(NSInteger)row proposedDropOperation:(NSTableViewDropOperation)op
{
	if( [info draggingSource] == layerTableView )
	{
		if( op == NSTableViewDropOn )
			[tv setDropRow:row dropOperation:NSTableViewDropAbove];
		
		if(( [[[NSApplication sharedApplication] currentEvent] modifierFlags] & NSAlternateKeyMask ) )
			return NSDragOperationCopy;
		else
			return NSDragOperationMove;
	}
	else
	{
		return NSDragOperationNone;
	}
}

- (BOOL)tableView:(NSTableView *)aTableView acceptDrop:(id <NSDraggingInfo>)info
			  row:(NSInteger)row dropOperation:(NSTableViewDropOperation)operation
{
	CoreDataHelper *helper = [[[CoreDataHelper alloc] 
							   initWithManagedObjectContext:[self managedObjectContext] 
							   sortDescriptors:[self sortDescriptors]
							   entityName:@"Layer"] autorelease];
	
	NSPasteboard *pasteboard = [info draggingPasteboard];
	NSData *rowData = [pasteboard dataForType:LayerItemsDropType];
	NSIndexSet *rowIndexes = [NSKeyedUnarchiver unarchiveObjectWithData:rowData];
	
	NSArray *allItemsArray = [layerArrayController arrangedObjects];
	NSMutableArray *draggedItemsArray = [NSMutableArray arrayWithCapacity:[rowIndexes count]];
	
	NSUInteger currentItemIndex;
	NSRange range = NSMakeRange( 0, [rowIndexes lastIndex] + 1 );
	while([rowIndexes getIndexes:&currentItemIndex maxCount:1 inIndexRange:&range] > 0)
	{
		NSManagedObject *thisItem = [allItemsArray objectAtIndex:currentItemIndex];
		
		[draggedItemsArray addObject:thisItem];
	}
	
	if( [info draggingSourceOperationMask] & NSDragOperationMove )
	{
		int count;
		for( count = 0; count < [draggedItemsArray count]; count++ )
		{
			NSManagedObject *currentItemToMove = [draggedItemsArray objectAtIndex:count];
			[currentItemToMove setValue:[NSNumber numberWithInt:kTemporaryViewPosition] forKey:@"viewPosition"];
		}
		
		int tempRow;
		if( row == 0 )
			tempRow = -1;
		else
			tempRow = row;
		
		NSArray *startItemsArray = [helper entitiesWithViewPositionBetween:0 and:tempRow];
		NSArray *endItemsArray = [helper entitiesWithViewPositionGreaterThanOrEqualTo:row];
		
		int currentViewPosition;
		
		currentViewPosition = [helper renumberViewPositionsOfEntities:startItemsArray startingAt:0];
		
		currentViewPosition = [helper renumberViewPositionsOfEntities:draggedItemsArray startingAt:currentViewPosition];
		
		currentViewPosition = [helper renumberViewPositionsOfEntities:endItemsArray startingAt:currentViewPosition];
		
		return YES;
	}
	else if( [info draggingSourceOperationMask] & NSDragOperationCopy )
	{
		NSArray *copiedItemsArray = [self copyItems:draggedItemsArray];
		
		int tempRow;
		if( row == 0 )
			tempRow = -1;
		else
			tempRow = row;
		
		NSArray *startItemsArray = [helper entitiesWithViewPositionBetween:0 and:tempRow];
		NSArray *endItemsArray = [helper entitiesWithViewPositionGreaterThanOrEqualTo:row];
		
		int currentViewPosition;
		
		currentViewPosition = [helper renumberViewPositionsOfEntities:startItemsArray startingAt:0];
		
		currentViewPosition = [helper renumberViewPositionsOfEntities:copiedItemsArray startingAt:currentViewPosition];
		
		currentViewPosition = [helper renumberViewPositionsOfEntities:endItemsArray startingAt:currentViewPosition];		
		
		return YES;
	}
	
	return NO;
}

- (NSArray *)copyItems:(NSArray *)itemsToCopyArray
{
	NSMutableArray *arrayOfCopiedItems = [NSMutableArray arrayWithCapacity:[itemsToCopyArray count]];
	
	int count;
	for( count = 0; count < [itemsToCopyArray count]; count++ )
	{
		NSManagedObject *itemToCopy = [itemsToCopyArray objectAtIndex:count];
		NSManagedObject *copiedItem = [NSEntityDescription insertNewObjectForEntityForName:@"Layer" inManagedObjectContext:[self managedObjectContext]];
		
		[copiedItem setValue:[itemToCopy valueForKey:@"name"] forKey:@"name"];
		[copiedItem setValue:[itemToCopy valueForKey:@"visibleInEditor"] forKey:@"visibleInEditor"];
		[copiedItem setValue:[itemToCopy valueForKey:@"visibleInScenery"] forKey:@"visibleInScenery"];
		[copiedItem setValue:[itemToCopy valueForKey:@"level"] forKey:@"level"];
		[copiedItem setValue:[itemToCopy valueForKey:@"sprites"] forKey:@"sprites"];
		[copiedItem setValue:[itemToCopy valueForKey:@"tintColor"] forKey:@"tintColor"];
		[copiedItem setValue:[itemToCopy valueForKey:@"tintEnabled"] forKey:@"tintEnabled"];
		[copiedItem setValue:[NSNumber numberWithInt:kTemporaryViewPosition] forKey:@"viewPosition"];
		
		[arrayOfCopiedItems addObject:copiedItem];
	}
	
	return arrayOfCopiedItems;
}

@end
