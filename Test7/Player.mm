//
//  Player.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Player.h"

#import "GameScene.h"

#include "Vec.h"
#import "Exerinya.h"
#import "Enemy.h"
#import "Shot.h"

// ダメージタイマー
static const int TIMER_DAMAGE = 60;

/**
 * 自機クラスを実装する
 */
@implementation Player

/**
 * 初期化
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all-hd.png"];
    
    [self create];
    
    self._x = System_CenterX();
    self._y = SYstem_CenterY();
    m_Target.Set(self._x, self._y);
    
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    [self setScale:0.5f];
    
    m_tPast = 0;
    m_ShotRot = 0.0f;
    m_tShot = 0;
    m_tShot2 = 0;
    m_tDamage = 0;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    // 移動
    [self move:dt];
    
    GameScene* scene = [GameScene sharedInstance];
    [scene.back setTarget:self._x y:self._y];
    
    // 更新タイマー
    m_tPast++;
    if (m_tDamage > 0) {
        m_tDamage--;
    }
    
    // アニメーション更新
    if (m_tPast%64 / 32) {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    }
    else {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player2)];
    }
    
    if (m_tDamage > 0) {
        // ダメージ中画像
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_PlayerDamage)];
    }
    
    
    InterfaceLayer* input = scene.interfaceLayer;
    
    if ([input isTouch]) {
        // タッチ中
        // 移動処理
        float x = [input getPosX];
        float y = [input getPosY];
        m_Target.Set(x, y);
        
        // ショットタイマー更新
        if (m_tShot > 0) {
            m_tShot--;
        }
        if (m_tShot <= 0) {
            // 弾を撃つ
            [self shot];
            m_tShot2++;
            if (m_tShot2 > 3) {
                m_tShot = SHOT_TIMER;
                m_tShot2 = 0;
            }
        }
    }
    else {
        m_tShot = 0;
        m_tShot2 = 0;
    }
    
    Vec2D vP = Vec2D(self._x, self._y);
    Vec2D vM = m_Target - vP;
    vM *= 10.0f;
    
    self._x += vM.x * dt;
    self._y += vM.y * dt;
    
}

// 弾を撃つ
- (void)shot {
    Enemy* e = [Enemy getNearest:_x y:_y];
    if (e) {
        float dx = e._x - self._x;
        float dy = e._y - self._y;
        m_ShotRot = Math_Atan2Ex(dy, dx);
    }
    
    [Shot add:self._x y:self._y rot:m_ShotRot speed:360];
    
    
}

// ダメージ
- (void)damage:(Token*)t {
    m_tDamage = TIMER_DAMAGE;
}

@end
