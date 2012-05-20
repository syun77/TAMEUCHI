//
//  ComboBonus.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/19.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "ComboBonus.h"
#import "GameScene.h"

// 出現タイマ
static const int TIMER_APPEAR = 60;
// ちょっと待つタイマー
static const int TIMER_WAIT = 60;
// 消滅タイマ
static const int TIMER_VANISH = 30;

// 座標
static const float POS_X = 236;
static const float POS_Y = 320-16;

enum eState {
    eState_None,    // 非表示
    eState_Appear,  // 出現
    eState_Wait,    // ちょっと待つ
    eState_Vanish,  // 消滅
};


@implementation ComboBonus

@synthesize asciiFont;

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return  self;
    }
    
    // フォント生成
    self.asciiFont = [AsciiFont node];
    
    [self load:@"all.png"];
    [self create];
    [self setVisible:NO];
    
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
    m_nBase = 0;
    m_nCombo = 0;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    switch (m_State) {
        case eState_Appear:
            // 出現
            m_Timer--;
            if (m_Timer < 1) {
                m_State = eState_Vanish;
                m_Timer = TIMER_VANISH;
            }
            break;
        
        case eState_Vanish:
            // 消滅
            [self.asciiFont setAlpha:0xFF * m_Timer / TIMER_VANISH];
            m_Timer--;
            if (m_Timer < 1) {
                
                [self.asciiFont setVisible:YES];
                m_State = eState_None;
                m_Timer = 0;
                [self.asciiFont setText:@""];
            }
            break;
            
        default:
            break;
    }
    
    float x = 480 + 16 - [self.asciiFont getLength] * ASCII_SIZE_REAL;
    [self.asciiFont setPosScreen:x y:POS_Y];
}

/**
 * 演出開始
 */
- (void)start:(int)nCombo {
    GameScene* scene = [GameScene sharedInstance];
    
    m_nBase = 100 * [scene.player getLevel];
    m_nCombo = nCombo * nCombo;
    m_Timer = TIMER_APPEAR;
    m_State = eState_Appear;
    int score = m_nBase * m_nCombo;
    if (score <= 0) {
        return;
    }
    
    [scene addScore:score];
    
    [self.asciiFont setText:[NSString stringWithFormat:@"%dx%d=%d", m_nBase, m_nCombo, score]];
    
    [self.asciiFont setVisible:YES];
    [self.asciiFont setScale:1];
    [self.asciiFont setColor:ccc3(0xFF, 0xFF, 0x80)];
    [self.asciiFont setAlpha:0xFF];
}

@end
