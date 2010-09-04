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
	startColor.r = ((float)arc4random()) / RAND_MAX / 8;
	startColor.g = ((float)arc4random()) / RAND_MAX / 8;
	startColor.b = ((float)arc4random()) / RAND_MAX / 8;
	startSize = 10.0 + (arc4random() % 30);
	float d = 60.0 / (30 * (1 + arc4random() % 4));
	[self runAction:[CCRepeatForever actionWithAction:
					 [CCSequence actions: 
					   [CCScaleTo actionWithDuration:d-0.01f scale:1.5f], 
					   [CCScaleTo actionWithDuration:0.01f scale:1.0f],
					   nil]]];
	return t;
}
@synthesize label;
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
		idx = [NSNumber numberWithInt:0];
				
		emitters = [[NSMutableArray arrayWithCapacity:0] retain];
		activeEmitters = [[NSMutableArray arrayWithCapacity:10] retain];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://test.hackdiary.com/"]];
		GDataHTTPFetcher* myFetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
		[myFetcher beginFetchWithDelegate:self
						didFinishSelector:@selector(myFetcher:finishedWithData:)
						  didFailSelector:@selector(myFetcher:failedWithError:)];
	}
	return self;
}

- (void)myFetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data {
	NSLog(@"Data!");
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	tracks = [[json JSONValue] retain];
	NSArray *characs = [tracks objectForKey:@"characteristics"];
	NSArray *echoes = [tracks objectForKey:@"echo"];
	for(int i = 0; i<[characs count]; i++) {
		NSArray *charac = [characs objectAtIndex:i];
		NSDictionary *echo = [echoes objectAtIndex:i];
		Track *t = [[Track node] retain];
		t.position = CGPointMake(4 * [[charac objectAtIndex:1] floatValue], 2 * [[charac objectAtIndex:4] floatValue]);

		NSString *title = [echo objectForKey:@"title"];
		NSLog(@"%@", title);
		CCLabelTTF *label = [CCLabelTTF labelWithString:title fontName:@"Helvetica" fontSize:16];
		label.position = CGPointMake(4 * [[charac objectAtIndex:1] floatValue], 2 * [[charac objectAtIndex:4] floatValue]);
		[emitters addObject:t];
		[self addChild:t];
		[self addChild:label];
		t.label = label;
	}
}

- (void)myFetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error {
	NSLog(@"ERROR: %@", error);
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
/*	for(UITouch *touch in touches) {
		CGPoint location = [[CCDirector sharedDirector] 
						convertToGL: [touch locationInView:touch.view]];
	
		CCParticleSystem *emitter = [self nearestEmitterTo:location from:emitters];
		[emitter resetSystem];
		[activeEmitters addObject:emitter];
		emitter.position = location;
	}*/
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
/*	if([activeEmitters count] > 0) {
		for(UITouch *touch in touches) {
			CGPoint location = [[CCDirector sharedDirector] 
								convertToGL: [touch locationInView:touch.view]];
			
			CCParticleSystem *emitter = [self nearestEmitterTo:location from:activeEmitters];
			emitter.position = location;
		}
	}*/
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	//[activeEmitters removeAllObjects];

	// ask director the the window size
	CGSize size = [[CCDirector sharedDirector] winSize];

	NSLog(@"%d", [idx intValue]);
	idx = [NSNumber numberWithInt:(([idx intValue] + 2) % 5)];
	
	NSArray *icas = [tracks objectForKey:@"ica"];
	for(int i = 0 ; i < [emitters count]; i++) {
		NSArray *ica = [icas objectAtIndex:i];
		Track *emitter = [emitters objectAtIndex:i];
		float x = ([[ica objectAtIndex:[idx intValue]] floatValue] + 2)/4;
		float y = ([[ica objectAtIndex:1+[idx intValue]] floatValue] +2)/4;
		CCAction *move_e = [CCMoveTo actionWithDuration:10 position:CGPointMake(size.width * x, size.height * y)];
		CCAction *move_l = [CCMoveTo actionWithDuration:10 position:CGPointMake(size.width * x, size.height * y)];

		[emitter runAction:move_e];
		[emitter.label runAction:move_l];
	}
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
