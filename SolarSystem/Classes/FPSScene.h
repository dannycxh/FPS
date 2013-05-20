/**
 *  SolarSystemScene.h
 *  SolarSystem
 *
 *  Created by Mark Newton on 27/03/13.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */


#import "CC3Scene.h"
#import "CCLabelTTF.h"

@interface Room : NSObject
@property (nonatomic) CC3Vector lowerBounds;
@property (nonatomic) CC3Vector upperBounds;
@property (nonatomic, readonly) CC3Vector llf;
@property (nonatomic, readonly) CC3Vector rlf;
@property (nonatomic, readonly) CC3Vector luf;
@property (nonatomic, readonly) CC3Vector ruf;
@property (nonatomic, readonly) CC3Vector llb;
@property (nonatomic, readonly) CC3Vector rlb;
@property (nonatomic, readonly) CC3Vector lub;
@property (nonatomic, readonly) CC3Vector rub;


+ (Room *) roomWithLowerBounds:(CC3Vector)lower andUpper:(CC3Vector)upper;
@end

@interface Wall  : NSObject

@property (nonatomic) CC3Vector lowerBounds;
@property (nonatomic) CC3Vector upperBounds;

+ (Wall *) wallWithLowerBounds:(CC3Vector)lower andUpper:(CC3Vector)upper;

@end

@interface Staircase : Room

@property (nonatomic, readonly) NSArray *stairs;

+ (Staircase *) staircaseWithLowerBounds:(CC3Vector)lower andUpper:(CC3Vector)upper upperIsTopOfStaircase:(bool)upperIsTop;


@end

@interface SlopedRoom : Room
+ (SlopedRoom *) roomWithLLF:(CC3Vector)llf andRLF:(CC3Vector)rlf andLUF:(CC3Vector)luf andRUF:(CC3Vector)ruf andLLB:(CC3Vector)llb andRLB:(CC3Vector)rlb andLUB:(CC3Vector)lub  andRUB:(CC3Vector)rub;


@end

/** A sample application-specific CC3Scene subclass.*/
@interface FPSScene : CC3Scene
    {
        NSMutableArray *_planets; //Used to track the planets we add for moving the camera around
        NSMutableArray *_walls; // Solar system comes in a box now
        NSMutableArray *_rooms;
        CCLabelTTF *_label;
        
    }
    /** a generic function to add planets */
    - (CC3MeshNode*) addPlanetSize: (CGFloat) s name: (NSString*) planetName position: (CC3Vector) p moons: (int) m withTex:(NSString*) tex;
    /** a function to change where the camera is looking */
    - (void) viewNextPlanet;
/** a generic function to add walls */
- (CC3MeshNode*) addWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex;


- (void) moveCamera:(CC3Vector)toVector;
- (void) panCamera:(CC3Vector)byVector;

@end
