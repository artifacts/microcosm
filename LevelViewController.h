//
//  LevelViewController.h
//  LevelEditor
//
//  Created by Michael Markowski on 26.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>


enum {
	kTagToolbarButtonMoveAndDrag = 1,
	kTagToolbarButtonSelect = 2,
	kTagToolbarButtonDraw = 3,
};

@interface LevelViewController : NSViewController {
	NSButton *toolbarButtonMoveAndDrag;
	NSButton *toolbarButtonDraw;	
	NSButton *toolbarButtonSelect;
}

@property (nonatomic, retain) IBOutlet NSButton *toolbarButtonMoveAndDrag;
@property (nonatomic, retain) IBOutlet NSButton *toolbarButtonDraw;
@property (nonatomic, retain) IBOutlet NSButton *toolbarButtonSelect;

- (IBAction)toolbarAction:(id)sender;
- (void)disableAllToolbarButtons;

@end
