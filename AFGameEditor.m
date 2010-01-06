//
//  MyDocument.m
//  LevelEditor
//
//  Created by Michael Markowski on 20.11.09.
//  Copyright Artifacts 2009 . All rights reserved.
//

#import "AFGameEditor.h"
#import "Model.h"
#import "TextureAtlas.h"
#import "CoreDataHelper.h"
#import "Layer.h"
#import "AFGameEditor+LayerManagement.h"
#import "NSColor+Hex.h"

@implementation AFGameEditor

@synthesize levelArrayController;
@synthesize layerArrayController;
@synthesize textureAtlasArrayController;
@synthesize volatileTextures;
@synthesize selectedTexture;
@synthesize infoButton;
@synthesize selectedSprite;
@synthesize selectedSprites;
@synthesize infoHUD;
@synthesize volatileTextureToAtlasNameMap;
@synthesize layerTableView;
@synthesize showGridCheckbox;
@synthesize game;

- (id)init 
{
    self = [super init];
    if (self != nil) {
    }
    return self;
}

- (id)initWithType:(NSString *)typeName error:(NSError **)outError {
	if (self = [super initWithType:typeName error:outError]) {
		self.game = [NSEntityDescription insertNewObjectForEntityForName:@"Game" 
												  inManagedObjectContext:[self managedObjectContext]];		
		[game setValue:[NSNumber numberWithBool:YES] forKey:@"showGridInEditor"];		
		Level *level = [NSEntityDescription insertNewObjectForEntityForName:@"Level" 
													 inManagedObjectContext:[self managedObjectContext]];		
		level.name = @"Level 1";
		level.viewPosition = [NSNumber numberWithInt:1];
		level.game = game;
		level.bgColor = [[NSColor whiteColor] asNumber];
		
		Layer *layer = [NSEntityDescription insertNewObjectForEntityForName:@"Layer" 
													 inManagedObjectContext:[self managedObjectContext]];
		layer.name = @"Background";
		layer.viewPosition = [NSNumber numberWithInt:1];
		layer.visibleInEditor = [NSNumber numberWithBool:YES];
		layer.visibleInScenery = [NSNumber numberWithBool:YES];
		layer.level = level;
		
		TextureAtlas *textureAtlas = [NSEntityDescription insertNewObjectForEntityForName:@"TextureAtlas" 
																   inManagedObjectContext:[self managedObjectContext]];		
		textureAtlas.name = @"New SpriteSheet";
		textureAtlas.game = game;
		
		NSLog(@"created new game: %@", [game description]);		
	}
	return self;
}

- (id)initWithContentsOfURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	AFGameEditor *doc = (AFGameEditor*)[super initWithContentsOfURL:absoluteURL ofType:typeName error:outError];

	NSError *fetchError = nil;
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:[self managedObjectContext]];	

	NSArray *arrayOfItems;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityDesc];
	arrayOfItems = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&fetchError];
	[fetchRequest release];
	if ([arrayOfItems count] > 0) {
		self.game = [arrayOfItems objectAtIndex:0];
		NSLog(@"opened document: %@", [absoluteURL description]);
		return doc;
	}
	return nil;	
}



/*
- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url 
										   ofType:(NSString *)fileType 
							   modelConfiguration:(NSString *)configuration 
									 storeOptions:(NSDictionary *)storeOptions 
											error:(NSError **)error 
{
	NSError *fetchError = nil;
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Game" inManagedObjectContext:[self managedObjectContext]];
	
	NSArray *arrayOfItems;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityDesc];
	arrayOfItems = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&fetchError];
	[fetchRequest release];
	if ([arrayOfItems count] > 0) {
		self.game = [arrayOfItems objectAtIndex:0];
		return YES;
	}
	return YES;
}
*/

- (void)awakeFromNib {
	[drawer openOnEdge:NSMinXEdge];
	self.volatileTextureToAtlasNameMap = [NSMutableDictionary dictionary];
	[layerTableView setDataSource:self];
	[layerTableView registerForDraggedTypes:[NSArray arrayWithObjects:LayerItemsDropType, nil]];
	[levelView setNeedsDisplay:YES];
	[[NSColorPanel sharedColorPanel] setShowsAlpha:YES];
	self.selectedSprites = [NSMutableArray array];
}

- (NSString *)windowNibName 
{
    return @"GameEditor";
}

- (IBAction)toggleDrawer:(id)sender 
{ 
    if([sender state] == 1) 
    { 
		[drawer openOnEdge:NSMinXEdge];
    } 
    else
    { 
        [drawer close]; 
    } 
} 

- (IBAction)toggleSpriteInfo:(id)sender {
	if ([infoHUD isVisible]) {
		[infoHUD orderOut:nil];
	} else {
		[infoHUD makeKeyAndOrderFront:nil];
	}
}



-(NSMutableDictionary*)allTextures
{		
	if ([volatileTextures count]==0) {
		self.volatileTextures = [NSMutableDictionary dictionary];

		// fetch all texture atlases from context
		NSManagedObjectContext *moc = [self managedObjectContext]; 		
		NSEntityDescription *entityDescription = [NSEntityDescription entityForName:@"TextureAtlas" inManagedObjectContext:moc]; 	
		NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease]; 
		[request setEntity:entityDescription];
		NSError *error; 
		NSArray *textureAtlases = [moc executeFetchRequest:request error:&error]; 
		if (textureAtlases == nil) {
			NSLog(@"Error performing fetch on fetchedResultsController: %@", [error localizedDescription]);
		}
		
		for (TextureAtlas *textureAtlas in textureAtlases) {
			NSDictionary *textures = [textureAtlas textures];
			[volatileTextures addEntriesFromDictionary:textures];
		}
	}
	return volatileTextures;
}

