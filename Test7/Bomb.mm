//
//  Bomb.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Bomb.h"
#import "Exerinya.h"
#import "GameScene.h"

// ボムのサイズ
static const float RADIAS_BOMB = 80;

// 生存タイマー
static const int TIMER_EXIST = 60;
static const int TIMER_VANISH = 60;

/**
 * 状態
 */
enum eState {
    eState_Main,   // 表示中
    eState_Vanish, // 消滅中
};

/**
 * ボムの実装
 */
@implementation Bomb

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        
        return self;
    }
    
    [self load:@"all.png"];
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftBall);
    [self setTexRect:r];
    
    [self setBlend:eBlend_Add];
    
    return self;
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = TIMER_EXIST;
    m_State = eState_Main;
    [self setVisible:YES];
    [self setAlpha:0xFF];
    
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    switch (m_State) {
        case eState_Main:
            self._r = RADIAS_BOMB;
            
            m_Timer--;
            if (m_Timer < 1) {
                m_Timer = TIMER_VANISH;
                m_State = eState_Vanish;
            }
            break;
        
        case eState_Vanish:
            self._r = RADIAS_BOMB * m_Timer / TIMER_VANISH;
            
            m_Timer = m_Timer * 0.8;
            if (m_Timer < 1) {
                
                // 消滅
                [self vanish];
                
            }
            break;
            
        default:
            break;
    }
    
    // サイズ設定
    if (self._r > 0) {
        
        [self setScale:self._r / RADIAS_BOMB * 1.5 + 0.01 * Math_Randf(4)];
        
        int c = 0xFF;
        if (m_Timer%4 < 2) {
            c = 0x00;
        }
        [self setColor:ccc3(c, c, c)];
    }
}

/**
 * ボムの追加
 */
+ (Bomb*)add:(float)x y:(float)y {
    GameScene* scene = [GameScene sharedInstance];
    Bomb* b = (Bomb*)[scene.mgrBomb add];
    
    if (b) {
        [b set2:x y:y rot:0 speed:0 ax:0 ay:0];
    }
    
    return b;
}

@end
