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

#import "Model.h"

NSString *TextureTypePboardType = @"TextureTypePboardType";

@implementation Model

@synthesize currentSpriteDefinition;
@synthesize currentSpriteSheetImage;
//@synthesize currentLevel;

static Model *sharedModelInstance = nil;

- (id) init
{
	self = [super init];
	if (self != nil) {
	}
	return self;
}

// ---------------------------------------------------------------
+ (Model*)sharedInstance
// ---------------------------------------------------------------
{
	@synchronized(self) {
		if (sharedModelInstance == nil) 
		{
			sharedModelInstance = [[self alloc] init];
			sharedModelInstance.currentSpriteDefinition = [Texture new];
		}
	}
	return sharedModelInstance;
}

+ (AFGameEditor*)currentDocumentForView:(NSView*)sender {
//	return (AFGameEditor*)[[[sender window] windowController] document];
	NSAssert(0, @"todo");
	return nil;
}

// ---------------------------------------------------------------
- (id)copyWithZone:(NSZone *)zone { return self; }
// ---------------------------------------------------------------

// ---------------------------------------------------------------
- (id)retain { return self; }
// ---------------------------------------------------------------

// ---------------------------------------------------------------
- (NSUInteger)retainCount { return UINT_MAX; } //denotes an object that cannot be released

// ---------------------------------------------------------------

// ---------------------------------------------------------------
- (void)release { }
// ---------------------------------------------------------------

// ---------------------------------------------------------------
- (id)autorelease { return self; }
// ---------------------------------------------------------------

// ---------------------------------------------------------------
- (void) dealloc
// ---------------------------------------------------------------
{
	[super dealloc];
}

@end
