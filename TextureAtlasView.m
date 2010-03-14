//
//  SpriteSheetImage.m
//  Leveleditor
//
//  Created by Michael Markowski on 20.11.09.
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


#import "TextureAtlasView.h"
#import "Model.h"
#import "AFGameEditor.h"
#import "TextureAtlas.h"

@implementation TextureAtlasView

@synthesize coords;
@synthesize image;
@synthesize currentSpriteView;

/*
 - (void)awakeFromNib {
 }
 
 - (id) initWithFrame:(CGRect)rect
 {
 self = [super initWithFrame:rect];
 if (self != nil) {
 }
 return self;
 }
 */
- (void)drawRect:(NSRect)dirtyRect
{
	[[NSColor blackColor] set];
	[NSBezierPath fillRect:dirtyRect];
	
	[super drawRect:dirtyRect];	
	[[NSColor redColor] set];
	
	[image drawInRect:dirtyRect fromRect:dirtyRect operation:NSCompositeSourceOver fraction:1.0];
	
	NSDictionary *sdefs = [selectedTextureAtlas textures];

	for (Texture *sdef in [sdefs allValues]) {
		[NSBezierPath strokeRect:sdef.frame];				
	}
	
	//[context restoreGraphicsState];
	if (highlightedTexture!=nil) {
		[[NSColor colorWithDeviceRed:1.0 green:0.0 blue:0.0 alpha:0.25] set];
		[NSBezierPath fillRect:highlightedTexture.frame];
	}
	
	if ([Model sharedInstance].currentSpriteDefinition) {
		[[NSColor colorWithDeviceRed:0.75 green:0.0 blue:0.0 alpha:0.5] set];
		[NSBezierPath fillRect:[Model sharedInstance].currentSpriteDefinition.frame];
	}		
}

- (void)updateTrackingAreas {
	[super updateTrackingAreas];
    [self removeTrackingArea:trackingArea];
    [trackingArea release];	
	NSRect rect = self.frame;
	trackingArea = [[NSTrackingArea alloc] initWithRect:rect
												options: (NSTrackingMouseMoved | NSTrackingActiveInKeyWindow | NSTrackingInVisibleRect)
												  owner:self userInfo:nil];
	[self addTrackingArea:trackingArea];
}

- (void)setCoords:(id)dictionary
{
	if (coords == dictionary) return;
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];	
	[coords release];
	coords = [dictionary retain];
	[doc invalidateTextures];
	[self setNeedsDisplay:YES];
	[levelView setNeedsDisplay:YES];
}

- (void)setImage:(NSImage*)anImg
{
	if (image==anImg) return;
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];	
	[image release];
	image = [anImg retain];
	[Model sharedInstance].currentSpriteSheetImage = image;
	[doc invalidateTextures];
	[self setFrame:NSMakeRect(0, 0, self.image.size.width, self.image.size.height)];
	[self updateTrackingAreas];
	[levelView setNeedsDisplay:YES];
}

- (Texture*)textureAtPoint:(NSPoint)aPoint
{
	NSDictionary *sdefs = [selectedTextureAtlas textures];	
	for (Texture *s in [sdefs allValues])
	{
		if (NSPointInRect(aPoint, s.frame)) return s;
	}
	return nil;
}

- (void)mouseMoved:(NSEvent *)theEvent {
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	highlightedTexture = [self textureAtPoint:point];
	if (highlightedTexture==nil) return;
	if (lastHighlightedTexture!=nil && highlightedTexture != lastHighlightedTexture)  {
		[self setNeedsDisplayInRect:lastHighlightedTexture.frame];
		lastHighlightedTexture = highlightedTexture;
	}
	[self setNeedsDisplayInRect:highlightedTexture.frame];
	[self displayIfNeeded];
}


- (void)mouseDown:(NSEvent *)theEvent
{
	AFGameEditor *doc = (AFGameEditor*)[[NSDocumentController sharedDocumentController] currentDocument];
	NSPoint point = [self convertPoint:[theEvent locationInWindow] fromView:nil];
	doc.selectedTexture = [self textureAtPoint:point];
	highlightedTexture = [self textureAtPoint:point];
	[currentSpriteView setImage:doc.selectedTexture.img];
	[self setNeedsDisplay:YES];
}


@end
