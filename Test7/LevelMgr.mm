//
//  LevelMgr.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "LevelMgr.h"
#import "GameScene.h"
#import "Enemy.h"
#import "Player.h"
#import "SaveData.h"

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
 * 大型の敵の数をカウントする
 */
- (int)getEnemyCountBig {
    TokenManager* mgr = [GameScene sharedInstance].mgrEnemy;
    
    int ret = 0;
    for (Enemy* e in mgr.m_Pool) {
        if ([e isExist] == NO) {
            continue;
        }
        
        if ([e getSize] == eSize_Big) {
            ret++;
        }
    }
    
    return ret;
}

/**
 * 初期化
 */
- (void)initialize {
    m_tPast     = 0;
    m_nLevel    = SaveData_GetRank();
//    m_nLevel    = 1;
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
    
    if (type == eEnemy_5Box) {
        
        // 5箱のみ出現条件を変更
        float size = 64;
        float x1 = size;
        float y1 = size;
        float x2 = System_Width() - size;
        float y2 = System_Height() - size;
        
        for (int i = 0; i < 32; i++) {
            
            x = Math_RandFloat(x1, x2);
            y = Math_RandFloat(y1, y2);
            
            float dx = player._x - x;
            float dy = player._y - y;
            Vec2D v = Vec2D(dx, dy);
            if (v.Length() < 128) {
                
                // 近すぎたらやり直し
                continue;
            }
            
            break;
        }
        
        
    }
    
    [Enemy add:type x:x y:y rot:Math_Randf(360) speed:0];
    
}

/**
 * 更新・エンドレスモード
 */
- (void)updateEndless {

    if (m_Timer%40 == 20) {
        if ([self getEnemyCount] < m_nLevel) {
            
            // なすの出現
            [self addEnemy:eEnemy_Nasu];
        }
    }
        
    if (m_Timer%160 == 40) {
        if (m_nLevel >= 6 && m_nLevel%2 == 0) {
            
            // Lv6以上 偶数レベルのみ
            if ([self getEnemyCount] < m_nLevel) {
                
                // たこ焼きの出現
                [self addEnemy:eEnemy_Tako];
            }
        }
    }
        
    if (m_nLevel < 10) {
        
        // Lv10以下はなすとたこ焼きしか出ない
        if (m_Timer > 800) {
            m_nLevel++;
            m_Timer = 0;
        }
    }
    else if (m_nLevel < 100) {
        
        // Lv100以下
        if (m_Timer%320 == 160) {
            
            if ([self getEnemyCountBig] < m_nLevel / 10) {
                
                if (m_nLevel < 20 || Math_Rand(2) == 0) {
                    
                    // プリン出現
                    [self addEnemy:eEnemy_Pudding];
                }
                else {
                    
                    // 牛乳出現
                    [self addEnemy:eEnemy_Milk];
                }
            }
        }
        
        if (m_Timer%600 == 180) {
            if ([self getEnemyCount] < m_nLevel) {
                
                if (Math_Rand(2) == 0) {
                    
                    // 5箱出現
                    [self addEnemy:eEnemy_5Box];
                }
            }
        }
        
        if (m_Timer > 800) {
            m_nLevel++;
            m_Timer = 0;
        }
    }
    else {
        
        // Lv100以上
        if (m_Timer%320 == 160) {
            
            if ([self getEnemyCountBig] < m_nLevel * m_nLevel / 50) {
                
                int cnt = Math_Rand(3) + 1;
                
                for (int i = 0; i < cnt; i++) {
                    if (Math_Rand(2) == 0) {
                        
                        // プリン出現
                        [self addEnemy:eEnemy_Pudding];
                    }
                    else {
                        
                        // 牛乳出現
                        [self addEnemy:eEnemy_Milk];
                    }
                }
                
            }
        }
        
        if (m_Timer%600 == 180) {
            if ([self getEnemyCount] < m_nLevel) {
                
                if (Math_Rand(2) == 0) {
                    
                    // 5箱出現
                    [self addEnemy:eEnemy_5Box];
                }
            }
        }
        
        if (m_Timer > 800) {
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
                case 10:
                    //            if (m_Timer%80 == 20) {
                    if (m_Timer%280 == 20) {
                        // 敵の生成
                        [self addEnemy:eEnemy_5Box];
                        //                [self addEnemy:eEnemy_Pudding];
                        //                [self addEnemy:eEnemy_Nasu];
                        //                [self addEnemy:eEnemy_Tako];
                        //[self addEnemy:eEnemy_Milk];
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

// レベルアップタイマーのウェイト時間を取得する
- (int)getLevelUpTimerWait {
    
    int ret = 60 - (m_nLevel / 4);
    
    ret -= [[GameScene sharedInstance].player getLevel];
    
    if (ret < 20) {
        ret = 20;
    }
    
    return ret;
}

@end
