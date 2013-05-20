/**
 *  SolarSystemScene.m
 *  SolarSystem
 *
 *  Created by Mark Newton on 27/03/13.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */
#import "CCActionInstant.h"
#import "FPSScene.h"
#import "CC3PODResourceNode.h"
#import "CC3ActionInterval.h"
#import "CC3MeshNode.h"
#import "CC3Camera.h"
#import "CC3Light.h"
#import "CCMenuItem.h"
#import "CCMenu.h"
#import "CGPointExtension.h"

@interface Room ()

@property (nonatomic) CC3Vector llb;
@property (nonatomic) CC3Vector llf;
@property (nonatomic) CC3Vector rlf;
@property (nonatomic) CC3Vector luf;
@property (nonatomic) CC3Vector ruf;
@property (nonatomic) CC3Vector rlb;
@property (nonatomic) CC3Vector lub;
@property (nonatomic) CC3Vector rub;

@end

@implementation Room

+ (Room *) roomWithLowerBounds:(CC3Vector)lower andUpper:(CC3Vector)upper {
    Room *room = [[Room alloc] init];
    [room setLowerBounds:lower];
    [room setUpperBounds:upper];
    //[room setPoints];
    return room;
}

+ (Room *)roomWithPoints:(float)x0 x1:(float)x1 y0:(float)y0 y1:(float)y1 z0:(float)z0 z1:(float)z1 {
    Room *room = [[Room alloc] init];
    CC3Vector lower = cc3v(x0,y0,z0);
    CC3Vector upper = cc3v(x1,y1,z1);
    [room setLowerBounds:lower];
    [room setUpperBounds:upper];
    return room;
}

- (void) setLowerBounds:(CC3Vector)value {
    _lowerBounds = value;
    [self setPoints];
}

- (void)setUpperBounds:(CC3Vector)value {
    _upperBounds = value;
    [self setPoints];
}

- (void)setPoints {
    [self setLlf:cc3v(self.lowerBounds.x,self.lowerBounds.y,self.lowerBounds.z)];
    [self setLlb:cc3v(self.lowerBounds.x,self.lowerBounds.y,self.upperBounds.z)];
    [self setLuf:cc3v(self.lowerBounds.x,self.upperBounds.y,self.lowerBounds.z)];
    [self setLub:cc3v(self.lowerBounds.x,self.upperBounds.y,self.upperBounds.z)];
    [self setRlf:cc3v(self.upperBounds.x,self.lowerBounds.y,self.lowerBounds.z)];
    [self setRlb:cc3v(self.upperBounds.x,self.lowerBounds.y,self.upperBounds.z)];
    [self setRuf:cc3v(self.upperBounds.x,self.upperBounds.y,self.lowerBounds.z)];
    [self setRub:cc3v(self.upperBounds.x,self.upperBounds.y,self.upperBounds.z)];

}

@end

@implementation Wall


+ (Wall *) wallWithLowerBounds:(CC3Vector)lower andUpper:(CC3Vector)upper {
    Wall *wall = [[Wall alloc] init];
    [wall setLowerBounds:lower];
    [wall setUpperBounds:upper];
    return wall;
}


@end

@interface Staircase ()

@property (nonatomic) NSArray *stairs;

@end

@implementation Staircase


// Lower is bottom of staircase
+ (Staircase *) staircaseWithLowerBounds:(CC3Vector)lower andUpper:(CC3Vector)upper upperIsTopOfStaircase:(bool)upperIsTop {
    Staircase *staircase = [[Staircase alloc] init];
    [staircase setUpperBounds:upper];
    [staircase setLowerBounds:lower];
    
    float stepsX = upper.x - lower.x;
    float stepsY = upper.y - lower.y;
    float stepsZ = upper.z - lower.z;
    
    float steps = 10.f;
    
    float eachStepX = stepsX/steps;
    float eachStepY = stepsY/steps;
    float eachStepZ = stepsZ/steps;
    
    CC3Vector v1 = cc3v(lower.x,lower.y,lower.z);
    CC3Vector v2 = cc3v(lower.x+eachStepX, lower.y+eachStepY, upper.z);
    
    NSMutableArray *stairsM = [NSMutableArray array];
    [stairsM addObject:[Wall wallWithLowerBounds:v1 andUpper:v2]];
    
    for (int i=1;i<steps;i++) {
        v1 = cc3v(v2.x, v2.y, lower.z);
        v2 = cc3v(v1.x+eachStepX, v1.y+eachStepY, upper.z);
        
        [stairsM addObject:[Wall wallWithLowerBounds:v1 andUpper:v2]];
    }
    
    [staircase setStairs:[stairsM copy]];
    
    return staircase;
}


@end

@implementation SlopedRoom

+ (SlopedRoom *) roomWithLLF:(CC3Vector)llf andRLF:(CC3Vector)rlf andLUF:(CC3Vector)luf andRUF:(CC3Vector)ruf andLLB:(CC3Vector)llb andRLB:(CC3Vector)rlb andLUB:(CC3Vector)lub  andRUB:(CC3Vector)rub {
    SlopedRoom *room = [[SlopedRoom alloc] init];
    
    [room setLowerBounds:llf];
    [room setUpperBounds:rub];
    [room setLlb:llb];
    [room setLlf:llf];
    [room setLub:lub];
    [room setLuf:luf];
    [room setRlb:rlb];
    [room setRlf:rlf];
    [room setRub:rub];
    [room setRuf:ruf];
    
    return room;
}


@end

@implementation FPSScene

/*CC3Vector llf;
CC3Vector rlf;
CC3Vector luf;
CC3Vector ruf;
CC3Vector llb;
CC3Vector rlb;
CC3Vector lub;
CC3Vector rub;*/


-(void) dealloc {
	[super dealloc];
}


/**
 * Constructs the 3D scene.
 *
 * Adds 3D objects to the scene, loading a 3D 'hello, world' message
 * from a POD file, and creating the camera and light programatically.
 *
 * When adapting this template to your application, remove all of the content
 * of this method, and add your own to construct your 3D model scene.
 *
 * NOTE: The POD file used for the 'hello, world' message model is fairly large,
 * because converting a font to a mesh results in a LOT of triangles. When adapting
 * this template project for your own application, REMOVE the POD file 'hello-world.pod'
 * from the Resources folder of your project!!
 */
