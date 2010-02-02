
#import <Cocoa/Cocoa.h>
#import "Texture.h"
#import "AFGameEditor.h"

extern NSString *TextureTypePboardType;

#define kDeleteSelectedTexturesNotification @"deleteSelectedTextures"

@interface Model : NSObject {
	Texture *currentSpriteDefinition;
	NSImage *currentSpriteSheetImage;
//	NSManagedObject *currentLevel;
}

@property (nonatomic, retain) Texture *currentSpriteDefinition;
@property (nonatomic, retain) NSImage *currentSpriteSheetImage;
//@property (nonatomic, assign) NSManagedObject *currentLevel;

+ (Model*)sharedInstance;
+ (AFGameEditor*)currentDocumentForView:(NSView*)sender;

@end
