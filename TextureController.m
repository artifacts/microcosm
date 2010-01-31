//
//  TextureController.m
//  LevelEditor
//
//  Created by Michael Markowski on 27.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import "TextureController.h"
#import "AFGameEditor.h"
#import "TextureAtlas.h"
#import "Model.h"

@implementation TextureController

@synthesize textureArrayController;
@synthesize textureAtlasArrayController;
@synthesize spriteTypeTabView;
@synthesize spriteTypeTreeController;
@synthesize treeView;
@synthesize rootTreeNode;

- (void)awakeFromNib {
	[imageBrowser setAllowsReordering:YES];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification
{
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	[textureArrayController removeObjects:[textureArrayController arrangedObjects]];
	id obj = [doc.textureAtlasArrayController selection];
	TextureAtlas *selectedSpriteSheet = [obj valueForKey:@"self"];
	if ([selectedSpriteSheet respondsToSelector:@selector(textures)]) {
		NSDictionary *textures = [selectedSpriteSheet textures];
		[textureArrayController addObjects:[textures allValues]];
	}
	[imageBrowser reloadData];
}

- (Texture*)textureForKey:(NSString*)aKey {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	Texture *t = [[doc allTextures] objectForKey:aKey];
	return t;
}

- (IBAction)openSpriteSheetAction:(id)sender {	
	// "Standard" open file panel
	NSArray *fileTypes = [NSArray arrayWithObjects:@"jpg", @"gif",
						  @"png",	@"psd", @"tga", nil];
	
	int i;
	// Create the File Open Panel class.
	NSOpenPanel* oPanel = [NSOpenPanel openPanel];
	
	[oPanel setCanChooseDirectories:NO];
	[oPanel setCanChooseFiles:YES];
	[oPanel setCanCreateDirectories:YES];
	[oPanel setAllowsMultipleSelection:NO];
	[oPanel setAlphaValue:0.95];
	[oPanel setTitle:@"Select spritesheet image"];
	
	if ( [oPanel runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton )
	{
		// Get an array containing the full filenames of all
		// files and directories selected.
		NSArray* files = [oPanel filenames];
		
		// Loop through all the files and process them.
		for( i = 0; i < [files count]; i++ )
		{
			NSString* fileName = [files objectAtIndex:i];
			NSImage *img = [[NSImage alloc] initWithContentsOfFile:fileName];
			
			NSManagedObject *selectedSpriteDef = [textureAtlasArrayController selection];
			[selectedSpriteDef setValue:img forKey:@"spriteSheetImage"];
		}
	}
}

- (IBAction)openCoordsAction:(id)sender {	
	// "Standard" open file panel
	NSArray *fileTypes = [NSArray arrayWithObjects:@"plist", nil];
	
	int i;
	// Create the File Open Panel class.
	NSOpenPanel* oPanel = [NSOpenPanel openPanel];
	
	[oPanel setCanChooseDirectories:NO];
	[oPanel setCanChooseFiles:YES];
	[oPanel setCanCreateDirectories:YES];
	[oPanel setAllowsMultipleSelection:NO];
	[oPanel setAlphaValue:0.95];
	[oPanel setTitle:@"Select coordinates (.plist) file"];
	
	if ( [oPanel runModalForDirectory:nil file:nil types:fileTypes] == NSOKButton )
	{
		NSArray* files = [oPanel filenames];		
		for( i = 0; i < [files count]; i++ )
		{
			NSString* fileName = [files objectAtIndex:i];
			NSManagedObject *selectedSpriteDef = [textureAtlasArrayController selection];
			NSDictionary *coords = [NSDictionary dictionaryWithContentsOfFile:fileName];
			[selectedSpriteDef setValue:coords forKey:@"coordinates"];
		}
	}
	[self tableViewSelectionDidChange:nil];
	[imageBrowser reloadData];
//	[textureAtlasArrayController setSelectionIndex:0];
//	[imageBrowser setNeedsDisplay:YES];
}

@end