-(void) initializeScene {


    
    
    
    
    [self addContentFromPODResourceFile: @"earth.pod"];
    [self createGLBuffers];
    [self releaseRedundantData];
    
    //create Sun
    CC3MeshNode *sun = [self addPlanetSize:2.f name:@"Sun" position:cc3v(0.f,0.f,0.f) moons:0 withTex:@"sunmap.jpg"];
    sun.material.emissionColor = ccc4FFromccc4B(ccc4(255, 255, 255, 255));  //make the sun sunny
    
    //Add lighting - first sunlight radiating outwards
    CC3Light *sunlight = [CC3Light nodeWithName:@"SunLight"];
    sunlight.isDirectionalOnly=NO;
    [self addChild:sunlight];
    
    //Add the planets
    _planets = [[NSMutableArray alloc] init];
    /*[_planets addObject:[self addPlanetSize:0.5 name:@"Mercury" position:cc3v(14.f,0.f,0.f) moons:0 withTex:@"mercurymap.jpg"]];
    [_planets addObject:[self addPlanetSize:0.7 name:@"Venus" position:cc3v(18.f,0.f,0.f) moons:0  withTex:@"venusmap.jpg"]];
    [_planets addObject:[self addPlanetSize:1.f name:@"Earth" position:cc3v(22.f,0.f,0.f) moons:1 withTex:nil]];
    [_planets addObject:[self addPlanetSize:1.1f name:@"Mars" position:cc3v(30.f,0.f,0.f) moons:2 withTex:@"mars_1k_color.jpg"]];*/
    
    // Add walls
    // z,y,x
    
    float x0=-2.5f, y0 = -2.5f, z0 = -2.5f, x1 = 2.5f,y1=2.5f,z1=2.5f;
    
    //[self setWallVectorsWithPoints:x0 x1:x1 y0:y0 y1:y1 z0:z0 z1:z1];
    //Room *roomq = [Room roomWithLowerBounds:llf andUpper:rub];
    Room *roomq = [Room roomWithPoints:x0 x1:x1 y0:y0 y1:y1 z0:z0 z1:z1];
    _rooms = [NSMutableArray array];
    [_rooms addObject:roomq];
    
    _walls = [NSMutableArray array];
    [self addWallsFromStandardRoom:roomq];
    
    // Create the camera
    CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
    cam.location = cc3v(0.f, 0.f, 60.f);
    [self addChild: cam];

    
    //And make the camera track our Earth node
    CC3Node *earth = (CC3Node*) [self getNodeNamed:@"Earth"];
    //cam.target = earth;
    cam.target = sun;
    cam.shouldTrackTarget=NO;
    cam.farClippingDistance = kCC3DefaultFarClippingDistance*4.f;
    
    CC3Camera *aboveCam = [CC3Camera nodeWithName:@"AboveCam"];
    aboveCam.location = cc3v(0.f, 1800.f, 0.f);
    aboveCam.target = sun;
    aboveCam.shouldTrackTarget = NO;
    aboveCam.farClippingDistance = kCC3DefaultFarClippingDistance*4.f;

    [self addChild:aboveCam];
    
    for (int i=0;i<3;i++) {
        [self addRoomsToWalls:_walls];
    }
    NSMutableArray *recentWalls = [NSMutableArray array];
    for (int j=0;j<3;j++) {
        [recentWalls addObject:[_walls lastObject]];
        [recentWalls addObject:[_walls objectAtIndex:[_walls count]-2]];
        [recentWalls addObject:[_walls objectAtIndex:[_walls count]-3]];
        [self addRoomsToWalls:recentWalls];
        [recentWalls removeAllObjects];
    }
    
    CC3Vector northPoint = cc3v(0.f,0.f,1000.f);
    
    for (int k=0;k<5;k++) {
        [self addRoomToWall:[self wallClosestToPoint:northPoint]];
        //[self addRoomsToWalls:recentWalls];
        //[recentWalls removeAllObjects];

    }
    CC3Vector southPoint = cc3v(0.f,0.f,-1000.f);
    for (int k=0;k<5;k++) {
        [self addRoomToWall:[self wallClosestToPoint:southPoint]];
        //[self addRoomsToWalls:recentWalls];
        //[recentWalls removeAllObjects];
        
    }
    CC3Vector westPoint = cc3v(-1000.f,0.f,0.f);
    for (int k=0;k<5;k++) {
        [self addRoomToWall:[self wallClosestToPoint:westPoint]];
        //[self addRoomsToWalls:recentWalls];
        //[recentWalls removeAllObjects];
        
    }
    CC3Vector eastPoint = cc3v(1000.f,0.f,0.f);
    for (int k=0;k<5;k++) {
        [self addRoomToWall:[self wallClosestToPoint:eastPoint]];
        //[self addRoomsToWalls:recentWalls];
        //[recentWalls removeAllObjects];
        
    }
    
    // Add staircase to west
    CC3MeshNode *westWall = [self wallClosestToPoint:westPoint];
    CC3Vector lN = westWall.boundingBox.minimum;
    CC3Vector mx = westWall.boundingBox.maximum;
    [self addStaircaseWithLower:cc3v(lN.x-10.f, lN.y-10.f, lN.z-10.f) andUpper:mx];
    // east
    CC3MeshNode *eastWall = [self wallClosestToPoint:eastPoint];
    lN = eastWall.boundingBox.minimum;
    mx = eastWall.boundingBox.maximum;
    
    [self addStaircaseWithLower:lN andUpper:cc3v(mx.x+10.f, mx.y+10.f, mx.z+10.f)];

    
    // Add room to north
    CC3MeshNode *northWall = [self wallClosestToPoint:northPoint];
    CC3Vector min = northWall.boundingBox.minimum;
    CC3Vector max = northWall.boundingBox.maximum;
    CC3Vector min1 = CC3VectorAdd(min,  cc3v(4.0,3.0,12.0));
    CC3Vector max1 = CC3VectorAdd(max, cc3v(4.0,3.0,12.0));
    CC3MeshNode *newNorthWall = [self addWallWithName:@"North" startPosition:min1 endPosition:max1 withTex:@"moonmap1k.jpg"];
    CC3Vector third = cc3v(max.x, min.y, min.z);
    CC3Vector fourth = cc3v(max1.x, min1.y, min1.z);
    //CC3MeshNode *matchingWall = [self addRotatedWallBetweenFourVectors:min second:min1 third:third fourth:fourth];
    CC3MeshNode *matchingWall = [self addRotatedWallBetweenTwoVectors:min max:min1];

    
    [self makeWallsInvisibleWhereAdjoiningRoomsExist];
}

- (void)logVector:(CC3Vector)vector {
    NSLog(@"Vector: %f,%f,%f", vector.x, vector.y, vector.z);
}

