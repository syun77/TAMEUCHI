//
//  Bomb.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * ボムの定義
 */
@interface Bomb : Token {
    int     m_Timer;    // タイマー
    int     m_State;    // 状態
    float   m_Radius;   // サイズ (半径)
}

// 半径の設定
- (void)setRadius:(float)r;

// ボムの追加
+ (Bomb*)add:(float)r x:(float)x y:(float)y;

@end
