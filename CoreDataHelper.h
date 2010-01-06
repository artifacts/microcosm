//
//  CoreDataHelper.h
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

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