- (void)logRoom:(Room *)room {
    [self logVector:room.llf];
    [self logVector:room.rlf];
    [self logVector:room.luf];
    [self logVector:room.ruf];
    [self logVector:room.llb];
    [self logVector:room.rlb];
    [self logVector:room.lub];
    [self logVector:room.rub];
}

- (CC3MeshNode *)wallClosestToPoint:(CC3Vector)point {
    //float x=300.f, y=300.f, z=300.f;
    int total = INT16_MAX;
    CC3MeshNode *closestWall = nil;
    NSLog(@"Point: %f,%f,%f", point.x, point.y, point.z);
    for (CC3MeshNode *eachWall in _walls) {
        CC3Vector min = eachWall.localContentBoundingBox.minimum;
        CC3Vector max = eachWall.localContentBoundingBox.maximum;
        CC3Vector midPoint = CC3VectorAverage(min, max);
        CC3Vector diff = CC3VectorDifference(point, midPoint);
        int diffTotal = abs(diff.x)+abs(diff.y)+abs(diff.z);
        NSLog(@"Min: %f,%f,%f \nMax: %f,%f,%f \nDiff: %f,%f,%f \nTotal:%d", min.x, min.y, min.z, max.x, max.y, max.z, diff.x, diff.y, diff.z, diffTotal);
        if (diffTotal < total) {
            closestWall = eachWall;
            total = diffTotal;
        }
    }
    return closestWall;
}

- (void)addStaircaseWithLower:(CC3Vector)lower andUpper:(CC3Vector)upper {
    Staircase *staircase = [Staircase staircaseWithLowerBounds:lower andUpper:upper upperIsTopOfStaircase:TRUE];
    static int i = 0;
    [_rooms addObject:staircase];
    [self addWalls:staircase.stairs name:[NSString stringWithFormat:@"Staircase%d",i]];
    [self addWallsFromStandardRoom:staircase];
}

- (void)addRoomToWall:(CC3MeshNode *)wall {
    NSArray *wallArray = [NSArray arrayWithObject:wall];
    [self addRoomsToWalls:wallArray];
}

- (void)addRoomsToWalls:(NSArray *)walls {
    NSArray *wallsCopy = [walls copy];
    //NSMutableArray *usableWalls = [NSMutableArray array];
    NSMutableArray *usableWallsOnUpper = [NSMutableArray array];
    NSMutableArray *usableWallsOnLower = [NSMutableArray array];
    bool lowerIsUsable, upperIsUsable;
    //CC3Vector min;
    //CC3Vector max;
    //int xdiff=0, zdiff=0;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;
    //float x0,x1,y0,y1,z0,z1;
    //for (CC3MeshNode *eachWall in invisibleWalls)
    for (CC3MeshNode *eachWall in wallsCopy)
    {
         
        lowerIsUsable = [self canBuildRoomBelowWall:eachWall ofSize:5];
        upperIsUsable = [self canBuildRoomAboveWall:eachWall ofSize:5];
        upperMinV = [self roomAboveWallMin:eachWall ofSize:5];
        upperMaxV = [self roomAboveWallMax:eachWall ofSize:5];
        lowerMinV = [self roomBelowWallMin:eachWall ofSize:5];
        lowerMaxV = [self roomBelowWallMax:eachWall ofSize:5];
        if (lowerIsUsable) {
            [usableWallsOnLower addObject:eachWall];
            finalMinV = lowerMinV;
            finalMaxV = lowerMaxV;
        }
        else if (upperIsUsable) {
            [usableWallsOnUpper addObject:eachWall];
            finalMinV = upperMinV;
            finalMaxV = upperMaxV;
        }
        if (lowerIsUsable || upperIsUsable) {
            [eachWall setVisible:FALSE];
            [self addRoomWithLower:finalMinV andUpper:finalMaxV];
        }
        
    }
    


}

- (void)addRoomWithLower:(CC3Vector)lower andUpper:(CC3Vector)upper {
    Room *room = [Room roomWithPoints:lower.x x1:upper.x y0:lower.y y1:upper.y z0:lower.z z1:upper.z];
    [_rooms addObject:room];
    [self addWallsFromStandardRoom:room];
    
}
- (bool)canBuildRoomBelowWall:(CC3MeshNode *)wall ofSize:(float)size {
    CC3Vector min = wall.localContentBoundingBox.minimum;
    CC3Vector max = wall.localContentBoundingBox.maximum;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;

    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    bool toReturn = FALSE;
    
    /*if (xdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(max.x,min.y,min.z);
        //upperMaxV = cc3v(max.x+5.f,max.y,max.z);
        lowerMinV = cc3v(min.x-size,min.y,min.z);
        lowerMaxV = cc3v(min.x,max.y,max.z);
    }
    else if (zdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,min.y,max.z);
        //upperMaxV = cc3v(max.x,max.y,max.z+5.f);
        lowerMinV = cc3v(min.x,min.y,min.z-size);
        lowerMaxV = cc3v(max.x,max.y,min.z);
    }*/
    lowerMinV = [self roomBelowWallMin:wall ofSize:size];
    lowerMaxV = [self roomBelowWallMax:wall ofSize:size];
    if (xdiff == 1 || ydiff ==1 || zdiff ==1) {
        toReturn = ![self roomExistsBetweenLower:lowerMinV andUpper:lowerMaxV];

    }
    return toReturn;

}


- (CC3Vector)roomAboveWallMin:(CC3MeshNode *)wall ofSize:(float)size {
    CC3Vector min = wall.localContentBoundingBox.minimum;
    CC3Vector max = wall.localContentBoundingBox.maximum;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;

    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    bool toReturn = FALSE;
    
    if (xdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        upperMinV = cc3v(max.x,min.y,min.z);
        //upperMaxV = cc3v(max.x+size,max.y,max.z);
        //lowerMinV = cc3v(min.x-size,min.y,min.z);
        //lowerMaxV = cc3v(min.x,max.y,max.z);
    }
    else if (ydiff ==1) {
        // Do TWO checks - one for each side using roomExists
        upperMinV = cc3v(min.x,max.y,min.z);
        //upperMaxV = cc3v(max.x,max.y+size,max.z);
        //lowerMinV = cc3v(min.x,min.y-size,min.z);
        //lowerMaxV = cc3v(max.x,min.y,max.z);
        
    }
    else if (zdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        upperMinV = cc3v(min.x,min.y,max.z);
        //upperMaxV = cc3v(max.x,max.y,max.z+size);
        //lowerMinV = cc3v(min.x,min.y,min.z-size);
        //lowerMaxV = cc3v(max.x,max.y,min.z);
    }
    else {
        upperMinV = min;
    }
    return upperMinV;
}

