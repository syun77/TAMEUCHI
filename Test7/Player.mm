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
    
    self._x = 480 / 2;
    self._y = 320 / 2;
    m_Target.Set(self._x, self._y);
    
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Player1)];
    
    m_tPast = 0;
    
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
        float x = [input getPosX];
        float y = [input getPosY];
        m_Target.Set(x, y);
    }
    
    Vec2D vP = Vec2D(self._x, self._y);
    Vec2D vM = m_Target - vP;
    vM *= 10.0f;
    
    self._x += vM.x * dt;
    self._y += vM.y * dt;
    
}

@end
