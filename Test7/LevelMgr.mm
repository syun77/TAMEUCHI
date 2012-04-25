//
//  LevelMgr.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "LevelMgr.h"
#import "GameScene.h"
#import "Enemy.h"
#import "Player.h"

/**
 * レベル管理
 */
@implementation LevelMgr

/**
 * 初期化
 */
- (void)initialize {
    m_tPast = 0;
    m_nLevel = 1;
}

/**
 * 敵の生成
 */
- (void)addEnemy:(eEnemy)type {
    
    Player* player = [GameScene sharedInstance].player;
    
    const float RANGE = 0;
    
    float x = 0;
    float y = 0;
    if (player._x > System_CenterX()) {
        x = -RANGE;
    }
    else {
        x = System_Width() + RANGE;
    }
    if(player._y > System_CenterY()) {
        y = -RANGE;
    }
    else {
        y = System_Height() + RANGE;
    }
    if (Math_Rand(2) == 0) {
        x = Math_Rand(System_Width());
    }
    else {
        y = Math_Rand(System_Height());
    }
    [Enemy add:type x:x y:y rot:Math_Randf(360) speed:0];
    
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    m_Timer++;
    
    
    switch (m_nLevel) {
        case 1:
//            if (m_Timer%80 == 20) {
              if (m_Timer%280 == 20) {
                // 敵の生成
                [self addEnemy:eEnemy_Pudding];
//                [self addEnemy:eEnemy_Nasu];
//                [self addEnemy:eEnemy_Tako];
            }
            break;
            
        case 2:
            if (m_Timer%80 == 20) {
                // 敵の生成
                [self addEnemy:eEnemy_Tako];
            }
            
        default:
            break;
    }
    
}

/**
 * レベルの取得
 */
- (int)getLevel {
    return m_nLevel;
}

// タイマーの取得
- (int)getTimer {
    return m_Timer;
}

@end
