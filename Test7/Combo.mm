//
//  Combo.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/26.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "Combo.h"
#import "GameScene.h"

static const int TIMER_APPEAR = 60;
static const int POS_X = 420;
static const int POS_Y = 320 - 24;

// 状態
enum eState {
    eState_None,    // 非表示
    eState_Appear,  // 出現
    eState_Wait,    // 待機
};

@implementation Combo

@synthesize asciiFont;
@synthesize asciiFont2;

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
    self.asciiFont2 = [AsciiFont node];
    
    [self load:@"all.png"];
    [self create];
    self._x = POS_X;
    self._y = POS_Y;
    [self move:0];
    m_Timer = 0;
    [self setVisible:NO];
    m_State = eState_None;
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    self.asciiFont2 = nil;
    self.asciiFont = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    [self move:dt];
    
    switch (m_State) {
        case eState_Appear:
            m_Timer = m_Timer * 0.8f;
        {
            float scale = 1 + 2 * (float)m_Timer / TIMER_APPEAR;
            [self.asciiFont setScale:scale];
        }    
            if (m_Timer < 1) {
                m_State = eState_Wait;
            }
            
            break;
            
        case eState_Wait:
            break;
            
        default:
            break;
    }
    
    [self.asciiFont setPosScreen:self._x y:self._y];
    [self.asciiFont2 setPosScreen:self._x y:self._y - 16];
    
    
    [self.asciiFont setColor:ccc3(0xFF, 0xFF, 0xFF)];
    if ([[GameScene sharedInstance].player isLevelUp]) {
        
        // レベルアップ演出
        if (m_Timer%8 < 4) {
            [self.asciiFont setColor:ccc3(0xFF, 0x80, 0x80)];
        }
    }
}

/**
 * 描画
 */
- (void)visit {
    if (m_State == eState_None) {
        return;
    }
    
    System_SetBlend(eBlend_Add);
    
    int t = 8 * m_Timer / TIMER_APPEAR;
    if (t < 1) {
        t = 1;
    }
    
    if ([[GameScene sharedInstance].player isLevelUp]) {
        
        // レベルアップ演出
        glColor4f(1, 0, 0, 1);
    }
    else {
        glColor4f(0.2, 0.2, 0.2, 1);
    }
    [self fillRect:0 cy:self._y w:System_Width() h:t rot:0 scale:1];
    
    System_SetBlend(eBlend_Normal);
    
}

// コンボ開始
- (void)start:(int)combo {
    m_Combo = combo;
    m_State = eState_Appear;
    m_Timer = TIMER_APPEAR;
    
    // 中央揃えでテキスト設定
    [self.asciiFont setAlign:eFontAlign_Center];
    [self.asciiFont setText:[NSString stringWithFormat:@"%d", m_Combo]];
    
    [self.asciiFont2 setAlign:eFontAlign_Center];
    [self.asciiFont2 setText:@"combo"];
    [self.asciiFont2 setScale:0.5];
}

// コンボ終了
- (void)end {
    m_State = eState_None;
    m_Timer = 0;
    [self.asciiFont setText: @""];
    [self.asciiFont2 setText:@""];
}

// コンボが有効かどうか
- (BOOL)isEnable {
    return m_State != eState_None;
}

@end
