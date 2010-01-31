//
//  SpriteType.h
//  LevelEditor
//
//  Created by Michael Markowski on 29.01.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Sprite.h"

@interface SpriteType : NSManagedObject {

}

@property (nonatomic, retain) NSNumber * tag;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * impact;
@property (nonatomic, retain) id icon;
@property (nonatomic, retain) NSString * clazz;
@property (nonatomic, retain) NSArray* keys;

@end
