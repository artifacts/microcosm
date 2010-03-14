//
//  Layer.h
//  Leveleditor
//
//  Created by Michael Markowski on 29.11.09.
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
#import "Level.h"

@interface Layer : NSManagedObject {
}

- (NSString*)descriptionForHUD;

@end


@interface Layer (CoreDataGeneratedAccessors)

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * visibleInEditor;
@property (nonatomic, retain) NSNumber * visibleInScenery;
@property (nonatomic, retain) Level * level;
@property (nonatomic, retain) NSSet* sprites;
@property (nonatomic, retain) NSNumber * viewPosition;
@property (nonatomic, retain) NSNumber * opacity;
@property (nonatomic, retain) NSNumber * tintColor;
@property (nonatomic, retain) NSNumber * tintEnabled;

- (NSColor*)tintColorAsColor;
 
@end
