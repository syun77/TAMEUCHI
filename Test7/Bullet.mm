//
//  Bullet.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Bullet.h"

#import "GameScene.h"
#import "Particle.h"
#import "Exerinya.h"

@implementation Bullet

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_Bullet);
    [self.m_pSprite setTextureRect:r];
    
    return self;
}

- (void)initialize {
    m_Timer = 0;
    [self setRotation:0];
    [self setScale:1];
    
//    NSLog(@"Intialize[%d].", [self getIndex]);
}

- (void)update:(ccTime)dt {
    [self move:dt];
    
    m_Timer++;
    
    if([self isOutCircle:self._r]) {
//        NSLog(@"Vanish[%d].", [self getIndex]);
        [self vanish];
        
        return;
        
    }
    
}

// ダメージ
- (void)damage:(Token*)t {
    
    float rot = 0;
    for(int i = 0; i < 8; i++)
    {
        rot += 30 + Math_Randf(30);
        float speed = 100 + Math_Randf(100);
        Particle* p = [Particle add:eParticle_Ball x:self._x y:self._y rot:rot speed:speed];
        if (p) {
            [p setScale:0.25f];
            [p setColor:ccc3(0xFF, 0, 0)];
        }
    }
    [self vanish];
}

// オブジェクト追加
+ (Bullet*)add:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    GameScene* scene = [GameScene sharedInstance];
    Bullet* b = (Bullet*)[scene.mgrBullet add];
    if (b) {
        [b set2:x y:y rot:rot speed:speed ax:0 ay:0];
    }
    
    return b;
}

@end
