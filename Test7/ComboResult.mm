//
//  ComboResult.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/30.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "ComboResult.h"

// 出現タイマ
static const int TIMER_APPEAR = 60;
// ちょっと待つタイマー
static const int TIMER_WAIT = 60;
// 消滅タイマ
static const int TIMER_VANISH = 30;

// 座標
static const float POS_X = 400;
static const float POS_Y = 320-64;

enum eState {
    eState_None,    // 非表示
    eState_Appear,  // 出現
    eState_Wait,    // ちょっと待つ
    eState_Vanish,  // 消滅
};

@implementation ComboResult

@synthesize asciiFont;

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    // フォント生成
    self.asciiFont = [AsciiFont node];
    
    [self load:@"all.png"];
    [self create];
    [self setVisible:NO];
    
    self._x = 420;
    self._y = 40 + 40;
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    self.asciiFont = nil;
    
    [super dealloc];
}

/**
 * 初期化
 */
- (void)initialize {
    m_Timer = 0;
    m_State = eState_None;
    m_nCombo = 0;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    self._x = POS_X;
    self._y = POS_Y;
    
    switch (m_State) {
        case eState_Appear:
            // 出現
        {
            self._x += 100 * m_Timer / TIMER_APPEAR;
            
            int val = m_Timer * 0.2;
            if (val < 1) {
                val = 1;
            }
            m_Timer -= val;
            if (m_Timer < 1) {
                m_State = eState_Wait;
                m_Timer = TIMER_WAIT;
            }
        }
            break;
        
        case eState_Wait:
            // ちょっと待つ
            
            m_Timer--;
            if (m_Timer < 1) {
                m_State = eState_Vanish;
                m_Timer = TIMER_VANISH;
            }
            break;
            
        case eState_Vanish:
            
            // 点滅する
            [self.asciiFont setVisible:m_Timer%4 < 2];
            
            m_Timer--;
            if (m_Timer < 1) {
                
                // おしまい
                [self.asciiFont setVisible:YES];
                m_State = eState_None;
                m_Timer = 0;
                [self.asciiFont setText:@""];
            }
            break;
            
        default:
            // 画面外に出しておく
            self._x = 1000;
            break;
    }
    
    [self.asciiFont setPosScreen:self._x y:self._y];
}

/**
 * 演出開始
 */
- (void)start:(int)nCombo {
    m_nCombo = nCombo;
    m_Timer = TIMER_APPEAR;
    m_State = eState_Appear;
    
    [self.asciiFont setAlign:eFontAlign_Center];
    [self.asciiFont setText:[NSString stringWithFormat:@"%d combo", nCombo]];
}

@end
