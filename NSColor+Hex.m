//
//  NSColor+Hex.m
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


#import "NSColor+Hex.h"


@implementation NSColor(NSColorHexadecimalValue)

/*
-(NSString *)hexadecimalValueOfAnNSColor
{
	float redFloatValue, greenFloatValue, blueFloatValue, alphaFloatValue;
	int redIntValue, greenIntValue, blueIntValue, alphaIntValue;
	NSString *redHexValue, *greenHexValue, *blueHexValue, *alphaHexValue;
	
	//Convert the NSColor to the RGB color space before we can access its components
	NSColor *convertedColor=[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if(convertedColor)
	{
		// Get the red, green, and blue components of the color
		[convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:&alphaFloatValue];
		
		// Convert the components to numbers (unsigned decimal integer) between 0 and 255
		redIntValue=redFloatValue*255.99999f;
		greenIntValue=greenFloatValue*255.99999f;
		blueIntValue=blueFloatValue*255.99999f;
		
		// Convert the numbers to hex strings
		redHexValue=[NSString stringWithFormat:@"%02x", redIntValue];
		greenHexValue=[NSString stringWithFormat:@"%02x", greenIntValue];
		blueHexValue=[NSString stringWithFormat:@"%02x", blueIntValue];
		
		// Concatenate the red, green, and blue components' hex strings together with a "#"
		return [NSString stringWithFormat:@"#%@%@%@", redHexValue, greenHexValue, blueHexValue];
	}
	return nil;
}
 */

+ (NSColor*)colorFromNumber:(NSNumber*)number {
	NSUInteger hex = [number unsignedIntegerValue];
	return HEXCOLOR(hex);	
}

- (NSNumber*)asNumber {
	CGFloat redFloatValue, greenFloatValue, blueFloatValue, alphaFloatValue;
	NSUInteger redIntValue, greenIntValue, blueIntValue, alphaIntValue;
		
	//Convert the NSColor to the RGB color space before we can access its components
	NSColor *convertedColor=[self colorUsingColorSpaceName:NSCalibratedRGBColorSpace];
	
	if(convertedColor)
	{
		// Get the red, green, and blue components of the color
		[convertedColor getRed:&redFloatValue green:&greenFloatValue blue:&blueFloatValue alpha:&alphaFloatValue];
		
		redIntValue=redFloatValue*255.99999f;
		greenIntValue=greenFloatValue*255.99999f;
		blueIntValue=blueFloatValue*255.99999f;
		alphaIntValue=alphaFloatValue*255.99999f;
	
		NSUInteger result = ((redIntValue<<24)&0xffffffff) + ((greenIntValue<<16)&0xffffffff) + ((blueIntValue<<8)&0xffffffff) + (alphaIntValue&0xffffffff);
	
//		NSColor *testColor = HEXCOLOR(result);
//		NSLog(@"before: %@, after: %@, hex: %08x", [convertedColor description], [testColor description], result);
		return [NSNumber numberWithUnsignedInteger:result];
	}
	return nil;
}

@end