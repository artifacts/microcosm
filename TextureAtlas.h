//
//  TextureAtlas.h
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
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


@interface TextureAtlas : NSManagedObject {
	NSMutableDictionary *_cachedTextures;
}

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
