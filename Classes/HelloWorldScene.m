//
//  HelloWorldLayer.m
//  mhdl2010
//
//  Created by Matt Biddulph on 04/09/2010.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

// Import the interfaces
#import "HelloWorldScene.h"

@implementation Track
-(id) init
{
	id t = [self initWithTotalParticles:20];
	startColor.r = ((float)arc4random()) / RAND_MAX / 3;
	startColor.g = ((float)arc4random()) / RAND_MAX / 3;
	startColor.b = ((float)arc4random()) / RAND_MAX / 3;
	startSize = 10.0 + (arc4random() % 30);
	[self runAction:[CCRepeatForever actionWithAction:
					 [CCSequence actions: 
					   [CCScaleTo actionWithDuration:0.5f-0.01f scale:1.5f], 
					   [CCScaleTo actionWithDuration:0.01f scale:1.0f],
					   nil]]];
	return t;
}

@end

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
		
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		
		emitters = [[NSMutableArray arrayWithCapacity:0] retain];
		activeEmitters = [[NSMutableArray arrayWithCapacity:10] retain];
		
		for(int i = 0; i<100; i++) {
			[emitters addObject:[[Track node] retain]];
		}

		for(CCParticleSystem *emitter in emitters) {
			emitter.position = CGPointMake(arc4random() % (int)size.width, arc4random() % (int)size.height);
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
