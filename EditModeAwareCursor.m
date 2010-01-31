//
//  EditModeAwareCursor.m
//  LevelEditor
//
//  Created by Michael Markowski on 27.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import "EditModeAwareCursor.h"
#import "AFGameEditor.h"

@implementation EditModeAwareCursor

- (id) init
{
	self = [super init];
	if (self != nil) {
		AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
		
	}
	return self;
}

@end
