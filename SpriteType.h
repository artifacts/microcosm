//
//  SpriteType.h
//  LevelEditor
//
//  Created by Michael Markowski on 29.01.10.
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
