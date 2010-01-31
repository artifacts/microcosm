//
//  TextureController#.m
//  LevelEditor
//
//  Created by Michael Markowski on 29.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import "TextureController+Tree.h"
#import "SpriteType.h"
#import "AFGameEditor.h"
#import "Model.h"
#import "ImageAndTextCell.h"

@implementation TextureController (Tree)

- (void)invalidateTree {
	rootTreeNode = nil;
	[treeView reloadData];
}

- (NSTreeNode*)rootTreeNode {
	if (rootTreeNode==nil) {
		rootTreeNode = [[NSTreeNode alloc] initWithRepresentedObject:@"root"];
		for (SpriteType *st in [spriteTypeTreeController content]) {
//			NSLog(@"adding st %@", [st description]);
			NSTreeNode *spriteTypeTreeNode = [NSTreeNode treeNodeWithRepresentedObject:st];
			NSMutableArray *keyTreeNodes = [spriteTypeTreeNode mutableChildNodes];
			for (NSString *key in st.keys) {
				NSTreeNode *treeNodeKey = [NSTreeNode treeNodeWithRepresentedObject:key];
				[keyTreeNodes addObject:treeNodeKey];
			}
			[[rootTreeNode mutableChildNodes] addObject:spriteTypeTreeNode];
		}		
	}
	return rootTreeNode;
}

// The NSOutlineView uses 'nil' to indicate the root item. We return our root tree node for that case.
- (NSArray *)childrenForItem:(id)item {
    if (item == nil) {
        return [self.rootTreeNode childNodes];
    } else {
        return [item childNodes];
    }
}

//- (NSIndexSet *)outlineView:(NSOutlineView *)outlineView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes
- (BOOL)browser:(NSBrowser *)sender selectRow:(NSInteger)row inColumn:(NSInteger)column { 
	NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:row];
	[spriteTypeTreeController setSelectionIndexPath:indexPath];
	return YES;
}

- (IBAction)addSpriteTypeAction:(id)sender {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	NSManagedObjectContext *moc = [doc managedObjectContext]; 
	SpriteType *spriteType = [NSEntityDescription insertNewObjectForEntityForName:@"SpriteType" inManagedObjectContext:moc];	
	[spriteTypeTreeController addObject:spriteType];
	[self invalidateTree];
}

- (IBAction)removeSpriteTypeAction:(id)obj {
	SpriteType *spriteType = [spriteTypeTreeController selection];
	[spriteTypeTreeController remove:spriteType];
	NSIndexPath *indexPath = [spriteTypeTreeController selectionIndexPath];
	[treeView selectRow:[indexPath indexAtPosition:0] byExtendingSelection:NO];
	[self invalidateTree];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item {
	id obj = [item representedObject];
	if ([obj isKindOfClass:[SpriteType class]]) {
		return [[obj keys] count]>0;
	} else {
		return NO;
	}	
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	id obj = [item representedObject];
	if ([obj isKindOfClass:[SpriteType class]]) {
		return [[obj keys] count]>0;
	} else {
		return NO;
	}

}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    return [children count];
}
/*
- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	NSInteger num = 0;
	if (item==nil) {
		
		NSArray *array = [spriteTypeTreeController arrangedObjects];
		num = [array count];
	} else {
		NSTreeNode *tn = item;
		num = [[tn childNodes] count];
	}
	NSLog(@"numberOfChildrenOfItem %@: %d", [item description], num);
	return num;*/
	/*
	id obj = [item representedObject];
	if ([obj isKindOfClass:[SpriteType class]]) {
		return [[obj keys] count];
	} else {
		return 0;
	}
 */
//}

/*
- (NSArray *)childrenForItem:(id)item {
	id obj = [item representedObject];
	NSMutableArray *nodes = [NSMutableArray array];
    if (item == nil) {
    } else {
		for (NSString *s in [obj keys]) {
			NSTreeNode *tn = [NSTreeNode treeNodeWithRepresentedObject:s];
			[nodes addObject:tn];
		}
    }
	NSLog(@"childrenForItem %@: %@", [item description], [nodes description]);
	return nodes;
}
*/
// Required methods. 
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item {
    // 'item' may potentially be nil for the root item.
    NSArray *children = [self childrenForItem:item];
    // This will return an NSTreeNode with our model object as the representedObject
	
    return [children objectAtIndex:index];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
//	NSLog(@"objectValueForTableColumn: %@ byItem: %@", [tableColumn description], [item description]);
    id objectValue = nil;
    // The return value from this method is used to configure the state of the items cell via setObjectValue:
	id obj = [item representedObject];
    if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:@"Name"]) {
		if ([obj isKindOfClass:[SpriteType class]]) {
			objectValue = [obj name];
		} else {
			objectValue = nil;
		}			
    } else if ([[tableColumn identifier] isEqualToString:@"Key"]) {
		if ([obj isKindOfClass:[NSString class]]) {
			objectValue = obj;
		}			
    } else if ([[tableColumn identifier] isEqualToString:@"Image"]) {
		if ([obj isKindOfClass:[NSString class]]) {
			Texture *texture = [self textureForKey:obj];
			objectValue = texture.img;
		}			
	}
	//	NSTreeNode *treeNode = [NSTreeNode treeNodeWithRepresentedObject:objectValue];
    return objectValue;
}

