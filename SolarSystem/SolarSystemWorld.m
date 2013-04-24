//
//  SolarSystemWorld.m
//  SolarSystem
//
//  Created by Mark Newton on 27/03/13.
//
//

#import "SolarSystemWorld.h"
/*
@implementation SolarSystemWorld

-(void) initializeWorld {
    
    // Create the camera
    CC3Camera* cam = [CC3Camera nodeWithName: @"Camera"];
    cam.location = cc3v(0.f, 20.f, 60.f);
    [self addChild: cam];
    
    [self addContentFromPODResourceFile: @"earth.pod"];
    [self createGLBuffers];
    [self releaseRedundantData];
    
    //create Sun
    CC3MeshNode *sun = [self addPlanetSize:6.f name:@"Sun" position:cc3v(0.f,0.f,0.f) moons:0 withTex:@"sunmap.jpg"];
    sun.material.emissionColor = ccc4FFromccc4B(ccc4(255, 255, 255, 255));  //make the sun sunny
    
    //Add lighting - first sunlight radiating outwards
    CC3Light *sunlight = [CC3Light nodeWithName:@"SunLight"];
    sunlight.isDirectionalOnly=NO;
    [self addChild:sunlight];
    
    //Add the planets
    _planets = [[NSMutableArray alloc] init];
    [_planets addObject:[self addPlanetSize:0.5 name:@"Mercury" position:cc3v(14.f,0.f,0.f) moons:0 withTex:@"mercurymap.jpg"]];
    [_planets addObject:[self addPlanetSize:0.7 name:@"Venus" position:cc3v(18.f,0.f,0.f) moons:0  withTex:@"venusmap.jpg"]];
    [_planets addObject:[self addPlanetSize:1.f name:@"Earth" position:cc3v(22.f,0.f,0.f) moons:1 withTex:nil]];
    [_planets addObject:[self addPlanetSize:1.1f name:@"Mars" position:cc3v(30.f,0.f,0.f) moons:2 withTex:@"mars_1k_color.jpg"]];
    
    //And make the camera track our Earth node
    CC3Node *earth = (CC3Node*) [self getNodeNamed:@"Earth"];
    cam.target = earth;
    cam.shouldTrackTarget=YES;
}

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

- (void) viewNextPlanet
{
    // Ropey camera controls:
     //- each call of functions cycles through planets or adopt a zoomed out view
     
    
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
    if (viewIndex<[_planets count])
    {
        //select the planet to focus on
        nextTarget = [_planets objectAtIndex:viewIndex];
        
        //derive a point 5 units directly in towards the sun from the planets current location
        CC3Vector scaledVec = CC3VectorScaleUniform(CC3VectorNormalize(nextTarget.globalLocation), -5.f);
        v = CC3VectorAdd(nextTarget.globalLocation, scaledVec);
    }
    
    // If our view index is outside the planet array we'll look at the sun
    else
    {
        nextTarget = [self getNodeNamed:@"Sun"];
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
    
}

@end*/