- (CC3Vector)roomAboveWallMax:(CC3MeshNode *)wall ofSize:(float)size {
    CC3Vector min = wall.localContentBoundingBox.minimum;
    CC3Vector max = wall.localContentBoundingBox.maximum;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;
    
    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    bool toReturn = FALSE;
    
    if (xdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(max.x,min.y,min.z);
        upperMaxV = cc3v(max.x+size,max.y,max.z);
        //lowerMinV = cc3v(min.x-size,min.y,min.z);
        //lowerMaxV = cc3v(min.x,max.y,max.z);
    }
    else if (ydiff ==1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,max.y,min.z);
        upperMaxV = cc3v(max.x,max.y+size,max.z);
        //lowerMinV = cc3v(min.x,min.y-size,min.z);
        //lowerMaxV = cc3v(max.x,min.y,max.z);
        
    }
    else if (zdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,min.y,max.z);
        upperMaxV = cc3v(max.x,max.y,max.z+size);
        //lowerMinV = cc3v(min.x,min.y,min.z-size);
        //lowerMaxV = cc3v(max.x,max.y,min.z);
    }
    else {
        upperMaxV = max;
    }
    return upperMaxV;
}

- (CC3Vector)roomBelowWallMin:(CC3MeshNode *)wall ofSize:(float)size {
    CC3Vector min = wall.localContentBoundingBox.minimum;
    CC3Vector max = wall.localContentBoundingBox.maximum;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;
    
    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    bool toReturn = FALSE;
    
    if (xdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(max.x,min.y,min.z);
        //upperMaxV = cc3v(max.x+size,max.y,max.z);
        lowerMinV = cc3v(min.x-size,min.y,min.z);
        //lowerMaxV = cc3v(min.x,max.y,max.z);
    }
    else if (ydiff ==1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,max.y,min.z);
        //upperMaxV = cc3v(max.x,max.y+size,max.z);
        lowerMinV = cc3v(min.x,min.y-size,min.z);
        //lowerMaxV = cc3v(max.x,min.y,max.z);
        
    }
    else if (zdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,min.y,max.z);
        //upperMaxV = cc3v(max.x,max.y,max.z+size);
        lowerMinV = cc3v(min.x,min.y,min.z-size);
        //lowerMaxV = cc3v(max.x,max.y,min.z);
    }
    else {
        lowerMinV = min;
    }
    return lowerMinV;
}

- (CC3Vector)roomBelowWallMax:(CC3MeshNode *)wall ofSize:(float)size {
    CC3Vector min = wall.localContentBoundingBox.minimum;
    CC3Vector max = wall.localContentBoundingBox.maximum;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;
    
    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    bool toReturn = FALSE;
    
    if (xdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(max.x,min.y,min.z);
        //upperMaxV = cc3v(max.x+size,max.y,max.z);
        //lowerMinV = cc3v(min.x-size,min.y,min.z);
        lowerMaxV = cc3v(min.x,max.y,max.z);
    }
    else if (ydiff ==1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,max.y,min.z);
        //upperMaxV = cc3v(max.x,max.y+size,max.z);
        //lowerMinV = cc3v(min.x,min.y-size,min.z);
        lowerMaxV = cc3v(max.x,min.y,max.z);
        
    }
    else if (zdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        //upperMinV = cc3v(min.x,min.y,max.z);
        //upperMaxV = cc3v(max.x,max.y,max.z+size);
        //lowerMinV = cc3v(min.x,min.y,min.z-size);
        lowerMaxV = cc3v(max.x,max.y,min.z);
    }
    else {
        lowerMaxV = max;
    }
    return lowerMaxV;
}



- (bool)canBuildRoomAboveWall:(CC3MeshNode *)wall ofSize:(float)size {
    CC3Vector min = wall.localContentBoundingBox.minimum;
    CC3Vector max = wall.localContentBoundingBox.maximum;
    CC3Vector upperMinV, upperMaxV, lowerMinV, lowerMaxV, finalMinV, finalMaxV;
    
    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    bool toReturn = FALSE;
    
    /*if (xdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        upperMinV = cc3v(max.x,min.y,min.z);
        upperMaxV = cc3v(max.x+size,max.y,max.z);
        //lowerMinV = cc3v(min.x-size,min.y,min.z);
        //lowerMaxV = cc3v(min.x,max.y,max.z);
    }
    else if (zdiff == 1) {
        // Do TWO checks - one for each side using roomExists
        upperMinV = cc3v(min.x,min.y,max.z);
        upperMaxV = cc3v(max.x,max.y,max.z+size);
        //lowerMinV = cc3v(min.x,min.y,min.z-size);
        //lowerMaxV = cc3v(max.x,max.y,min.z);
    }*/
    upperMinV = [self roomAboveWallMin:wall ofSize:size];
    upperMaxV = [self roomAboveWallMax:wall ofSize:size];
    if (xdiff == 1 || ydiff == 1 || zdiff ==1) {
        toReturn = ![self roomExistsBetweenLower:upperMinV andUpper:upperMaxV];
        
    }
    return toReturn;
    
}



- (bool)roomExistsBetweenLower:(CC3Vector)lower andUpper:(CC3Vector)upper {
    bool returnValue = FALSE;
    bool xCollision;
    bool yCollision;
    bool zCollision;
    for (Room *eachRoom in _rooms) {
        xCollision = FALSE;
        yCollision = FALSE;
        zCollision = FALSE;
        if (eachRoom.lowerBounds.x < upper.x)
            if (eachRoom.upperBounds.x > lower.x)
                xCollision = TRUE;
        if (eachRoom.lowerBounds.y < upper.y)
            if (eachRoom.upperBounds.y > lower.y)
                yCollision = TRUE;
        if (eachRoom.lowerBounds.z < upper.z)
            if (eachRoom.upperBounds.z > lower.z)
                zCollision = TRUE;
        if (xCollision && yCollision && zCollision) {
            returnValue = TRUE;
            break;
        }
    }
    return returnValue;
}

