//
//  TextureAtlas.h
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TextureAtlas : NSManagedObject {
	NSMutableDictionary *cachedTextures;
}

@property (nonatomic, retain) NSMutableDictionary *cachedTextures;

- (NSMutableDictionary*)textures;

@end


@interface TextureAtlas (CoreDataGeneratedAccessors)

- (id)primitiveCoordinates;
- (void)setPrimitiveCoordinates:(id)value;

- (NSString *)primitiveName;
- (void)setPrimitiveName:(NSString *)value;

- (id)primitiveSpriteSheetImage;
- (void)setPrimitiveSpriteSheetImage:(id)value;

@property (nonatomic, retain) id coordinates;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id spriteSheetImage;
@property (nonatomic, retain) NSManagedObject * game;
@property (nonatomic, retain) NSSet* sprites;

@end
