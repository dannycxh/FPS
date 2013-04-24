/**
 *  SolarSystemLayer.h
 *  SolarSystem
 *
 *  Created by Mark Newton on 27/03/13.
 *  Copyright __MyCompanyName__ 2013. All rights reserved.
 */


#import "CC3Layer.h"


/** A sample application-specific CC3Layer subclass. */
@interface FPSLayer : CC3Layer {
    CCLabelTTF *_label;
    CCMenuItem *_plusItem;
    CCMenuItem *_minusItem;
    CCMenuItem *_leftItem;
    CCMenuItem *_rightItem;
    CCMenuItem *_upItem;
    CCMenuItem *_downItem;
}

@end