- (void)makeWallsInvisibleWhereAdjoiningRoomsExist {
    for (CC3MeshNode *eachWall in _walls) {
        if (eachWall.visible) {
            CC3Vector lower = eachWall.localContentBoundingBox.minimum;
            CC3Vector upper = eachWall.localContentBoundingBox.maximum;
            NSLog(@"Min: %f,%f,%f \nMax: %f,%f,%f", lower.x, lower.y, lower.z, upper.x,upper.y,upper.z);
            CC3Vector testLower, testUpper, testLower2, testUpper2;
            //float xdifff = upper.x-lower.x;
            int xdiff = (int)round((upper.x-lower.x)*10.f);
            int ydiff = (int)round((upper.y-lower.y)*10);

            int zdiff = (int)round((upper.z-lower.z)*10.f);
            if (xdiff == 1) {
                testLower = cc3v(lower.x-2.f,lower.y,lower.z);
                testUpper = cc3v(lower.x,upper.y,upper.z);
                testLower2 = cc3v(upper.x,lower.y,lower.z);
                testUpper2 = cc3v(upper.x+2.f,upper.y,upper.z);
            }
            else if (ydiff ==1) {
                testLower = cc3v(lower.x,lower.y-2.f,lower.z);
                testUpper = cc3v(upper.x,lower.y,upper.z);
                testLower2 = cc3v(lower.x,upper.y,lower.z);
                testUpper2 = cc3v(upper.x,upper.y+2.f,upper.z);
                
            }

            else if (zdiff == 1) {
                testLower = cc3v(lower.x,lower.y,lower.z-2.f);
                testUpper = cc3v(upper.x,upper.y,lower.z);
                testLower2 = cc3v(lower.x,lower.y,upper.z);
                testUpper2 = cc3v(upper.x,upper.y,upper.z+2.f);
                
            }
            if (xdiff == 1 || ydiff ==1 || zdiff == 1) {
                bool exists1, exists2;
                exists1 = [self roomExistsBetweenLower:testLower andUpper:testUpper];
                exists2 = [self roomExistsBetweenLower:testLower2 andUpper:testUpper2];
                if (exists1 && exists2) {
                    [eachWall setVisible:FALSE];
                }
            }

        }
    }
}

- (void)makeNewWallsWhereGapsExist {
    for (CC3MeshNode *eachWall in _walls) {
        if (![eachWall visible]) {
            CC3Vector lower = eachWall.localContentBoundingBox.minimum;
            CC3Vector upper = eachWall.localContentBoundingBox.maximum;
            NSLog(@"Min: %f,%f,%f \nMax: %f,%f,%f", lower.x, lower.y, lower.z, upper.x,upper.y,upper.z);
            CC3Vector testLower, testUpper, testLower2, testUpper2;
            //float xdifff = upper.x-lower.x;
            CC3MeshNode *closestWall = [self findClosestParallelWall:eachWall];
            if (closestWall != nil) {
                
            }
        }
    }

}

- (CC3MeshNode *)findClosestParallelWall:(CC3MeshNode *)toWall {
    CC3Vector min = toWall.localContentBoundingBox.minimum;
    CC3Vector max = toWall.localContentBoundingBox.maximum;
    int xdiff = (int)round((max.x-min.x)*10);
    int ydiff = (int)round((max.y-min.y)*10);
    int zdiff = (int)round((max.z-min.z)*10);
    int closest = 300;
    CC3MeshNode *closestWall = toWall;
    if (xdiff == 1) {
        
        for (CC3MeshNode *eachWall in _walls) {
            CC3Vector eaMin = eachWall.localContentBoundingBox.minimum;
            CC3Vector eaMax = eachWall.localContentBoundingBox.maximum;
            if (abs(eaMin.x-min.x)<closest) {
                if (eaMin.z < max.z)
                    if (eaMax.z > min.z) {
                        closest = abs(eaMin.x-min.x);
                        closestWall = eachWall;
                    }
                        
            }
        }
    }
    if (ydiff == 1) {
        
        for (CC3MeshNode *eachWall in _walls) {
            CC3Vector eaMin = eachWall.localContentBoundingBox.minimum;
            CC3Vector eaMax = eachWall.localContentBoundingBox.maximum;
            if (abs(eaMin.y-min.y)<closest) {
                if (eaMin.z < max.z)
                    if (eaMax.z > min.z) {
                        closest = abs(eaMin.y-min.y);
                        
                        closestWall = eachWall;
                    }
                
            }
        }
    }

    if (zdiff == 1) {
        
        for (CC3MeshNode *eachWall in _walls) {
            CC3Vector eaMin = eachWall.localContentBoundingBox.minimum;
            CC3Vector eaMax = eachWall.localContentBoundingBox.maximum;
            if (abs(eaMin.z-min.z)<closest) {
                if (eaMin.x < max.x)
                    if (eaMax.x > min.x) {
                        closest = abs(eaMin.z-min.z);
                    
                        closestWall = eachWall;
                    }
                
            }
        }
    }
    else {
        return nil;
    }

    if (closest == 300)
        return nil;
    else
        return closestWall;
}

- (void)addWalls:(NSArray *)walls name:(NSString *)wallsName {
    int i=0;
    for (Wall *eachWall in walls) {
        [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"%@%d", wallsName, i] startPosition:eachWall.lowerBounds endPosition:eachWall.upperBounds withTex:@"mercurymap.jpg"]];
        i++;
    }
}

- (void)addWallsFromStandardRoom:(Room *)room {
    NSString *n = [NSString stringWithFormat:@"%d", [_walls count]];
    [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"LeftWall%@",n] startPosition:room.llf endPosition:room.lub withTex:@"mercurymap.jpg"]];
    [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"FrontWall%@",n] startPosition:room.llf endPosition:room.ruf withTex:@"moonmap1k.jpg"]];
    [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"Floor%@",n] startPosition:room.llf endPosition:room.rlb withTex:@"sunmap.jpg"]];
    [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"Ceiling%@",n] startPosition:room.luf endPosition:room.rub withTex:@"sunmap.jpg"]];
    [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"RightWall%@",n] startPosition:room.rlf endPosition:room.rub withTex:@"mercurymap.jpg"]];
    [_walls addObject:[self addWallWithName:[NSString stringWithFormat:@"BackWall%@",n] startPosition:room.llb endPosition:room.rub withTex:@"moonmap1k.jpg"]];
}

- (void)addRotatedWallsFromStandardRoom:(Room *)room rotation:(CC3Vector)rotation {
    NSString *n = [NSString stringWithFormat:@"%d", [_walls count]];
    [_walls addObject:[self addRotatedWallWithName:[NSString stringWithFormat:@"LeftWall%@",n] startPosition:room.llf endPosition:room.lub withTex:@"sunmap.jpg" rotation:rotation]];
    [_walls addObject:[self addRotatedWallWithName:[NSString stringWithFormat:@"FrontWall%@",n] startPosition:room.llf endPosition:room.ruf withTex:@"sunmap.jpg" rotation:rotation]];
    [_walls addObject:[self addRotatedWallWithName:[NSString stringWithFormat:@"Floor%@",n] startPosition:room.llf endPosition:room.rlb withTex:@"sunmap.jpg" rotation:rotation]];
    [_walls addObject:[self addRotatedWallWithName:[NSString stringWithFormat:@"Ceiling%@",n] startPosition:room.luf endPosition:room.rub withTex:@"sunmap.jpg" rotation:rotation]];
    [_walls addObject:[self addRotatedWallWithName:[NSString stringWithFormat:@"RightWall%@",n] startPosition:room.rlf endPosition:room.rub withTex:@"sunmap.jpg" rotation:rotation]];
    [_walls addObject:[self addRotatedWallWithName:[NSString stringWithFormat:@"BackWall%@",n] startPosition:room.llb endPosition:room.rub withTex:@"moonmap1k.jpg" rotation:rotation]];
}


