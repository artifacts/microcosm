//
//  MyDocument.h
//  LevelEditor
//
//  Created by Michael Markowski on 20.11.09.
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


#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "TextureAtlasView.h"
#import "LevelView.h"
#import "Game.h"

#define LayerItemsDropType @"LayerItemsDropType"

enum {
	kEditModeMoveAndDrag,
	kEditModeSelect,
	kEditModeDraw,
};

@interface AFGameEditor : NSPersistentDocument {
	IBOutlet TextureAtlasView *textureAtlasView;
	IBOutlet NSScrollView *spriteSheetScrollView;
	IBOutlet NSArrayController *levelArrayController;
	IBOutlet NSArrayController *layerArrayController;
	IBOutlet NSArrayController *textureAtlasArrayController;
	IBOutlet NSArrayController *spriteArrayController;
	IBOutlet NSDrawer *drawer;
	IBOutlet LevelView *levelView;
	Texture *selectedTexture;
	IBOutlet NSButton *infoButton;
	NSArrayController *selectedSprites;
	IBOutlet NSPanel *infoHUD;
	NSArray *_sortDescriptors;
	IBOutlet NSTableView *layerTableView;
	IBOutlet NSButton *showGridCheckbox;
	Game *game;
	int editMode;
	NSMutableDictionary *volatileTextures;
	NSMutableDictionary *volatileTextureToAtlasNameMap;
}

@property (nonatomic, retain) IBOutlet NSArrayController *levelArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *layerArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *spriteArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *textureAtlasArrayController;
@property (nonatomic, retain) Texture *selectedTexture;
@property (nonatomic, retain) IBOutlet NSButton *infoButton;
@property (nonatomic, retain) IBOutlet NSArrayController *selectedSprites;
@property (nonatomic, retain) IBOutlet NSPanel *infoHUD;
@property (nonatomic, retain) IBOutlet NSTableView *layerTableView;
@property (nonatomic, retain) IBOutlet NSButton *showGridCheckbox;
@property (nonatomic, retain) Game *game;
@property (nonatomic, assign) int editMode;

@property (nonatomic, retain) NSMutableDictionary *volatileTextures;
@property (nonatomic, retain) NSMutableDictionary *volatileTextureToAtlasNameMap;

- (IBAction)toggleDrawer:(id)sender;
- (IBAction)toggleSpriteInfo:(id)sender;
- (NSMutableDictionary*)allTextures;
- (void)invalidateTextures;
- (IBAction)addNewLayer:(id)sender;
- (IBAction)addNewLevel:(id)sender;
- (IBAction)removeSelectedLayers:(id)sender;
- (IBAction)removeSelectedLevels:(id)sender;
- (NSArray *)sortDescriptors;
- (NSDictionary*)texturesForAtlasNamed:(NSString*)name;
- (IBAction)addNewSpriteSheet:(id)sender;
- (IBAction)removeSelectedSpriteSheets:(id)sender;

@end
