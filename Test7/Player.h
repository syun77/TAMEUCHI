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
    float   m_PrevX;
    float   m_PrevY;
    int     m_State;    // 状態
    int     m_Timer;    // 汎用タイマー
    int     m_tPast;    // 更新タイマー
    Vec2D   m_Start;    // 移動開始座標
    Vec2D   m_Target;   // 移動目標座標
    int     m_tShot;    // 弾を撃つ間隔
    int     m_tDamage;  // ダメージタイマー
    int     m_tCharge;  // チャージゲージ
    float   m_tPower;   // パワーゲージ
    float   m_PowerMax; // パワーゲージの最大
    int     m_Hp;       // HP
    int     m_tRecover; // 回復用タイマー
    int     m_Combo;    // コンボ回数
    int     m_ComboMax; // 最大コンボ数
    int     m_nLevel;   // ショットレベル
}

// 開始
- (void)initialize;

// タッチ開始コールバック
- (void)cbTouchStart:(float)x y:(float)y;

// タッチ終了コールバック
- (void)cbTouchEnd:(float)x y:(float)y;

// 弾を撃つ
- (void)shot:(float)rot;

// ダメージ
- (void)damage:(Token*)t;

// 危険状態かどうか
- (BOOL)isDanger;

// HPの割合を取得 (０〜１)
- (float)getHpRatio;

// パワーの取得
- (int)getPower;

// パワーの割合を取得
- (float)getPowerRatio;

// パワーの追加
- (void)addPower:(float)v;

// チャージタイマーの取得
- (int)getChargeTimer;

// レベルの取得
- (int)getLevel;

// 消滅したかどうか
- (BOOL)isVanish;

// コンボ回数初期化
- (void)initCombo;

// コンボ回数増加
- (void)addCombo;

// コンボ回数を取得
- (int)getCombo;

// コンボ最大回数を取得
- (int)getComboMax;

// コンボが有効かどうか
- (BOOL)isEnableCombo;

// アイテム取得
- (void)takeItem:(Token*)t;

// レベルアップできるかどうか
- (BOOL)isLevelUp;

// 状態を取得
- (NSString*)getStateString;

@end
