//
//  Back.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Back.h"
#import "Exerinya.h"
#import "System.h"
#import "GameScene.h"

enum eState {
    eState_None,
    eState_Dark, // 暗くする
    eState_Light, // 明るくする
};

// 暗くするタイマー
static const int TIMER_DARK = 10;

// 危険タイマー
static const int TIMER_DANGER = 10;

/**
 * 背景トークン実装
 */
@implementation Back

/**
 * 初期化
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    [self create];
    
    self._x = System_CenterX();
    self._y = System_CenterY();
    [self move:0];
    
    // 背景画像を設定
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Back)];
    
    // 変数初期化
    m_TargetX   = self._x;
    m_TargetY   = self._y;
    m_State     = eState_Light;
    m_Timer     = 0;
    m_tDanger   = 0;
    
    return self;
}

// 移動座標の設定
- (void)setTarget:(float)x y:(float)y {
    
    // 画面の中心からの移動量に対するスクロールの割合
    const float RATIO_X = -0.35;
    const float RATIO_Y = -0.5;
    
    float dx = x - System_CenterX();
    float dy = y - System_CenterY();
    float px = System_CenterX() + (dx * RATIO_X);
    float py = System_CenterY() + (dy * RATIO_Y);
    m_TargetX = px;
    m_TargetY = py;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    float dx = m_TargetX - self._x;
    float dy = m_TargetY - self._y;
    
    self._vx = dx * 30;
    self._vy = dy * 30;
    
    [super move:dt];
    
    switch (m_State) {
        case eState_Light:
            m_Timer--;
            if (m_Timer < 1) {
                m_Timer = 0;
                m_State = eState_None;
            }
            break;
            
        case eState_Dark:
            m_Timer++;
            if (m_Timer > TIMER_DARK) {
                m_Timer = TIMER_DARK;
            }
            
        default:
            break;
    }
    
    Player* player = [GameScene sharedInstance].player;
    if ([player isDanger]) {
        if (m_tDanger < TIMER_DANGER) {
            m_tDanger++;
        }
    }
    else {
        if (m_tDanger > 0) {
            m_tDanger--;
        }
    }
    
    int r = 0xFF - 0xA0 * m_Timer / TIMER_DARK;
    int g = 0xFF - 0xA0 * m_Timer / TIMER_DARK;
    int b = 0xFF - 0xA0 * m_Timer / TIMER_DARK;
    
    g = g * (1 - 0.5 * m_tDanger / TIMER_DANGER);
    b = b * (1 - 0.5 * m_tDanger / TIMER_DANGER);
    
    [self setColor:ccc3(r, g, b)];
    
    if ([[GameScene sharedInstance] isLevelUp]) {
        [self setColor:ccc3(0x80, 0x80, 0x80)];
    }    
}

- (void)visit {
    [super visit];

}

// 背景変化
- (void)beginDark {
    m_State = eState_Dark;
}

- (void)beginLight {
    m_State = eState_Light;
}

@end
