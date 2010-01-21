//
//  UIImageToDataTransformer.m
//  iPin
//
//  Created by Michael Markowski on 15.07.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

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
