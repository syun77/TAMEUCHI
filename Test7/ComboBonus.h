//
//  ComboBonus.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/19.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * コンボボーナス
 */
@interface ComboBonus : Token {
    AsciiFont*  asciiFont;  // フォントオブジェクト
    int         m_nBase;    // 基準スコア
    int         m_nCombo;   // コンボ数
    int         m_State;    // 状態
    int         m_Timer;    // タイマー
}

@property (nonatomic, retain)AsciiFont* asciiFont;

// 演出開始
- (void)start:(int)nCombo;

@end
