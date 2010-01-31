//
//  TextureController.h
//  LevelEditor
//
//  Created by Michael Markowski on 27.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "Texture.h"

@interface TextureController : NSViewController {
	NSArrayController *textureArrayController;
	NSArrayController *textureAtlasArrayController;
	NSTreeController *spriteTypeTreeController;
    IBOutlet IKImageBrowserView * imageBrowser;
    NSTabView *spriteTypeTabView;
	NSOutlineView *treeView;
	NSTreeNode *rootTreeNode;
}

@property (nonatomic, retain) IBOutlet NSArrayController *textureArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *textureAtlasArrayController;
@property (nonatomic, retain) IBOutlet NSTabView *spriteTypeTabView;
@property (nonatomic, retain) IBOutlet NSOutlineView *treeView;
@property (nonatomic, retain) IBOutlet NSTreeController *spriteTypeTreeController;
@property (nonatomic, retain) NSTreeNode *rootTreeNode;

- (IBAction)openSpriteSheetAction:(id)sender;
- (IBAction)openCoordsAction:(id)sender;
- (Texture*)textureForKey:(NSString*)aKey;

@end
