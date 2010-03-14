//
//  CoreDataHelper.h
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

enum kViewPositions {
	kTemporaryViewPosition = -1,
	kStartViewPosition = -2,
	kEndViewPosition = -3,
};

@interface CoreDataHelper : NSObject {
	NSManagedObjectContext* managedObjectContext;
	NSString *entityName;
	NSArray *sortDescriptors;
}

@property (nonatomic, retain) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, retain) NSArray *sortDescriptors;
@property (nonatomic, retain) NSString *entityName;

- (id) initWithManagedObjectContext:(NSManagedObjectContext*)moc sortDescriptors:(NSArray*)sortDescriptors entityName:(NSString*)name;
- (NSArray *)entitiesUsingFetchPredicate:(NSPredicate *)fetchPredicate;
- (NSArray *)entitiesWithViewPosition:(int)value;
- (NSArray *)entitiesWithNonTemporaryViewPosition;
- (NSArray *)entitiesWithViewPositionGreaterThanOrEqualTo:(int)value;
- (NSArray *)entitiesWithViewPositionBetween:(int)lowValue and:(int)highValue;
- (int)renumberViewPositionsOfEntities:(NSArray *)array startingAt:(int)value;

- (void)renumberViewPositions;

@end