//SB: Set ROOM Vectors
/*- (void)setWallVectorsWithPoints:(float)x0 x1:(float)x1 y0:(float)y0 y1:(float)y1 z0:(float)z0 z1:(float)z1 {
    llf = cc3v(z0,y0,x0);
    rlf = cc3v(z0,y0,x1);
    luf = cc3v(z0,y1,x0);
    ruf = cc3v(z0,y1,x1);
    llb = cc3v(z1,y0,x0);
    rlb = cc3v(z1,y0,x1);
    lub = cc3v(z1,y1,x0);
    rub = cc3v(z1,y1,x1);

    
    llf = cc3v(x0,y0,z0);
    rlf = cc3v(x1,y0,z0);
    luf = cc3v(x0,y1,z0);
    ruf = cc3v(x1,y1,z0);
    llb = cc3v(x0,y0,z1);
    rlb = cc3v(x1,y0,z1);
    lub = cc3v(x0,y1,z1);
    rub = cc3v(x1,y1,z1);

}*/



#pragma mark Updating custom activity

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities before
 * any changes are applied to the transformMatrix of the 3D nodes in the scene.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateBeforeTransform: (CC3NodeUpdatingVisitor*) visitor {}

/**
 * This template method is invoked periodically whenever the 3D nodes are to be updated.
 *
 * This method provides your app with an opportunity to perform update activities after
 * the transformMatrix of the 3D nodes in the scen have been recalculated.
 *
 * For more info, read the notes of this method on CC3Node.
 */
-(void) updateAfterTransform: (CC3NodeUpdatingVisitor*) visitor {
	// If you have uncommented the moveWithDuration: invocation in the onOpen: method,
	// you can uncomment the following to track how the camera moves, and where it ends up,
	// in order to determine where to position the camera to see the entire scene.
//	LogDebug(@"Camera location is: %@", NSStringFromCC3Vector(activeCamera.globalLocation));
}


#pragma mark Scene opening and closing

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene is first displayed.
 *
 * This method is a good place to invoke one of CC3Camera moveToShowAllOf:... family
 * of methods, used to cause the camera to automatically focus on and frame a particular
 * node, or the entire scene.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onOpen {

	// Uncomment this line to have the camera move to show the entire scene. This must be done after the
	// CC3Layer has been attached to the view, because this makes use of the camera frustum and projection.
	// If you uncomment this line, you might also want to uncomment the LogDebug line in the updateAfterTransform:
	// method to track how the camera moves, and where it ends up, in order to determine where to position
	// the camera to see the entire scene.
//	[self.activeCamera moveWithDuration: 3.0 toShowAllOf: self];

	// Uncomment this line to draw the bounding box of the scene.
//	self.shouldDrawWireframeBox = YES;
}

/**
 * Callback template method that is invoked automatically when the CC3Layer that
 * holds this scene has been removed from display.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) onClose {}


#pragma mark Handling touch events 

/**
 * This method is invoked from the CC3Layer whenever a touch event occurs, if that layer
 * has indicated that it is interested in receiving touch events, and is handling them.
 *
 * Override this method to handle touch events, or remove this method to make use of
 * the superclass behaviour of selecting 3D nodes on each touch-down event.
 *
 * This method is not invoked when gestures are used for user interaction. Your custom
 * CC3Layer processes gestures and invokes higher-level application-defined behaviour
 * on this customized CC3Scene subclass.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) touchEvent: (uint) touchType at: (CGPoint) touchPoint {}

/**
 * This callback template method is invoked automatically when a node has been picked
 * by the invocation of the pickNodeFromTapAt: or pickNodeFromTouchEvent:at: methods,
 * as a result of a touch event or tap gesture.
 *
 * Override this method to perform activities on 3D nodes that have been picked by the user.
 *
 * For more info, read the notes of this method on CC3Scene.
 */
-(void) nodeSelected: (CC3Node*) aNode byTouchEvent: (uint) touchType at: (CGPoint) touchPoint {}

- (CC3MeshNode*) addPlanetSize: (CGFloat) s name: (NSString*) planetName position: (CC3Vector) p moons: (int) m withTex:(NSString*) tex
{
    CC3Node *orbitCentre = [CC3Node node]; //centre of solar system to rotate around
    [self addChild:orbitCentre];             //add this to 3d world
    
    CC3MeshNode *planet = [(CC3MeshNode*)[self getNodeNamed: @"Sphere"] copyWithName:planetName];
    planet.location = p;
    planet.scale = cc3v(s, s, s);
    if (tex!=nil)
    {
        [planet.material removeAllTextures];
        [planet.material addTexture:[CC3Texture textureFromFile:tex]];
    }
    [orbitCentre addChild:planet];           //add this to 3d world as child of spin centre
    
    //Make planet spin & orbit (this condition stops us spinning the sun
    if (p.x>0)
    {
        CGFloat inverseDist = 1000.f/p.x;   //things closer to the sun spin quicker
        CCActionInterval* planetSpin = [CC3RotateBy actionWithDuration: 1.0 rotateBy: cc3v(0.f, (inverseDist)+20.f, 0.f)];
        [planet runAction:[CCRepeatForever actionWithAction:planetSpin]];
        CCActionInterval* planetOrbit = [CC3RotateBy actionWithDuration: 1.0 rotateBy: cc3v(0.f, (inverseDist/10.f)+20.f, 0.f)];
        [orbitCentre runAction:[CCRepeatForever actionWithAction:planetOrbit]];
        
        //add a bunch of moons to this planet
        for (int i=0; i<m; i++)
        {
            CC3Node *spinCentre = [CC3Node nodeWithName:@"spinCentre"];
            CCActionInterval* spinAction = [CC3RotateBy actionWithDuration: 1.f rotateBy: cc3v(0.0, (CCRANDOM_0_1()*30.f)+20.f, 0.0)];
            [spinCentre runAction:[CCRepeatForever actionWithAction:spinAction]];
            [planet addChild:spinCentre];
            
            CC3MeshNode *moon = [(CC3MeshNode*)[self getNodeNamed: @"Sphere"] copy];
            [moon.material removeAllTextures];
            CC3Texture *moonTex = [CC3Texture textureFromFile:@"moonmap1k.jpg"];
            moon.material.texture = moonTex;
            moon.scale = cc3v(0.1f, 0.1f, 0.1f);
            moon.location = cc3v(0.f, 0.f, s+CCRANDOM_0_1());
            [spinCentre addChild:moon];
        }
    }
    return planet;
}

