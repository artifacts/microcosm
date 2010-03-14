//
//  LevelViewController.m
//  LevelEditor
//
//  Created by Michael Markowski on 26.01.10.
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
