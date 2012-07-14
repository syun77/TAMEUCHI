//
//  BackTitle.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/11.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import "BackTitle.h"
#import "Exerinya.h"
#import "TitleScene.h"
#import "Math.h"
#import "SaveData.h"

static const float POS_RANK_L = 80;
static const float POS_RANK_R = 480-POS_RANK_L;
static const float POS_RANK_Y = 160+16;

/**
 * タイトル画面用背景
 */
@implementation BackTitle

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
    m_tPast = 0;
    m_tCursorL = 0;
    m_tCursorR = 0;
    m_bRankSelect = YES;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
    
    if (m_bRankSelect == NO) {
        
        // ランク選択無効
        return;
    }
    
    if ([[TitleScene sharedInstance] isTouchRankSelect]) {
        // タッチセレクト中はタイマーを減衰させる
        m_tCursorL *= 0.8;
        m_tCursorR *= 0.8;
    }
    else {
        if (m_tCursorL != m_tCursorR) {
            m_tCursorL = m_tCursorR;
        }
        
        m_tCursorL++;
        m_tCursorR++;
        
        if (m_tCursorL*4 > 180) {
            m_tCursorL -= 180 / 4;
        }
        if (m_tCursorR*4 > 180) {
            m_tCursorR -= 180 / 4;
        }
    }
    
}

- (void)visit {
    [super visit];
    
    if (m_bRankSelect == NO) {
        
        // ランク選択無効
        return;
    }
    
   
#ifdef VERSION_LIMITED
    
    // 制限モードはランク選択不可
    
#else
    // ■ランク選択カーソルの描画
    glColor4f(0, 0, 0, 0.4);
    if ([[TitleScene sharedInstance] isTouchRankSelect]) {
        
        // タッチ中
        glColor4f(0, 0, 0.5, 0.4);
    }
    [self fillRectLT:RANK_SELECT_RECT_X y:RANK_SELECT_RECT_Y w:RANK_SELECT_RECT_W h:RANK_SELECT_RECT_H rot:0 scale:1];
    
    System_SetBlend(eBlend_Add);
    glColor4f(1, 0.2, 0.2, 1);
    
    float cursorLX = 16 * Math_SinEx((m_tCursorL * 4)%180);
    float cursorRX = 16 * Math_SinEx((m_tCursorR * 4)%180);
    
    [self fillTriangle:POS_RANK_L - cursorLX cy:POS_RANK_Y radius:16 rot:270 scale:1];
    [self fillTriangle:POS_RANK_R + cursorRX cy:POS_RANK_Y radius:16 rot:90 scale:1];
#endif // #ifdef VERSION_LIMITED 
    
    System_SetBlend(eBlend_Normal);
    
    
}


// カーソルを動かす（左）
- (void)moveCursorL {
    m_tCursorL = 90 / 4;
}

// カーソルを動かす（右）
- (void)moveCursorR {
    m_tCursorR = 90 / 4;
}

// ランク選択を表示切り替え
- (void)setRankSelect:(BOOL)b {
    m_bRankSelect = b;
}

// ランク選択が有効かどうか
- (BOOL)isRankSelect {
    return m_bRankSelect;
}

@end
