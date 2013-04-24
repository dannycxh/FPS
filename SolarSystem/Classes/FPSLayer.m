/**
 *  SolarSystemLayer.m
 *  SolarSystem
 *
 *  Created by Mark Newton on 27/03/13.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */

#import "FPSLayer.h"
#import "FPSScene.h"
//#import "SolarSystemWorld.h"

@implementation FPSLayer

float mx = 90.f;
float mp = 45.f;

- (void)dealloc {
    [_label release];
    _label = nil;
    [_plusItem release];
    _plusItem = nil;
    [_minusItem release];
    _minusItem = nil;
    [_leftItem release];
    _leftItem = nil;
    [_rightItem release];
    _rightItem = nil;
    [_upItem release];
    _upItem = nil;
    [_downItem release];
    _downItem = nil;
    [super dealloc];
}


/**
 * Override to set up your 2D controls and other initial state.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) initializeControls
{
    self.isTouchEnabled=YES;
    
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    // Create a label for display purposes
    _label = [[CCLabelTTF labelWithString:@"Last button: None"
                               dimensions:CGSizeMake(320, 50) alignment:UITextAlignmentCenter
                                 fontName:@"Arial" fontSize:32.0] retain];
    _label.position = ccp(winSize.width/2,
                          winSize.height-(_label.contentSize.height/2));
    //CCNode *node = (CCNode *)_label;
    [self addChild:_label];
    
    // Standard method to create a button
    CCMenuItem *starMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(starButtonTapped:)];
    starMenuItem.position = ccp(60, 60);

    CCMenuItem *leftMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(leftButtonTapped:)];
    leftMenuItem.position = ccp(120, 60);
    CCMenuItem *rightMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(rightButtonTapped:)];
    rightMenuItem.position = ccp(180, 60);
    CCMenuItem *upMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(upButtonTapped:)];
    upMenuItem.position = ccp(240, 60);
    CCMenuItem *downMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(downButtonTapped:)];
    downMenuItem.position = ccp(300, 60);
    CCMenuItem *plusMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(plusButtonTapped:)];
    plusMenuItem.position = ccp(360, 60);
    CCMenuItem *minusMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(minusButtonTapped:)];
    minusMenuItem.position = ccp(420, 60);

    CCMenuItem *panRightMenuItem = [CCMenuItemImage
                                itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                target:self selector:@selector(panRightButtonTapped:)];
    panRightMenuItem.position = ccp(60, 120);
    CCMenuItem *panLeftMenuItem = [CCMenuItemImage
                                 itemFromNormalImage:@"ButtonStar.png" selectedImage:@"ButtonStarSel.png"
                                 target:self selector:@selector(panLeftButtonTapped:)];
    panLeftMenuItem.position = ccp(120, 120);

    
    CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, leftMenuItem, rightMenuItem, upMenuItem, downMenuItem, plusMenuItem, minusMenuItem,panLeftMenuItem, panRightMenuItem, nil];
    starMenu.position = CGPointZero;
    [self addChild:starMenu];
}

- (void)starButtonTapped:(id)sender {
    [_label setString:@"Last button: *"];
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    CC3Camera *cam = (CC3Camera*)[solsys getNodeNamed:@"Camera"];
    CC3Camera *aboveCam = (CC3Camera*)[solsys getNodeNamed:@"AboveCam"];
    
    if ([solsys.activeCamera.name hasPrefix:@"AboveCam"]) {
        [solsys setActiveCamera:cam];
    }
    else {
        [solsys setActiveCamera:aboveCam];
    }
    [solsys.activeCamera markProjectionDirty];
}

- (CC3Vector)getCurrentCameraLocation {
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    //CC3Camera *cam = (CC3Camera*) [solsys getNodeNamed:@"Camera"];
    CC3Camera *cam = solsys.activeCamera;
    CC3Vector oldVector =  cam.globalLocation;
    CC3Vector right = cam.rightDirection;
    CC3Vector gright = cam.globalRightDirection;
    return oldVector;
}

- (CC3Vector)getCurrentCameraRotation {
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    //CC3Camera *cam = (CC3Camera*) [solsys getNodeNamed:@"Camera"];
    CC3Camera *cam = solsys.activeCamera;
    CC3Vector oldVector =  cam.globalRotation;
    return oldVector;
}

- (CC3Vector)getRotatedVector:(CC3Vector)toRotate {
    CC3Vector rotation = [self getCurrentCameraRotation];
    rotation = cc3v(0.f, rotation.y,0.f);
    CC3Vector rotatedVector = CC3VectorAdd(toRotate, rotation);
    return rotatedVector;
}


- (void)moveCamera:(CC3Vector)toVector {
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    [solsys moveCamera:toVector];
}

- (void)panCamera:(CC3Vector)toVector {
    //CC3Vector before = [self getCurrentCameraRotation];
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    [solsys panCamera:toVector];
    //CC3Vector after = [self getCurrentCameraRotation];
}


- (void)panLeftButtonTapped:(id)sender {
    //CC3Vector oldVector = [self getCurrentCameraTarget];
    float x = 0-mp;
    CC3Vector byVector = cc3v(0.f,x,0.f);
    [self panCamera:byVector];
}

- (void)panRightButtonTapped:(id)sender {
    //CC3Vector oldVector = [self getCurrentCameraTarget];
    float x = mp;
    CC3Vector byVector = cc3v(0.f,x,0.f);
    [self panCamera:byVector];
}


- (void)leftButtonTapped:(id)sender {
    [_label setString:@"Last button: <-"];
    CC3Vector oldVector =  [self getCurrentCameraLocation];
    //float x = oldVector.x-mx;
    CC3Vector newVector = [self calculateNewLeftRightPoint:-mx];
    
    /*CC3Vector relativeToRotate = cc3v(x,0.f,0.f);
    CC3Vector rotation = [self getCurrentCameraRotation];
    CC3Vector relativeRotated = CC3VectorAdd(relativeToRotate, rotation);
    CC3Vector final = CC3VectorAdd(oldVector, relativeRotated);
    //CC3Vector rotatedVector = [self getRotatedVector:newVector];*/
    //CC3Vector right =
    [self moveCamera:newVector];
}

