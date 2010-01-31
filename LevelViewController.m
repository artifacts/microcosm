//
//  LevelViewController.m
//  LevelEditor
//
//  Created by Michael Markowski on 26.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import "LevelViewController.h"
#import "AFGameEditor.h"

@implementation LevelViewController

@synthesize toolbarButtonMoveAndDrag, toolbarButtonDraw, toolbarButtonSelect;


- (IBAction)toolbarAction:(id)sender {
	[self disableAllToolbarButtons];
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	switch ([sender tag]) {
		case kTagToolbarButtonMoveAndDrag:
			[toolbarButtonMoveAndDrag setState:NSOnState];
			doc.editMode = kEditModeMoveAndDrag;
			break;
		case kTagToolbarButtonSelect:
			[toolbarButtonSelect setState:NSOnState];
			doc.editMode = kEditModeSelect;
			break;
		case kTagToolbarButtonDraw:
			[toolbarButtonDraw setState:NSOnState];
			doc.editMode = kEditModeDraw;
			break;			
		default:
			break;
	}
	[[self.view window] invalidateCursorRectsForView:self.view];
}

- (void)disableAllToolbarButtons {
	[toolbarButtonMoveAndDrag setState:NSOffState];
	[toolbarButtonDraw setState:NSOffState];
	[toolbarButtonSelect setState:NSOffState];
}

@end
