//
//  Shot.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Shot.h"

#import "GameScene.h"
#import "Particle.h"
#import "Exerinya.h"

/**
 * 自弾の実装
 */
@implementation Shot

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall);
    [self.m_pSprite setTextureRect:r];
    
    [self setBlend:eBlend_Add];
    [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
    
    if (System_IsRetina() == NO) {
        [self setScale:0.25f];
    }
    else {
        [self setScale:0.5f];
    }
    
    [self setSize2: 32 * self.scale];
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = 0;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_Timer++;
    [self move:dt];
    switch (m_Id) {
        case eShot_Power:
            if (m_Timer%4 == 2) {
                [self setColor:ccc3(0xFF, 0, 0)];
                
            }
            else {
                [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
            }
            break;
            
        default:
            break;
    }
    
    if ([super isOutCircle:32]) {
        [self vanish];
    }
    
}

- (void)setId:(eShot)type {
    m_Id = type;
    
    switch (m_Id) {
        case eShot_Power:
            [self setColor:ccc3(0xFF, 0, 0)];
            m_Power = 5;
            break;
            
        default:
            [self setColor:ccc3(0xFF, 0xFF, 0xFF)];
            m_Power = 1;
            break;
    }
}

/**
 * 敵に当たった
 */
- (void)hit:(float)x y:(float)y {
    
    // パーティクル発生
    Vec2D v = Vec2D(self._x - x, self._y - y);
    float rot = v.Rot() + Math_RandInt(-30, 30);
    Particle* p = [Particle add:eParticle_Ball x:self._x y:self._y rot:rot speed:200];
    if (p) {
        [p setScale:0.1];
    }
    
    m_Power--;
    if (m_Power < 1) {
        // 消滅
        [self vanish];
    }
    
}

/**
 * 自弾の追加
 */
+ (Shot*)add:(eShot)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    GameScene* scene = [GameScene sharedInstance];
    Shot* s = (Shot*)[scene.mgrShot add];
    if (s) {
        [s set2:x y:y rot:rot speed:speed ax:0 ay:0];
        [s setId:type];
    }
    
    return s;
}

@end
