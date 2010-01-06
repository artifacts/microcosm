//
//  CoreDataHelper.m
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import "CoreDataHelper.h"

//#define temporaryViewPositionNum [NSNumber numberWithInt:temporaryViewPosition]
//#define startViewPositionNum [NSNumber numberWithInt:startViewPosition]
//#define endViewPositionNum [NSNumber numberWithInt:endViewPosition]


@implementation CoreDataHelper

@synthesize managedObjectContext;
@synthesize sortDescriptors;
@synthesize entityName;


- (id) initWithManagedObjectContext:(NSManagedObjectContext*)moc sortDescriptors:(NSArray*)sortDescs entityName:(NSString*)name
{
	if (self = [super init]) {
		self.managedObjectContext = moc;
		self.sortDescriptors = sortDescs;
		self.entityName = name;
	}
	return self;
}

- (NSArray *)entitiesUsingFetchPredicate:(NSPredicate *)fetchPredicate
{
	NSError *error = nil;
	NSEntityDescription *entityDesc = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	
	NSArray *arrayOfItems;
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	[fetchRequest setEntity:entityDesc];
	[fetchRequest setPredicate:fetchPredicate];
	[fetchRequest setSortDescriptors:sortDescriptors];
	arrayOfItems = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
	[fetchRequest release];
	
	return arrayOfItems;
}

- (NSArray *)entitiesWithViewPosition:(int)value
{
	NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"viewPosition == %i", value];	
	return [self entitiesUsingFetchPredicate:fetchPredicate];
}

- (NSArray *)entitiesWithNonTemporaryViewPosition
{
	NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"viewPosition >= 0"];	
	return [self entitiesUsingFetchPredicate:fetchPredicate];
}

- (NSArray *)entitiesWithViewPositionGreaterThanOrEqualTo:(int)value
{
	NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"viewPosition >= %i", value];	
	return [self entitiesUsingFetchPredicate:fetchPredicate];
}

- (NSArray *)entitiesWithViewPositionBetween:(int)lowValue and:(int)highValue
{
	NSPredicate *fetchPredicate = [NSPredicate predicateWithFormat:@"viewPosition >= %i && viewPosition <= %i", lowValue, highValue];	
	return [self entitiesUsingFetchPredicate:fetchPredicate];
}

- (int)renumberViewPositionsOfEntities:(NSArray *)array startingAt:(int)value
{
	int currentViewPosition = value;
	
	int count = 0;
	
	if( array && ([array count] > 0) )
	{
		for( count = 0; count < [array count]; count++ )
		{
			NSManagedObject *currentObject = [array objectAtIndex:count];
			[currentObject setValue:[NSNumber numberWithInt:currentViewPosition] forKey:@"viewPosition"];
			currentViewPosition++;
		}
	}	
	return currentViewPosition;
}

- (void)renumberViewPositions
{
	NSArray *startItems = [self entitiesWithViewPosition:kStartViewPosition];	
	NSArray *existingItems = [self entitiesWithNonTemporaryViewPosition];
	NSArray *endItems = [self entitiesWithViewPosition:kEndViewPosition];
	
	int currentViewPosition = 0;
	
	if( startItems && ([startItems count] > 0) )
		currentViewPosition = [self renumberViewPositionsOfEntities:startItems startingAt:currentViewPosition];
	
	if( existingItems && ([existingItems count] > 0) )
		currentViewPosition = [self renumberViewPositionsOfEntities:existingItems startingAt:currentViewPosition];
	
	if( endItems && ([endItems count] > 0) )
		currentViewPosition = [self renumberViewPositionsOfEntities:endItems startingAt:currentViewPosition];
}
@end
