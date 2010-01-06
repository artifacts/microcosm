//
//  Level.h
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Game.h"

@interface Level : NSManagedObject {

}

@end

@interface Level (CoreDataGeneratedAccessors)

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Game * game;
@property (nonatomic, retain) NSSet* layers;
@property (nonatomic, retain) NSNumber * viewPosition;
@property (nonatomic, retain) NSNumber * bgColor;

@end
