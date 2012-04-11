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
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    
    if (m_tPast%40 == 20) {
        // 敵の生成
        [Enemy add:eEnemy_Nasu x:480/2 y:320/2 rot:Math_Randf(360) speed:320];
        
    }
    if (m_tPast%40 == 0) {
        // 敵の生成
        [Enemy add:eEnemy_Tako x:480/2 y:320/2 rot:Math_Randf(360) speed:320];
        
    }
}

@end
