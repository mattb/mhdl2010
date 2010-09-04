//
//  HelloWorldLayer.h
//  mhdl2010
//
//  Created by Matt Biddulph on 04/09/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "JSON.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	NSMutableArray	*emitters;
	NSMutableArray *activeEmitters;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;
-(CCParticleSystem *)nearestEmitterTo:(CGPoint)location from:(NSArray *)collection;

@end

@interface Track : CCParticleSun
{
}
@end