- (CC3MeshNode*) addWallWithName: (NSString*) wallName topLeftPosition: (CC3Vector) topLeft topRightPosition: (CC3Vector) topRight bottomLeftPosition: (CC3Vector) bottomLeft bottomRightPosition: (CC3Vector) bottomRight withTex:(NSString*) tex isVisible:(bool)isVisible {
    

}

- (CC3MeshNode*) addRotatedWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex rotation:(CC3Vector)rotation {
    return [self addRotatedWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex isVisible:(bool)TRUE rotation:rotation];

}


- (CC3MeshNode*) addRotatedWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex isVisible:(bool)isVisible rotation:(CC3Vector)rotation {

    //float max = s;
    
    // Depending on wall type adjust so that walls have thickness but still are within boundaries
    if ([wallName hasPrefix:@"Ceiling"]) {
        start = cc3v(start.x,start.y-0.1f,start.z);
        
    }
    else if ([wallName hasPrefix:@"Floor"]) {
        end = cc3v(end.x,end.y+0.1f,end.z);
    }
    else if ([wallName hasPrefix:@"RightWall"]) {
        start = cc3v(start.x-0.1f,start.y,start.z);
    }
    else if ([wallName hasPrefix:@"LeftWall"]) {
        end = cc3v(end.x+0.1f,end.y,end.z);
    }
    else if ([wallName hasPrefix:@"BackWall"]) {
        start = cc3v(start.x,start.y,start.z-0.1f);
    }
    else if ([wallName hasPrefix:@"FrontWall"]) {
        end = cc3v(end.x,end.y,end.z+0.1f);
    }
    else {
        // Inner wall within a room, rather than on outside
        if (end.x-start.x < 0.1f) {
            if ([self roomExistsBetweenLower:start andUpper:cc3v(start.x+0.1f,end.y,end.z)]) {
                end = cc3v(end.x+0.1f, end.y, end.z);
            }
            else {
                start = cc3v(start.x-0.1f, start.y, start.z);
            }
        }
        if (end.y-start.y < 0.1f) {
            if ([self roomExistsBetweenLower:start andUpper:cc3v(start.x+0.1f,end.y,end.z)]) {
                end = cc3v(end.x, end.y+0.1f, end.z);
            }
            else {
                start = cc3v(start.x, start.y-0.1f, start.z);
            }
        }
        if (end.x-start.x < 0.1f) {
            if ([self roomExistsBetweenLower:start andUpper:cc3v(start.x+0.1f,end.y,end.z)]) {
                end = cc3v(end.x, end.y, end.z+0.1f);
            }
            else {
                start = cc3v(start.x, start.y, start.z-0.1f);
            }
        }
    }
    
    
    CC3BoxNode *brickWall = [[CC3BoxNode nodeWithName:tex] copyWithName:wallName];
    //brickWall = [DoorMeshNode nodeWithName: kBrickWallName];
	brickWall.isTouchEnabled = YES;
	//[brickWall populateAsSolidBox: CC3BoundingBoxMake(-1.5, 0, -0.3, 1.5, 2.5, 0.3)];
    // , h,
	[brickWall populateAsSolidBox: CC3BoundingBoxMake(start.x, start.y, start.z, end.x, end.y, end.z)];
	brickWall.uniformScale = 40.0;
	
	// Add a texture to the wall and repeat it. This creates a material automatically.
	brickWall.texture = [CC3Texture textureFromFile: tex];
	[brickWall repeatTexture: (ccTex2F){4, 2}];
	brickWall.ambientColor = kCCC4FWhite;			// Increase the ambient reflection so the backside is visible
	
	// Start with the wall in the open position
	//brickWall.isOpen = YES;
	//brickWall.location = cc3v(0.1f, 0.1f, 0.1f);
    brickWall.visible = isVisible;
	brickWall.location = start;
	//brickWall.rotation = cc3v(0, -45, 0);
	brickWall.rotation = rotation;
    if ([wallName hasPrefix:@"Floor"]) {
        //brickWall.rotation = cc3v(0,0,0);
        //brickWall.targetLocation = cc3v(-30.0,-30.0,-30.0);
        //brickWall.shouldTrackTarget = YES;
    }
	//[self addChild: brickWall];
    
    CC3Node *orbitCentre = [CC3Node node]; //centre of solar system to rotate around
//wall
    //[brickWall setRotationAxis:end];
    //[brickWall setRotationAngle:50.f];
    CC3Rotator *rotatoooor = brickWall.rotator;
    CC3Vector ro = rotatoooor.rotation;
    float roA = rotatoooor.rotationAngle;
    CC3Vector axis = rotatoooor.rotationAxis;
    if (!CC3VectorIsZero(rotation)) {
        [orbitCentre setLocation:CC3VectorAverage(start, end)]; // rotate around middle of
        //[orbitCentre setLocation:cc3v(0.0,0.0,0.0)];
        brickWall.location = CC3VectorDifference(CC3VectorAverage(start, end), start);
        NSLog(@"");
    }

    [self addChild:orbitCentre];             //add this to 3d world
    [orbitCentre addChild:brickWall];
    return brickWall;

    
}

- (CC3MeshNode *) addRotatedWallBetweenTwoVectors: (CC3Vector)min max:(CC3Vector)max {
    // Assume this is a floor or ceiling
    double zdiff = max.z-min.z;
    double xdiff = max.x-min.x;
    double an1 = (atan2(zdiff, xdiff) * (180.0 / M_PI))/4.0;
    CC3Vector avg = CC3VectorAverage(min, max);
    CC3Vector v1 = cc3v(min.x,min.y-0.1,min.z); // was avg.y
    CC3Vector v2 = cc3v(max.x,min.y,max.z); // was avg.y
    //double an2 = atan2(v1.z-v1.x, first1.z-first1.x) * (180 / M_PI);
    CC3Vector rotation = cc3v(-an1,0.0,0.0);
    //rotation = cc3v(rotation.x*3.0,rotation.y*3.0,rotation.z*3.0);
    //rotation = cc3v(135,23,47);
    CC3MeshNode *toReturn = [self addRotatedWallWithName:@"thidswall" startPosition:v1 endPosition:v2 withTex:@"moonmap1k.jpg" isVisible:TRUE rotation:rotation];
    CC3MeshNode *base = [self addRotatedWallWithName:@"thidswall" startPosition:v1 endPosition:v2 withTex:@"moonmap1k.jpg" isVisible:TRUE rotation:cc3v(0.0,0.0,0.0)];
    return toReturn;
    
}