- (void)rightButtonTapped:(id)sender {
    [_label setString:@"Last button: ->"];
    CC3Vector oldVector =  [self getCurrentCameraLocation];
    //float x = oldVector.x+mx;
    CC3Vector newVector = [self calculateNewLeftRightPoint:mx];
    /*CC3Vector relativeToRotate = cc3v(x,0.f,0.f);
    CC3Vector rotation = [self getCurrentCameraRotation];
    CC3Vector relativeRotated = CC3VectorAdd(relativeToRotate, rotation);
    CC3Vector final = CC3VectorAdd(oldVector, relativeRotated);
    //CC3Vector rotatedVector = [self getRotatedVector:newVector];*/
    //CC3Vector right =
    [self moveCamera:newVector];
    /*
     x = x cos A - y sin A
     y = x sin A + y cos A
     */
    float x1, y1;
    //x1 = oldVector.x * sinf(<#float#>)
    
}
- (void)upButtonTapped:(id)sender {
    [_label setString:@"Last button: /\\"];
    CC3Vector oldVector =  [self getCurrentCameraLocation];
    float y = oldVector.y+mx;
    CC3Vector newVector = cc3v(oldVector.x,y,oldVector.z);
    [self moveCamera:newVector];
}
- (void)downButtonTapped:(id)sender {
    [_label setString:@"Last button: \\/"];
    CC3Vector oldVector =  [self getCurrentCameraLocation];
    float y = oldVector.y-mx;
    CC3Vector newVector = cc3v(oldVector.x,y,oldVector.z);
    [self moveCamera:newVector];
}
- (void)plusButtonTapped:(id)sender {
    [_label setString:@"Last button: +"];
    //CC3Vector oldVector =  [self getCurrentCameraLocation];
    //float z = oldVector.z+mx;
    CC3Vector newVector = [self calculateNewForwardBackPoint:mx];
    [self moveCamera:newVector];
}
- (void)minusButtonTapped:(id)sender {
    [_label setString:@"Last button: -"];
    //CC3Vector oldVector =  [self getCurrentCameraLocation];
    //float z = oldVector.z-mx;
    CC3Vector newVector = [self calculateNewForwardBackPoint:-mx];
    [self moveCamera:newVector];
}

