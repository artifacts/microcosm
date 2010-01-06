/*
 * Copyright 2008 Artifacts - Fine Software Development
 * http://www.artifacts.de
 * Author: Michael Markowski (m.markowski@artifacts.de)
 * 
 */

#import "Model.h"

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
