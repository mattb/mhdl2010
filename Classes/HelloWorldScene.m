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
		
		emitters = [[NSMutableArray arrayWithCapacity:0] retain];
		activeEmitters = [[NSMutableArray arrayWithCapacity:10] retain];
		
		for(int i = 0; i<100; i++) {
			[emitters addObject:[[CCParticleFireworks node] retain]];
		}

		for(CCParticleSystem *emitter in emitters) {
			[emitter stopSystem];
			[self addChild: emitter];
		}
	}
	return self;
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	for(UITouch *touch in touches) {
		CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: [touch locationInView:touch.view]];
	
		CCParticleSystem *emitter = [self nearestEmitterTo:location from:emitters];
		[emitter resetSystem];
		[activeEmitters addObject:emitter];
		emitter.position = location;
	}
	NSLog(@"Active emitters: %d", [activeEmitters count]);
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	if([activeEmitters count] > 0) {
		for(UITouch *touch in touches) {
			CGPoint location = [[CCDirector sharedDirector] 
								convertToGL: [touch locationInView:touch.view]];
			
			CCParticleSystem *emitter = [self nearestEmitterTo:location from:activeEmitters];
			emitter.position = location;
		}
	}
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for(CCParticleSystem *emitter in activeEmitters) {
		[emitter stopSystem];
	}
	[activeEmitters removeAllObjects];
}

- (CCParticleSystem *)nearestEmitterTo:(CGPoint)location from:(NSArray *)collection {
	CCParticleSystem *choice = [collection objectAtIndex:0];
	for(CCParticleSystem *emitter in collection) {
		int dcx = choice.position.x - location.x;
		int dcy = choice.position.y - location.y;
		int dex = emitter.position.x - location.x;
		int dey = emitter.position.y - location.y;
		if((dcx*dcx + dcy*dcy) > (dex*dex + dey*dey)) {
		   choice = emitter;
		}
	}
	return choice;
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
