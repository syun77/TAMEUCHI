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
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    m_Timer++;
    
    const float RANGE = 0;
    
    switch (m_nLevel) {
        case 1:
            if (m_Timer%80 == 20) {
                // 敵の生成
                float x = -RANGE;
                float y = -RANGE;
                if(Math_Rand(2) == 0) {
                    x = System_Width() + RANGE;
                }
                if(Math_Rand(2) == 0) {
                    y = System_Height() + RANGE;
                }
                if (Math_Rand(2) == 0) {
                    x = Math_Rand(System_Width());
                }
                else {
                    y = Math_Rand(System_Height());
                }
                [Enemy add:eEnemy_Nasu x:x y:y rot:Math_Randf(360) speed:0];
            }
            break;
            
        case 2:
            if (m_Timer%80 == 20) {
                // 敵の生成
                [Enemy add:eEnemy_Tako x:480/2 y:320/2 rot:Math_Randf(360) speed:320];
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
