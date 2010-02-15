//
//  TagValueToTagObjectTransformer.m
//  LevelEditor
//
//  Created by Michael Markowski on 13.02.10.
//  Copyright 2010 Artifacts. All rights reserved.
//

#import "TagValueToTagObjectTransformer.h"
#import "AFGameEditor.h"

@implementation TagValueToTagObjectTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSManagedObject class];
}


- (id)transformedValue:(id)value {
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	NSManagedObjectContext *managedObjectContext = doc.managedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tag" inManagedObjectContext:managedObjectContext];
    [request setEntity:entity];
    // retrive the objects with a given value for a certain property
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"tagValue == %@", value];
    [request setPredicate:predicate];	
    NSError *error = nil;
    NSArray *result = [managedObjectContext executeFetchRequest:request error:&error];
    [request release];
	if ([result count]==0) return nil;
	return [result objectAtIndex:0];
}


- (id)reverseTransformedValue:(id)value {
	NSManagedObject *obj = value;
	NSNumber *number = [obj valueForKey:@"tagValue"];
//	NSInteger tagValue = [number integerValue];
	return number;
}

@end