- (CC3Vector)calculateNewLeftRightPoint:(float)distance {
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    //CC3Camera *cam = (CC3Camera*) [solsys getNodeNamed:@"Camera"];
    CC3Camera *cam = solsys.activeCamera;
    CC3Rotator *rotatoooor = cam.rotator;
    CC3Vector ro = rotatoooor.rotation;
    CC3Vector loc = cam.globalLocation;
    float roA = rotatoooor.rotationAngle;
    // Bug in rotationAngle? Need this as 315 angle reports as 45
    int roI = ro.y;
    int diff = roA - roI;
    if (diff == 0 && roI == 45)
        roA = 315;

    NSLog(@"Location: %f,%f,%f", loc.x, loc.y,loc.z);
    NSLog(@"Rotation: %f,%f,%f Angle: %f", ro.x,ro.y,ro.z, roA);
    double theta = roA * M_PI/180;
    double sinA = sin(theta);
    double cosA = cos(theta);
    /*
     x = d cos a
     y = d sin a
     */
    double newX = distance*cosA + loc.x;
    double newZ = distance*sinA + loc.z;
    CC3Vector newTo = cc3v(newX, loc.y, newZ);
    NSLog(@"To: %f,%f,%f \nNewTo: %f,%f,%f", loc.x, loc.y, loc.z, newTo.x, newTo.y, newTo.z);
    return newTo;
}

- (CC3Vector)calculateNewForwardBackPoint:(float)distance {
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    //CC3Camera *cam = (CC3Camera*) [solsys getNodeNamed:@"Camera"];
    CC3Camera *cam = solsys.activeCamera;
    
    CC3Rotator *rotatoooor = cam.rotator;
    CC3Vector ro = rotatoooor.rotation;
    CC3Vector loc = cam.globalLocation;
    float roA = rotatoooor.rotationAngle-90;
    // Bug in rotationAngle? Need this as 315 angle reports as 45
    int roI = ro.y;
    int diff = roA+90 - roI;
    if (diff == 0 && roI == 45)
        roA = 315-90;

    NSLog(@"Location: %f,%f,%f", loc.x, loc.y,loc.z);
    NSLog(@"Rotation: %f,%f,%f Angle: %f", ro.x,ro.y,ro.z, roA);
    double theta = roA * M_PI/180;
    double sinA = sin(theta);
    double cosA = cos(theta);
    /*
     x = d cos a
     y = d sin a
     */
    double newX = distance*cosA + loc.x;
    double newZ = distance*sinA + loc.z;
    CC3Vector newTo = cc3v(newX, loc.y, newZ);
    NSLog(@"To: %f,%f,%f \nNewTo: %f,%f,%f", loc.x, loc.y, loc.z, newTo.x, newTo.y, newTo.z);
    return newTo;
}

#pragma mark Updating layer

/**
 * Override to perform set-up activity prior to the scene being opened
 * on the view, such as adding gesture recognizers.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onOpenCC3Layer {}

/**
 * Override to perform tear-down activity prior to the scene disappearing.
 *
 * For more info, read the notes of this method on CC3Layer.
 */
-(void) onCloseCC3Layer {}

/**
 * The ccTouchMoved:withEvent: method is optional for the <CCTouchDelegateProtocol>.
 * The event dispatcher will not dispatch events for which there is no method
 * implementation. Since the touch-move events are both voluminous and seldom used,
 * the implementation of ccTouchMoved:withEvent: has been left out of the default
 * CC3Layer implementation. To receive and handle touch-move events for object
 * picking, uncomment the following method implementation.
 */
/*
-(void) ccTouchMoved: (UITouch *)touch withEvent: (UIEvent *)event {
	[self handleTouch: touch ofType: kCCTouchMoved];
}
 */


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return YES; //makes the layer swallow the touch
}

- (void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    FPSScene *solsys = (FPSScene*)self.cc3Scene;
    [solsys viewNextPlanet];
}

@end
