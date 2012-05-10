//
//  Combo.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/26.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "AsciiFont.h"

/**
 * コンボ演出
 */
@interface Combo : Token {
    AsciiFont*  asciiFont;  // フォントオブジェクト
    AsciiFont*  asciiFont2; // フォントオブジェクト２
    int         m_Timer;    // 汎用タイマー
    int         m_Combo;    // コンボ数
    int         m_State;    // 状態
}

@property (nonatomic, retain)AsciiFont* asciiFont;
@property (nonatomic, retain)AsciiFont* asciiFont2;

// コンボ開始
- (void)start:(int)combo;

// コンボ終了
- (void)end;

// コンボが有効かどうか
- (BOOL)isEnable;


@end
