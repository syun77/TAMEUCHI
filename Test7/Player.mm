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
    
    [self load:@"icon.png"];
    
    [self create];
    
    self._x = 320 / 2;
    self._y = 480 / 2;
    m_Target.Set(self._x, self._y);
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
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
