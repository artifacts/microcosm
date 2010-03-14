//
//  Layer.m
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


#import "Layer.h"
#import "NSColor+Hex.h"

@implementation Layer

- (NSString*)descriptionForHUD
{
	return [NSString stringWithFormat: @"%@, viewPosition: %d", self.name, self.viewPosition];
}

@end

@implementation Layer (CoreDataGeneratedAccessors)

@dynamic name, visibleInEditor, visibleInScenery, level, sprites, viewPosition, opacity, tintColor, tintEnabled;

- (NSColor*)tintColorAsColor {
	return [NSColor colorFromNumber:self.tintColor];
}

@end
