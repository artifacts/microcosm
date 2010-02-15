//
//  Game.h
//  Leveleditor
//
//  Created by Michael Markowski on 30.11.09.
//  Copyright 2009 Artifacts. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Game : NSManagedObject {

}

@end


@interface Game (CoreDataGeneratedAccessors)

@property (nonatomic, retain) NSNumber * showGridInEditor;
@property (nonatomic, retain) NSSet* levels;
@property (nonatomic, retain) NSSet* textureAtlases;
@property (nonatomic, retain) NSNumber * showBoundsInEditor;
@property (nonatomic, retain) NSSet * highscores;

@end
