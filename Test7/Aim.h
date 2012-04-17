//
//  Aim.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#include "Vec.h"

/**
 * 照準クラス定義
 */
@interface Aim : Token {
    Vec2D m_Target; // 移動目標座標
    int   m_tPast;  // 経過タイマー
    int   m_tRot;   // 回転タイマー
    BOOL  m_bActive; // 動作フラグ
}

// 移動座標を強制的に設定する
- (void)setTargetDirect:(float)x y:(float)y;

// 移動目標座標の設定
- (void)setTarget:(float)x y:(float)y;

// 動作フラグを設定する
- (void)setActive:(BOOL)b;

// 動作フラグを取得する
- (BOOL)isActive;

// 移動目標座標の取得
- (Vec2D*)getTarget;

@end