// Optional method: needed to allow editing.
- (void)outlineView:(NSOutlineView *)ov setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn byItem:(id)item  {
	SpriteType *s = [item representedObject];
    if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:@"Name"]) {
        s.name = object;
	}
}

//- (BOOL)browser:(NSBrowser *)browser writeRowsWithIndexes:(NSIndexSet *)rowIndexes inColumn:(NSInteger)column toPasteboard:(NSPasteboard *)pasteboard {
//	return YES;
//}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex {
//	NSLog(@"outlineView:validateDrop:proposedItem:%@ proposedChildIndex:%ld", item, (long)childIndex);
	if (!item) return NSDragOperationNone;
    return NSDragOperationLink;
}

- (BOOL)outlineView:(NSOutlineView *)ov acceptDrop:(id <NSDraggingInfo>)info item:(id)item childIndex:(NSInteger)childIndex {

//    NSLog(@"acceptDrop: %d", childIndex);
	
    NSPasteboard *pboard;
    NSDragOperation sourceDragMask;
	
    sourceDragMask = [info draggingSourceOperationMask];
    pboard = [info draggingPasteboard];
	
    if ( [[pboard types] containsObject:TextureTypePboardType] ) {
		NSData *data = [pboard dataForType:TextureTypePboardType];		
		NSArray *textureArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
		if (!item) return NO;
		SpriteType *spriteType = [item representedObject];
		NSArray *keys = spriteType.keys;
		NSMutableArray *newKeys = [NSMutableArray arrayWithArray:keys];
		for (Texture *texture in textureArray) {
			if (![newKeys containsObject:texture.key]) {
				[newKeys addObject:texture.key];
			}
		}
		spriteType.keys = newKeys;
//		NSLog(@"spriteType %@'s keys: %@", spriteType.name, [spriteType.keys description]);
		[self invalidateTree];
    }
	
    return YES;
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
	CGFloat height;
	id obj = [item representedObject];
	if ([obj isKindOfClass:[NSString class]]) {
		height = 64;
	} else {
		height = 20
		;
	}
	return height;
}

/*
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {    
	id obj = [item representedObject];
	ImageAndTextCell *imageAndTextCell = (ImageAndTextCell *)cell;
	[imageAndTextCell setImage:nil];
    if ((tableColumn == nil) || [[tableColumn identifier] isEqualToString:@"Image"]) {
		if ([obj isKindOfClass:[NSString class]]) {			
			Texture *texture = [self textureForKey:obj];
			[imageAndTextCell setImage:[self imageThumbnailFromImage:texture.img]];			
		}
    } else if ([[tableColumn identifier] isEqualToString:@"Image"]) {
	}
}*/

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
	NSTreeNode *treeNode = item;
	id obj = [item representedObject];
	if ([obj isKindOfClass:[SpriteType class]]) {
		NSIndexPath *indexPath = [treeNode indexPath];
		[spriteTypeTreeController setSelectionIndexPath:indexPath];
	} else {
		[spriteTypeTreeController setSelectionIndexPath:nil];
	}
	
	return YES;
}

- (IBAction)outlineViewAction:(id)sender {
}

- (NSImage*)imageThumbnailFromImage:(NSImage*)sourceImage {
	if (!sourceImage) return nil;
	float resizeHeight = 56.0;
	float aspect = sourceImage.size.width / sourceImage.size.height;
	float resizeWidth = resizeHeight * aspect;
	
	NSImage *resizedImage = [[NSImage alloc] initWithSize: NSMakeSize(resizeWidth, resizeHeight)];
	
	NSSize originalSize = [sourceImage size];
	[resizedImage lockFocus];
	[sourceImage drawInRect: NSMakeRect(0, 0, resizeWidth, resizeHeight) fromRect: NSMakeRect(0, 0, originalSize.width, originalSize.height) operation: NSCompositeSourceOver fraction: 1.0];
	[resizedImage unlockFocus];
	
	return resizedImage;	
}

@end
