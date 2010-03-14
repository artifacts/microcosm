//
//  UIImageToDataTransformer.m
//  iPin
//
//  Created by Michael Markowski on 15.07.09.
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


#import "ImageToPNGDataTransformer.h"


@implementation ImageToPNGDataTransformer

+ (BOOL)allowsReverseTransformation {
	return YES;
}

+ (Class)transformedValueClass {
	return [NSData class];
}


- (id)transformedValue:(id)value {
	NSImage *image = value;
	NSBitmapImageRep *imageRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
	NSDictionary *imageProps = nil; //[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
	NSData *data = [imageRep representationUsingType:NSPNGFileType properties:imageProps];
	return data;
}


- (id)reverseTransformedValue:(id)value {
	NSImage *img = [[NSImage alloc] initWithData:value];
	return [img autorelease];
}

@end
