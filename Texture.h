//
//  SpriteDefinition.h
//  Leveleditor
//
//  Created by Michael Markowski on 26.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>




@interface Texture : NSObject <NSCoding> {
	NSRect frame;
	NSString *key;
	NSImage *img;
}

@property (nonatomic, assign) NSRect frame;
@property (nonatomic, copy) NSString *key;
@property (nonatomic, retain) NSImage *img;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)xPosition;
- (CGFloat)yPosition;
   
@end
