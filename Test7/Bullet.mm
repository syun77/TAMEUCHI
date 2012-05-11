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
#import "Shot.h"
#import "Banana.h"

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
    
    Player* player = [GameScene sharedInstance].player;
    if ([player isDanger]) {
        // スローモード
        dt *= DANGER_SLOW_RATIO;
    }
    [self move:dt];
    
    m_Timer++;
    
    if([self isOutCircle:self._r]) {
//        NSLog(@"Vanish[%d].", [self getIndex]);
        [self vanish];
        
        return;
        
    }
    
}

// 破壊エフェクト生成
- (void)destroy {
    
    if ([self isExist] == NO) {
        return;
    }
    
    Vec2D v = Vec2D(self._vx, self._vy);
    Particle* p = [Particle add:eParticle_Ball x:self._x y:self._y rot:v.Rot() speed:v.Length()];
    if (p) {
        [p setScale:0.5f];
        [p setColor:ccc3(0xFF, 0, 0)];
    }
    
    [self vanish];
}

// ダメージ
- (void)damage:(Token*)t {
    
    [self destroy];
}

// 弾を消して打ち返し弾にする
- (void)vanishReflect {
    
    float rot = Math_Atan2Ex(self._vy, self._vx);
    float x = self._x;
    float y = self._y;
    [Shot add:eShot_Power x:x y:y rot:rot+180 speed:100];
    
    // 弾を消す
    [self destroy];
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

// 敵弾をすべて消す
+ (void)vanishAll:(eBulletVanish)type {
    GameScene* scene = [GameScene sharedInstance];
    TokenManager* mgr = scene.mgrBullet;
    for (Bullet* b in mgr.m_Pool) {
        if ([b isExist] == NO) {
            continue;
        }
        
        // 弾を消す
        [b destroy];
        
        switch (type) {
            case eBulletVanish_Banana:
                // バナナボーナス発生
                [scene addScore: SCORE_BANANA_BONUS];
                [Banana add:eBanana_Normal x:b._x y:b._y];
                break;
                
            case eBulletVanish_Reflect:
                // 打ち返しあり
                [b vanishReflect];
                break;
                
            case eBulletVanish_Normal:
            default:
                break;
        }
    }
}

@end
