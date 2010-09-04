//
//  HelloWorldLayer.m
//  mhdl2010
//
//  Created by Matt Biddulph on 04/09/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"

// HelloWorld implementation
@implementation HelloWorld

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		self.isTouchEnabled = YES;
		
		for(int i = 0; i<10; i++) {
			[emitters addObject:[CCParticleFireworks node]];
		}
		for(emitter in emitters) {
			[self addChild: emitter];
		}
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[emitter resetSystem];
	UITouch *touch = [touches anyObject];
	
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: [touch locationInView:touch.view]];
	emitter.position = location;
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
	
	CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: [touch locationInView:touch.view]];
	emitter.position = location;
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[emitter stopSystem];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
