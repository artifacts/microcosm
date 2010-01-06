//
//  Sprite.h
//  Leveleditor
//
//  Created by Michael Markowski on 24.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Texture.h"

@interface Sprite : NSManagedObject {
}

- (NSPoint)location;
- (void)setLocation:(NSPoint)aPoint;
- (NSSize)size;
- (NSColor*)tintColorAsColor;
- (NSDictionary *) dictionaryRepresentation;

@end

@interface Sprite (HUDInfo)

- (NSImage*)image;
- (Texture*)texture;

@end

@interface Sprite (CoreDataGeneratedAccessors)

@property (nonatomic, retain) NSNumber * hasPhysics;
@property (nonatomic, retain) NSNumber * height;
@property (nonatomic, retain) NSNumber * isGhost;
@property (nonatomic, retain) NSString * key;
@property (nonatomic, retain) NSNumber * width;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSManagedObject * layer;
@property (nonatomic, retain) NSManagedObject * textureAtlas;
@property (nonatomic, retain) NSNumber * impact;
@property (nonatomic, retain) NSNumber * opacity;
@property (nonatomic, retain) NSNumber * tintColor;
@property (nonatomic, retain) NSNumber * tintEnabled;

@end

