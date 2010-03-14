//
//  TextureController.h
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


#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>
#import "Texture.h"
#import "SpriteTypeTreeView.h"

@interface TextureController : NSViewController {
	NSArrayController *textureArrayController;
	NSArrayController *textureAtlasArrayController;
	NSTreeController *spriteTypeTreeController;
    IBOutlet IKImageBrowserView * imageBrowser;
    NSTabView *spriteTypeTabView;
	SpriteTypeTreeView *treeView;
	NSTreeNode *rootTreeNode;
}

@property (nonatomic, retain) IBOutlet NSArrayController *textureArrayController;
@property (nonatomic, retain) IBOutlet NSArrayController *textureAtlasArrayController;
@property (nonatomic, retain) IBOutlet NSTabView *spriteTypeTabView;
@property (nonatomic, retain) IBOutlet SpriteTypeTreeView *treeView;
@property (nonatomic, retain) IBOutlet NSTreeController *spriteTypeTreeController;
@property (nonatomic, retain) NSTreeNode *rootTreeNode;

- (IBAction)openSpriteSheetAction:(id)sender;
- (IBAction)openCoordsAction:(id)sender;
- (Texture*)textureForKey:(NSString*)aKey;

@end
