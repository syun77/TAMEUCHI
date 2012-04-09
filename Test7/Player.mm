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
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    // 移動
    [self move:dt];
    
    // 更新タイマー
    m_tPast++;
    
    // アニメーション更新
    if (m_tPast%64 / 32) {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    }
    else {
        [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player2)];
    }
    
    GameScene* scene = [GameScene sharedInstance];
    InterfaceLayer* input = scene.interfaceLayer;
    
    if ([input isTouch]) {
        // タッチ中
        // 移動処理
        float x = [input getPosX];
        float y = [input getPosY];
        m_Target.Set(x, y);
        
        if (m_tShot > 0) {
            m_tShot--;
        }
        if (m_tShot <= 0) {
            // 弾を撃つ
            Enemy* e = [Enemy getNearest:_x y:_y];
            if (e) {
                float dx = e._x - self._x;
                float dy = e._y - self._y;
                m_ShotRot = Math_Atan2Ex(dy, dx);
            }
            
            [Shot add:self._x y:self._y rot:m_ShotRot speed:240];
            
            m_tShot = SHOT_TIMER;
        }
    }
    else {
        m_tShot = 0;
    }
    
    Vec2D vP = Vec2D(self._x, self._y);
    Vec2D vM = m_Target - vP;
    vM *= 10.0f;
    
    self._x += vM.x * dt;
    self._y += vM.y * dt;
    
}

@end
