//
//  SFMyScene.m
//  Sky Diver
//
//  Created by Spencer Fornaciari on 2/18/14.
//  Copyright (c) 2014 Spencer Fornaciari. All rights reserved.
//

#import "SFMyScene.h"
@import CoreMotion;

#define NUM_OF_HAWKS 10
#define NUM_OF_CLOUDS 10
#define MULTIPLIER_FOR_DIRECTION 1

typedef enum : uint32_t {
    skyDiverCategory = 0x1 << 0,
    hawkCategory = 0x1 << 1,
    cloudCategory = 0x1 << 2
} SkyDiverTypes;

//static const uint32_t skydiverCategory = 0x1 << 0;
//static const uint32_t hawkCategory = 0x1 << 1;
//static const uint32_t cloudCategory = 0x1 << 2;

@interface SFMyScene ()
{
    int _nextHawk, _nextCloud;
    double _nextHawkSpawn, _nextCloudSpawn;
}

@property (strong, nonatomic) SKSpriteNode *mainCharacter;
@property (nonatomic) SKLabelNode *timeLabel, *lifeLabel;

@property (strong, nonatomic) NSMutableArray *hawkArray;
@property (strong, nonatomic) NSMutableArray *cloudArray;
@property (nonatomic) int time, gameTime, internalClock, lives;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CMAccelerometerData *accelerometerData;

@end

@implementation SFMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.motionManager = [[CMMotionManager alloc] init];
        
        _nextHawk = 0;
        _nextCloud = 0;
        
        if (self.motionManager) {
            [self.motionManager startAccelerometerUpdates];
        }
        self.accelerometerData = [CMAccelerometerData new];
        
        self.accelerometerData = self.motionManager.accelerometerData;
        
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        
        
        _gameTime = 0;
        _internalClock = 0;
        _lives = 1;
        self.timeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-CondensedMedium"];
        self.timeLabel.text = [NSString stringWithFormat:@"Time: %d", _gameTime];
        self.timeLabel.fontColor = [UIColor blackColor];
        self.timeLabel.fontSize = 20;
        self.timeLabel.position = CGPointMake(50, 20);
        
        self.lifeLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica-Neue"];
        self.lifeLabel.text = [NSString stringWithFormat:@"Lives: %d", _lives];
        self.lifeLabel.fontColor = [UIColor blackColor];
        self.lifeLabel.fontSize = 20;
        self.lifeLabel.position = CGPointMake(50, 50);
        
        
        for (int i = 0; i < 2; i++) {
            SKSpriteNode *bg = [SKSpriteNode spriteNodeWithImageNamed:@"skybackground.png"];
            bg.anchorPoint = CGPointZero;
            bg.size = self.size;
            bg.position = CGPointMake( 0, i * bg.size.height);
            bg.name = @"background";
            
            [self addChild:bg];
        }
        
        self.mainCharacter = [[SKSpriteNode alloc] initWithImageNamed:@"diver"];
        self.mainCharacter.name = @"skydiver";
        self.mainCharacter.position = CGPointMake(150, 420);
        self.mainCharacter.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.mainCharacter.size];
//        self.mainCharacter.physicsBody.dynamic = NO;
        self.mainCharacter.physicsBody.allowsRotation = NO;
        self.mainCharacter.physicsBody.affectedByGravity = NO;
        //self.mainCharacter.physicsBody.mass = 0.02;
        self.mainCharacter.physicsBody.categoryBitMask = skyDiverCategory;
        self.mainCharacter.physicsBody.collisionBitMask = hawkCategory;
        self.mainCharacter.physicsBody.contactTestBitMask = cloudCategory | hawkCategory;
        
        [self addChild:self.mainCharacter];
        
        self.hawkArray = [[NSMutableArray alloc] initWithCapacity:NUM_OF_HAWKS];
        
        for (int i = 0; i < NUM_OF_HAWKS; i++) {
            SKSpriteNode *hawk = [SKSpriteNode spriteNodeWithImageNamed:@"hawk"];
            hawk.hidden = YES;
            hawk.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:hawk.size];
            hawk.physicsBody.categoryBitMask = hawkCategory;
            hawk.physicsBody.collisionBitMask = skyDiverCategory;
            hawk.physicsBody.dynamic = NO;
            [self.hawkArray addObject:hawk];
            
            if (i % 2 == 0) {
                hawk.position = CGPointMake(400, 1000);
            } else {
                hawk.position = CGPointMake(-80, 1000);
            }
            
            [self addChild:hawk];
        }
        
        self.cloudArray = [[NSMutableArray alloc] initWithCapacity:NUM_OF_CLOUDS];
        
        for (int i = 0; i < NUM_OF_CLOUDS; i++) {
            SKSpriteNode *cloud = [SKSpriteNode spriteNodeWithImageNamed:@"cloud"];
            cloud.hidden = YES;
            cloud.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:cloud.size];
            cloud.physicsBody.categoryBitMask = cloudCategory;
            cloud.physicsBody.collisionBitMask = 0;
            cloud.physicsBody.contactTestBitMask = skyDiverCategory;
            cloud.physicsBody.dynamic = NO;
            [self.cloudArray addObject:cloud];
            
            if (i % 2 == 0) {
                cloud.position = CGPointMake(400, 1000);
            } else {
                cloud.position = CGPointMake(-80, 1000);
            }
            
            [self addChild:cloud];
        }
        [self addChild:self.timeLabel];
        [self addChild:self.lifeLabel];
        _internalClock = (int)CACurrentMediaTime() + 1;
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
//    [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
//        SKSpriteNode *background = (SKSpriteNode *)node;
//        background.position = CGPointMake(background.position.x, background.position.y + 5);
//        
//        if (background.position.y <= -background.size.height) {
//            background.position = CGPointMake(background.position.x, background.position.y + background.size.height * 2);
//
//        }
        //Works up but not down
        [self enumerateChildNodesWithName:@"background" usingBlock:^(SKNode *node, BOOL *stop) {
            SKSpriteNode * bg = (SKSpriteNode *)node;
            bg.position = CGPointMake(bg.position.x, bg.position.y + 2);
            //NSLog(@"Position: %f", bg.position.y);

            if (bg.position.y >= bg.size.height) {
                bg.position = CGPointMake(bg.position.x, -bg.size.height * 2 + bg.position.y);
                //NSLog(@"Offset: %f", bg.position.y);
            }
        }];
    
