//
//  Layer.h
//  Leveleditor
//
//  Created by Michael Markowski on 29.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Level.h"

@interface Layer : NSManagedObject {
}

- (NSString*)descriptionForHUD;

@end


@interface Layer (CoreDataGeneratedAccessors)

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * visibleInEditor;
@property (nonatomic, retain) NSNumber * visibleInScenery;
@property (nonatomic, retain) Level * level;
@property (nonatomic, retain) NSSet* sprites;
@property (nonatomic, retain) NSNumber * viewPosition;
@property (nonatomic, retain) NSNumber * opacity;
@property (nonatomic, retain) NSNumber * tintColor;
@property (nonatomic, retain) NSNumber * tintEnabled;

- (NSColor*)tintColorAsColor;
 
@end
