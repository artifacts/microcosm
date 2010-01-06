
#import <Cocoa/Cocoa.h>
#import "Texture.h"

@interface Model : NSObject {
	Texture *currentSpriteDefinition;
	NSImage *currentSpriteSheetImage;
//	NSManagedObject *currentLevel;
}

@property (nonatomic, retain) Texture *currentSpriteDefinition;
@property (nonatomic, retain) NSImage *currentSpriteSheetImage;
//@property (nonatomic, assign) NSManagedObject *currentLevel;

+ (Model*)sharedInstance;

@end
