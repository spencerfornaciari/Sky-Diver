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
        
        self.physicsWorld.contactDelegate = self;
        
        for (int i = 0; i < 2; i++) {
            SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
            background.name = @"background";
            background.anchorPoint = CGPointZero;
            background.position = CGPointMake(0, i * background.size.height);
            background.size = self.size;
            
            [self addChild:background];
            
        }
        
        self.mainCharacter = [[SKSpriteNode alloc] initWithImageNamed:@"diver"];
        self.mainCharacter.name = @"skydiver";
        self.mainCharacter.position = CGPointMake(150, 400);
        //self.mainCharacter.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.mainCharacter.size];
        //self.mainCharacter.physicsBody.dynamic = YES;
        //self.mainCharacter.physicsBody.affectedByGravity = YES;
        //self.mainCharacter.physicsBody.mass = 0.02;
        self.mainCharacter.physicsBody.categoryBitMask = skydiver;
        self.mainCharacter.physicsBody.collisionBitMask = eagle | pigeon;
        self.mainCharacter.physicsBody.contactTestBitMask = eagle | pigeon;
        
        [self addChild:self.mainCharacter];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    self.mainCharacter.physicsBody.velocity = CGVectorMake(0, 0);
    [self.mainCharacter.physicsBody applyImpulse:CGVectorMake(0, 7)];
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
        SKSpriteNode *background = (SKSpriteNode *)node;
        background.position = CGPointMake(background.position.x, background.position.y + 5);
        
        if (background.position.y <= -background.size.height) {
            background.position = CGPointMake(background.position.x, background.position.y + background.size.height * 2);

        }
        
//        bg.position = CGPointMake(bg.position.x - 5, bg.position.y);
//        
//        if (bg.position.y <= -bg.size.width) {
//            bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
//        }
    }];
}

@end
