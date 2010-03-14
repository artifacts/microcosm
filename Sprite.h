//
//  Sprite.h
//  Leveleditor
//
//  Created by Michael Markowski on 24.11.09.
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