- (NSDictionary*)texturesForAtlasNamed:(NSString*)name {
	TextureAtlas *atlas = [volatileTextureToAtlasNameMap objectForKey:name];
	NSDictionary *textures = [atlas textures];
	return textures;
}

- (void)invalidateTextures {
	[volatileTextures removeAllObjects];
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
    // user interface preparation code
	
	//	NSManagedObject *selectedLevel = [[levelArrayController selectedObjects] objectAtIndex:0];
	//	[[Model sharedInstance] bind:@"currentLevel" toObject:levelArrayController withKeyPath:@"selection.self" options:nil];
	[textureAtlasView bind:@"coords" toObject:textureAtlasArrayController withKeyPath:@"selection.coordinates" options:nil];	
	[textureAtlasView bind:@"image" toObject:textureAtlasArrayController withKeyPath:@"selection.spriteSheetImage" options:nil];
	
	[levelView bind:@"selectedLayer" toObject:layerArrayController withKeyPath:@"selection.self" options:nil];
	[levelView bind:@"selectedLevel" toObject:levelArrayController withKeyPath:@"selection.self" options:nil];
	[textureAtlasView bind:@"coords" toObject:textureAtlasArrayController withKeyPath:@"selection.coordinates" options:nil];	
	
	//	[levelView bind:@"enabled" toObject:layerArrayController withKeyPath:@"selection.self" options:options];	
	
	[textureAtlasView bind:@"selectedTextureAtlas" toObject:textureAtlasArrayController withKeyPath:@"selection.self" options:nil];
	
	//	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSValueTransformer valueTransformerForName:NSIsNotNilTransformerName] forKey:NSIsNotNilTransformerName];
	//	[infoButton bind:@"enabled" toObject:levelView withKeyPath:@"selectedSprite" options:options];
	[levelView setNeedsDisplay:YES];
}

- (IBAction)addNewLevel:(id)sender
{
	CoreDataHelper *helper = [[[CoreDataHelper alloc] 
							   initWithManagedObjectContext:[self managedObjectContext] 
							   sortDescriptors:[self sortDescriptors]
							   entityName:@"Level"] autorelease];
	Level *newLevel = [NSEntityDescription insertNewObjectForEntityForName:@"Level" inManagedObjectContext:[self managedObjectContext]];
	
	newLevel.name = @"New Level";
	newLevel.viewPosition = [NSNumber numberWithInt:kStartViewPosition];
//	NSManagedObject *level = [levelArrayController selection];	
	newLevel.game =  game; // [level valueForKey:@"self"]; // get actual object from proxy object
	
	
	[helper renumberViewPositions];
}

- (IBAction)removeSelectedLevels:(id)sender
{
	CoreDataHelper *helper = [[[CoreDataHelper alloc] 
							   initWithManagedObjectContext:[self managedObjectContext] 
							   sortDescriptors:[self sortDescriptors]
							   entityName:@"Level"] autorelease];
	NSArray *selectedLevels = [levelArrayController selectedObjects];	
	int count;
	for( count = 0; count < [selectedLevels count]; count ++ )
	{
		NSManagedObject *currentObject = [selectedLevels objectAtIndex:count];
		[[self managedObjectContext] deleteObject:currentObject];
	}
	[helper renumberViewPositions];	
}

- (IBAction)addNewLayer:(id)sender
{
	CoreDataHelper *helper = [[[CoreDataHelper alloc] 
							   initWithManagedObjectContext:[self managedObjectContext] 
							   sortDescriptors:[self sortDescriptors]
							   entityName:@"Layer"] autorelease];
	Layer *newLayer = [NSEntityDescription insertNewObjectForEntityForName:@"Layer" inManagedObjectContext:[self managedObjectContext]];
	
	newLayer.name = @"New Layer";
	newLayer.viewPosition = [NSNumber numberWithInt:kStartViewPosition];
	NSManagedObject *level = [levelArrayController selection];
	
	newLayer.level = [level valueForKey:@"self"]; // get actual object from proxy object
	
	
	[helper renumberViewPositions];
}

- (IBAction)removeSelectedLayers:(id)sender
{
	CoreDataHelper *helper = [[[CoreDataHelper alloc] 
							   initWithManagedObjectContext:[self managedObjectContext] 
							   sortDescriptors:[self sortDescriptors]
							   entityName:@"Layer"] autorelease];
	NSArray *selectedLayers = [layerArrayController selectedObjects];	
	int count;
	for( count = 0; count < [selectedLayers count]; count ++ )
	{
		NSManagedObject *currentObject = [selectedLayers objectAtIndex:count];
		[[self managedObjectContext] deleteObject:currentObject];
	}
	[helper renumberViewPositions];	
}

- (NSArray *)sortDescriptors {
	if( _sortDescriptors == nil ) {
		_sortDescriptors = [NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"viewPosition" ascending:YES]];
	}
	return _sortDescriptors;
}


- (int)renumberViewPositionsOfItems:(NSArray *)array startingAt:(int)value
{
	int currentViewPosition = value;
	
	int count = 0;
	
	if( array && ([array count] > 0) )
	{
		for( count = 0; count < [array count]; count++ )
		{
			NSManagedObject *currentObject = [array objectAtIndex:count];
			[currentObject setValue:[NSNumber numberWithInt:currentViewPosition] forKey:@"viewPosition"];
			currentViewPosition++;
		}
	}
	
	return currentViewPosition;
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
}


@end