//        bg.position = CGPointMake(bg.position.x - 5, bg.position.y);
//        
//        if (bg.position.y <= -bg.size.width) {
//            bg.position = CGPointMake(bg.position.x + bg.size.width * 2, bg.position.y);
//        }
   // }];
    
    
    double curTime = CACurrentMediaTime();
//    NSLog(@"%f", curTime);
//    NSLog(@"%f", _internalClock);
    if (_internalClock == (int)curTime) {
        _gameTime++;
        
        if (_gameTime % 15 == 0) {
            _lives++;
        }
        _internalClock++;
        self.timeLabel.text = [NSString stringWithFormat:@"Time: %d", _gameTime];
    }
    
    self.lifeLabel.text = [NSString stringWithFormat:@"Lives: %d", _lives];
    
    
    if (curTime > _nextHawkSpawn) {
        float randSeconds = [self randomValueBetween:0.20f andValue:1.0f];
        _nextHawkSpawn = randSeconds + curTime;
        
        float randY = [self randomValueBetween:0.0f andValue:self.frame.size.height];
        float randDuration = [self randomValueBetween:5.0f andValue:8.0f];
        
        SKSpriteNode *hawk = self.hawkArray[_nextHawk];
        _nextHawk++;
        
        if (_nextHawk >= self.hawkArray.count) {
            _nextHawk = 0;
        }
        
        [hawk removeAllActions];
        
        hawk.hidden = NO;
        
        CGPoint location;
        
        if (_nextHawk % 2 == 0) {
            hawk.position = CGPointMake(self.frame.size.width + hawk.size.width / 2, randY);
            location = CGPointMake(-600, randY);
            hawk.xScale = fabs(hawk.xScale) * MULTIPLIER_FOR_DIRECTION;

        } else {
            hawk.position = CGPointMake(-hawk.size.width / 2, randY);
            location = CGPointMake(600, randY);
             hawk.xScale = fabs(hawk.xScale) * -MULTIPLIER_FOR_DIRECTION;
        }
        
        //CGPoint location = CGPointMake(-600, randY);
        
        SKAction *moveAction = [SKAction moveTo:location duration:randDuration];
        SKAction *doneAction = [SKAction runBlock:^{
            hawk.hidden = YES;
        }];
        
        SKAction *moveHawkActionWithDone = [SKAction sequence:@[moveAction, doneAction]];
        
        [hawk runAction:moveHawkActionWithDone];
        
    }
    
    if (curTime > _nextCloudSpawn) {
        float randSeconds = [self randomValueBetween:0.20f andValue:1.0f];
        _nextCloudSpawn = randSeconds + curTime;
        
        float randY = [self randomValueBetween:0.0f andValue:self.frame.size.height];
        float randDuration = [self randomValueBetween:5.0f andValue:8.0f];
        
        SKSpriteNode *cloud = self.cloudArray[_nextCloud];
        _nextCloud++;
        
        if (_nextCloud >= self.cloudArray.count) {
            _nextCloud = 0;
        }
        
        [cloud removeAllActions];
        
        cloud.hidden = NO;
        
        CGPoint location;
        
        
        
        if (_nextCloud % 2 == 0) {
            cloud.position = CGPointMake(self.frame.size.width + cloud.size.width / 2, randY);
            location = CGPointMake(-600, randY);
            cloud.xScale = fabs(cloud.xScale) * MULTIPLIER_FOR_DIRECTION;
        } else {
            cloud.position = CGPointMake(-cloud.size.width / 2, randY);
            location = CGPointMake(600, randY);
            cloud.xScale = fabs(cloud.xScale) * -MULTIPLIER_FOR_DIRECTION;

        }
        
        SKAction *moveAction = [SKAction moveTo:location duration:randDuration];
        SKAction *doneAction = [SKAction runBlock:^{
            cloud.hidden = YES;
        }];
        
        SKAction *moveCloudActionWithDone = [SKAction sequence:@[moveAction, doneAction]];
        
        [cloud runAction:moveCloudActionWithDone];
        
    }

    
    self.accelerometerData = self.motionManager.accelerometerData;
    
    //NSLog(@"%f", self.accelerometerData.acceleration.x);
    
    self.mainCharacter.position = CGPointMake(self.mainCharacter.position.x + self.accelerometerData.acceleration.x * 10, self.mainCharacter.position.y + self.accelerometerData.acceleration.y * 2);
}

#pragma mark - Random Number method

-(float)randomValueBetween:(float)low andValue:(float)high
{
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

-(void)didBeginContact:(SKPhysicsContact *)contact
{
    //NSLog(@"Contact");
    
    if (contact.bodyA.categoryBitMask == skyDiverCategory && contact.bodyB.categoryBitMask == hawkCategory) {
        NSLog(@"Ouch!");
        _lives--;
    } else {
        NSLog(@"No Problemo!");
    }
}

@end
