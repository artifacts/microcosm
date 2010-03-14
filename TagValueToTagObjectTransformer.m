//
//  TagValueToTagObjectTransformer.m
//  LevelEditor
//
//  Created by Michael Markowski on 13.02.10.
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
