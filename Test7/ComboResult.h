//
//  ComboResult.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/30.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * コンボ結果
 */
@interface ComboResult : Token {
    AsciiFont*  asciiFont;  // フォントオブジェクト
    int         m_nCombo;   // コンボ数
    int         m_State;    // 状態
    int         m_Timer;    // タイマ
}

@property (nonatomic, retain)AsciiFont* asciiFont;

// 演出開始
- (void)start:(int)nCombo;

@end
