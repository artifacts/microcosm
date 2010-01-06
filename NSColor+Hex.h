//
//  NSColor+Hex.h
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define HEXCOLOR(c) [NSColor colorWithDeviceRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0]

@interface NSColor(NSColorHexadecimalValue)

//-(NSString *)hexadecimalValueOfAnNSColor;
- (NSNumber*)asNumber;
+ (NSColor*)colorFromNumber:(NSNumber*)number;

@end