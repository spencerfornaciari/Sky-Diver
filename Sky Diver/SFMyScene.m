//
//  SFMyScene.m
//  Sky Diver
//
//  Created by Spencer Fornaciari on 2/18/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFMyScene.h"

static const uint32_t skydiver = 0x1 << 0;
static const uint32_t eagle = 0x1 << 1;
static const uint32_t pigeon = 0x1 << 2;

@interface SFMyScene ()

@property (strong, nonatomic) SKSpriteNode *mainCharacter;
@property (nonatomic) int time;

@end

@implementation SFMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        for (int i = 0; i < 2; i++) {
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
            background.name = @"background";
            background.anchorPoint = CGPointZero;
            background.position = CGPointMake(i * background.size.width, 0);
            background.size = self.size;
            
            [self addChild:background];
            
        }
        
        self.mainCharacter = [[SKSpriteNode alloc] initWithImageNamed:@"skydiver"];
        self.mainCharacter.name = @"skydiver";
        self.mainCharacter.position = CGPointMake(50, 100);
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
