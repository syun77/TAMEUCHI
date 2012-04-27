//
//  Combo.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Combo.h"

static const int TIMER_APPEAR = 60;

// 状態
enum eState {
    eState_None,    // 非表示
    eState_Appear,  // 出現
    eState_Wait,    // 待機
};

@implementation Combo

@synthesize asciiFont;
@synthesize asciiFont2;

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
    self._x = 420;
    self._y = 40;
    [self move:0];
    m_Timer = 0;
    [self setVisible:NO];
    m_State = eState_None;
    
    return self;
}

- (void)dealloc {
    self.asciiFont2 = nil;
    self.asciiFont = nil;
    
    [super dealloc];
}

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
}

- (void)visit {
    if (m_State == eState_None) {
        return;
    }
    
    System_SetBlend(eBlend_Add);
    
    int t = 4 * m_Timer / TIMER_APPEAR;
    if (t < 1) {
        t = 1;
    }
    glColor4f(1, 0, 0, 1);
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
