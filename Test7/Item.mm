//
//  Item.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Item.h"

#import "Exerinya.h"
#import "GameScene.h"
#import "Particle.h"

/**
 * アイテムの実装
 */
@implementation Item

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    CGRect r = Exerinya_GetRect(eExerinyaRect_Banana);
    [self.m_pSprite setTextureRect:r];
    
    if (System_IsRetina()) {
        [self setScale:1];
    }
    else {
        [self setScale:0.5];
    }
    
    [self setSize2: 16 * self.scale];
    
    m_Type = eItem_Recover;
    m_tPast = 0;
    
    return self;
    
}

/**
 * 初期化
 */
- (void)initialize {
    
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    m_tPast++;
    
    Player* player = [GameScene sharedInstance].player;
    if ([player isDanger]) {
        
        // ゆっくりにする
        dt *= DANGER_SLOW_RATIO;
    }
    
    if ([player isVanish] == NO) {
        // 一定距離に近づいたらプレイヤーに近づく
        Vec2D v = Vec2D(player._x - self._x, player._y - self._y);
        if (v.LengthSq() < 10000) {
            v.Normalize();
            v *= 300;
            self._vx = v.x;
            self._vy = v.y;
        }
    }
    
    [self setRotation:m_tPast*4];
    [self move:dt];
    
    if (self._y < -self._r) {
        // 画面外に出た
        [self vanish];
    }
}

// アイテム種別の取得
- (eItem)getType {
    return m_Type;
}

// アイテム取得演出の再生
- (void)vanishWithEffect {
    
    float rot = 0;
    for(int i = 0; i < 8; i++)
    {
        rot += 30 + Math_Randf(30);
        float speed = 100 + Math_Randf(100);
        Particle* p = [Particle add:eParticle_Ball x:self._x y:self._y rot:rot speed:speed];
        if (p) {
            [p setScale:0.5f];
            [p setColor:ccc3(0xFF, 0xFF, 0)];
        }
    }
    [self vanish];
}

/**
 * アイテムの追加
 */
+ (Item*)add:(eItem)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    
    GameScene* scene = [GameScene sharedInstance];
    Item* item = (Item*)[scene.mgrItem add];
    if (item) {
        [item set2:x y:y rot:rot speed:speed ax:0 ay:-1];
    }
    
    return item;
}


@end
