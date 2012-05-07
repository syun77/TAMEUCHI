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
 * 敵の生存数を取得する
 */
- (int)getEnemyCount {
    TokenManager* mgr = [GameScene sharedInstance].mgrEnemy;
    
    return [mgr count];
}

/**
 * 初期化
 */
- (void)initialize {
    m_tPast     = 0;
    m_nLevel    = 1;
    m_Mode      = eLevel_Endless;
//    m_Mode      = eLevel_TimeAttack;
}

/**
 * 敵の生成
 */
- (void)addEnemy:(eEnemy)type {
    
    Player* player = [GameScene sharedInstance].player;
    
    const float RANGE = 0;
    
    // プレイヤー座標と反対側に出現するようにする
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
    
//    x = Math_Rand(System_Width());
//    y = Math_Rand(System_Height());
    
    [Enemy add:type x:x y:y rot:Math_Randf(360) speed:0];
    
}

/**
 * 更新・エンドレスモード
 */
- (void)updateEndless {

    if (m_nLevel < 100) {
        if (m_Timer%40 == 20) {
            if ([self getEnemyCount] < m_nLevel) {
                [self addEnemy:eEnemy_Nasu];
            }
        }
        
        if (m_Timer%160 == 40) {
            if (m_nLevel > 5) {
                if ([self getEnemyCount] < m_nLevel) {
                    [self addEnemy:eEnemy_Tako];
                }
            }
        }
        
        if (m_Timer%320 == 160) {
            if (m_nLevel > 10) {
                if ([self getEnemyCount] < m_nLevel) {
                    
                    if (Math_Rand(2) == 0) {
                        
                        [self addEnemy:eEnemy_Pudding];
                    }
                    else {
                        
                        [self addEnemy:eEnemy_Milk];
                    }
                }
            }
        }
        
        if (m_Timer > 200) {
            m_nLevel++;
            m_Timer = 0;
        }
    }
    
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    m_Timer++;
    
    switch (m_Mode) {
        case eLevel_Endless:
            [self updateEndless];
            break;
            
        default:
            switch (m_nLevel) {
                case 1:
                    //            if (m_Timer%80 == 20) {
                    if (m_Timer%2800 == 20) {
                        // 敵の生成
                        //                [self addEnemy:eEnemy_5Box];
                        //                [self addEnemy:eEnemy_Pudding];
                        //                [self addEnemy:eEnemy_Nasu];
                        //                [self addEnemy:eEnemy_Tako];
                        [self addEnemy:eEnemy_Milk];
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
