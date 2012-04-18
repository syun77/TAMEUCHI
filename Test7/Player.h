//
//  Player.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"
#include "Vec.h"

// 弾を撃つ間隔
static const int SHOT_TIMER = 16;

/**
 * 自機クラス定義
 */
@interface Player : Token {
    int     m_State;    // 状態
    int     m_Timer;    // 汎用タイマー
    int     m_tPast;    // 更新タイマー
    Vec2D   m_Start;    // 移動開始座標
    Vec2D   m_Target;   // 移動目標座標
    int     m_tShot;    // 弾を撃つ間隔
    int     m_tDamage;  // ダメージタイマー
    int     m_tPower;   // パワーゲージ
    int     m_Hp;       // HP
}

// 開始
- (void)initialize;

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y;

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y;

// 弾を撃つ
- (void)shot;

// ダメージ
- (void)damage:(Token*)t;

// パワーの取得
- (int)getPower;

@end
