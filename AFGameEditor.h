//
//  MyDocument.h
//  LevelEditor
//
//  Created by Michael Markowski on 20.11.09.
//  Copyright Artifacts 2009 . All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "TextureAtlasView.h"
#import "LevelView.h"
#import "Game.h"

#define LayerItemsDropType @"LayerItemsDropType"

@interface AFGameEditor : NSPersistentDocument {
	IBOutlet TextureAtlasView *textureAtlasView;
	IBOutlet NSScrollView *spriteSheetScrollView;
	IBOutlet NSArrayController *levelArrayController;
	IBOutlet NSArrayController *layerArrayController;
	IBOutlet NSArrayController *textureAtlasArrayController;
	IBOutlet NSDrawer *drawer;
	IBOutlet LevelView *levelView;
	Texture *selectedTexture;
	IBOutlet NSButton *infoButton;
	IBOutlet Sprite *selectedSprite;
	NSMutableArray *selectedSprites;
	IBOutlet NSPanel *infoHUD;
	NSArray *_sortDescriptors;
	IBOutlet NSTableView *layerTableView;
	IBOutlet NSButton *showGridCheckbox;
	Game *game;
	
	NSMutableDictionary *volatileTextures;
	NSMutableDictionary *volatileTextureToAtlasNameMap;
}

@property (nonatomic, retain) IBOutlet NSArrayController *levelArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *layerArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *textureAtlasArrayController;
@property (nonatomic, retain) Texture *selectedTexture;
@property (nonatomic, retain) IBOutlet NSButton *infoButton;
@property (nonatomic, retain) IBOutlet Sprite *selectedSprite;
@property (nonatomic, retain) NSMutableArray *selectedSprites;
@property (nonatomic, retain) IBOutlet NSPanel *infoHUD;
@property (nonatomic, retain) IBOutlet NSTableView *layerTableView;
@property (nonatomic, retain) IBOutlet NSButton *showGridCheckbox;
@property (nonatomic, retain) Game *game;

@property (nonatomic, retain) NSMutableDictionary *volatileTextures;
@property (nonatomic, retain) NSMutableDictionary *volatileTextureToAtlasNameMap;

- (IBAction)openSpriteSheetAction:(id)sender;
- (IBAction)openCoordsAction:(id)sender;
- (IBAction)toggleDrawer:(id)sender;
- (IBAction)toggleSpriteInfo:(id)sender;
- (NSMutableDictionary*)allTextures;
- (void)invalidateTextures;
- (IBAction)addNewLayer:(id)sender;
- (IBAction)addNewLevel:(id)sender;
- (IBAction)removeSelectedLayers:(id)sender;
- (IBAction)removeSelectedLevels:(id)sender;
- (NSArray *)sortDescriptors;

@end