- (CC3MeshNode *) addRotatedWallBetweenFourVectors: (CC3Vector)first1 second:(CC3Vector)first2 third:(CC3Vector)second1 fourth:(CC3Vector)second2 {
    // Create a wall between two walls and rotate
    // Avg of first1, second1
    // Need to change this to angle
    // DON'T USE
    CC3Vector v1 = CC3VectorAverage(first1, second1);
    CC3Vector v2 = CC3VectorAverage(first2, second2);
    CC3Vector v3 = CC3VectorAverage(first1, first2);
    CC3Vector v4 = CC3VectorAverage(second1, second2);
    CC3Vector diff = CC3VectorDifference(first1, v1);
    [self logVector:v1];
    [self logVector:v2];
    double an1 = atan2(second1.z-second1.x, first1.z-first1.x) * (180 / M_PI);
    double an2 = atan2(v1.z-v1.x, first1.z-first1.x) * (180 / M_PI);
    CC3Vector rotation = cc3v(-an2,0.0,0.0);
    //rotation = cc3v(rotation.x*3.0,rotation.y*3.0,rotation.z*3.0);
    //rotation = cc3v(135,23,47);
    CC3MeshNode *toReturn = [self addRotatedWallWithName:@"thidswall" startPosition:v1 endPosition:v2 withTex:@"moonmap1k.jpg" isVisible:TRUE rotation:rotation];
    return toReturn;
}

- (CC3MeshNode*) addWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex {
    return [self addWallWithName:wallName startPosition:start endPosition:end withTex:tex isVisible:TRUE];
}

- (CC3MeshNode*) addWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex isVisible:(bool)isVisible {
    return [self addRotatedWallWithName: (NSString*) wallName startPosition: (CC3Vector) start endPosition: (CC3Vector) end withTex:(NSString*) tex isVisible:(bool)isVisible rotation:cc3v(0.f,0.f,0.f)];
    
}


- (void) viewNextPlanet
{
    /* Ropey camera controls:
     - each call of functions cycles through planets or adopt a zoomed out view
     */
    
    //Get our camera
    CC3Camera *cam = (CC3Camera*) [self getNodeNamed:@"Camera"];
    int viewIndex=0;
    //is the camera looking at something?
    if ([_planets containsObject:cam.target])
    {
        //if so (and should always be) look increment our viewing index
        viewIndex = [_planets indexOfObject:cam.target]+1;
    }
    
    //if out viewing index is not past the end of the planets array we'll look at the next planet
    CC3Node *nextTarget = nil;
    CC3Vector v;
    int maxView = [_planets count] + [_walls count];
    if (viewIndex<[_planets count])
    {
        //select the planet to focus on
        nextTarget = [_planets objectAtIndex:viewIndex];
        
        //derive a point 5 units directly in towards the sun from the planets current location
        CC3Vector scaledVec = CC3VectorScaleUniform(CC3VectorNormalize(nextTarget.globalLocation), -5.f);
        v = CC3VectorAdd(nextTarget.globalLocation, scaledVec);
    }
    
    // If our view index is outside the planet array we'll look at the sun
    /*else if (viewIndex<maxView)
    {
        viewIndex = viewIndex - [_planets count];
        //select the planet to focus on
        nextTarget = [_walls objectAtIndex:viewIndex];
        
        //derive a point 5 units directly in towards the sun from the planets current location
        CC3Vector scaledVec = CC3VectorScaleUniform(CC3VectorNormalize(nextTarget.globalLocation), -5.f);
        v = CC3VectorAdd(nextTarget.globalLocation, scaledVec);
    }*/
    else {
        nextTarget = [self getNodeNamed:@"Sun"];
        //nextTarget = [self getNodeNamed:@"BrickWall"];
        v = cc3v(0.f, 20.f, 60.f);
        
    }
    
    //stop camera tracking whilst we move it
    cam.shouldTrackTarget=NO;
    
    //action 1 - pan around to focus on the new planet
    id panCam = [CC3RotateToLookAt actionWithDuration:1.f targetLocation:nextTarget.globalLocation];
    
    //action 2 - set the new planet as a target and start tracking it
    id changeTarget = [CCCallBlock actionWithBlock:^(){
        cam.target = nextTarget;
        cam.shouldTrackTarget=YES;
    }];
    
    //action 3 - move the camera to the point we previously derived near where the planet was
    id moveCam = [CC3MoveTo actionWithDuration:2.f moveTo:v];
    
    //Run the three actions in sequence, it should pan, track then move the camera
    [cam runAction:[CCSequence actions:panCam, changeTarget, moveCam, nil]];
    //[cam runAction:[CCSequence actions:moveCam, nil]];
}


- (void) moveCamera:(CC3Vector)toVector {
    //Get our camera
    //CC3Camera *cam = (CC3Camera*) [self getNodeNamed:@"Camera"];
    CC3Camera *cam = self.activeCamera;
    // Get rotation and take angle into account

    id moveCam = [CC3MoveTo actionWithDuration:0.5f moveTo:toVector];
    [cam runAction:moveCam];
}

- (void) panCamera:(CC3Vector)byVector {
    //CC3Camera *cam = (CC3Camera*) [self getNodeNamed:@"Camera"];
    CC3Camera *cam = self.activeCamera;
    id panCam = [CC3RotateBy actionWithDuration:1.f rotateBy:byVector];
    id recordAction = [CCCallBlock actionWithBlock:^(){
        CC3Vector r = cam.rightDirection;
        CC3Vector gr = cam.globalRightDirection;
        NSLog(@"Global Right: %f,%f,%f\n Right: %f,%f,%f", gr.x, gr.y, gr.z, r.x,r.y,r.z);
        CC3Rotator *rotatoooor = cam.rotator;
        CC3Vector ro = rotatoooor.rotation;
        float roA = rotatoooor.rotationAngle;
        NSLog(@"Rotation: %f,%f,%f Angle: %f", ro.x,ro.y,ro.z, roA);
    }];

    [cam runAction:[CCSequence actions:recordAction, panCam,recordAction, nil]];
}

@end

