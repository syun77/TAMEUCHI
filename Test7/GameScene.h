//
//  GameScene.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "IScene.h"
#import "InterfaceLayer.h"
#import "TokenManager.h"
#import "Back.h"
#import "Player.h"
#import "Aim.h"
#import "Charge.h"
#import "AsciiFont.h"
#import "LevelMgr.h"
#import "Gauge.h"
#import "GaugeHp.h"
#import "Combo.h"
#import "ComboResult.h"
#import "Item.h"
#import "Black.h"
#import "Banana.h"

// 危険時に有効となる速度の係数
static const float DANGER_SLOW_RATIO = 0.25;

// レベルアップ演出タイマー
static const int TIMER_LEVELUP = 60;

// バナナボーナススコア
static const int SCORE_BANANA_BONUS = 500;

/**
 * ゲームシーン
 */
@interface GameScene : IScene {
    // オブジェクト管理
    CCLayer*        baesLayer;      // 描画レイヤー
    Back*           back;           // 背景画像
    Player*         player;         // プレイヤー
    Aim*            aim;            // 照準
    Charge*         charge;         // チャージエフェクト
    Gauge*          gauge;          // チャージゲージ
    GaugeHp*        gaugeHp;        // チャージゲージHP
    Combo*          combo;          // コンボ数表示
    ComboResult*    comboResult;    // コンボ結果表示
    TokenManager*   mgrShot;        // 自弾
    TokenManager*   mgrItem;        // アイテム
    TokenManager*   mgrEnemy;       // 敵
    TokenManager*   mgrBullet;      // 敵弾
    TokenManager*   mgrBanana;      // バナナボーナス
    Black*          black;          // 暗転用スプライト
    TokenManager*   mgrParticle;    // パーティクル
    InterfaceLayer* interfaceLayer; // 入力受け取り
    LevelMgr*       levelMgr;       // レベル管理
    AsciiFont*      ascciFont2;     // フォント
    AsciiFont*      ascciFont3;     // フォント
    AsciiFont*      ascciFont4;     // フォント
    AsciiFont*      ascciFont5;     // フォント
    AsciiFont*      ascciFontLevel; // フォント（レベル）
    AsciiFont*      asciiFontScore; // フォント（スコア）
    AsciiFont*      asciiFontLevelUp; // フォント（レベルアップ演出）
    AsciiFont*      asciiFontGameover; // フォント（ゲームオーバー）
    
    int             m_State;        // 状態
    int             m_Step;         // ステップ
    int             m_Timer;        // 汎用タイマー
    int             m_nDestroy;     // 敵を倒した数
    int             m_Score;        // スコア
    int             m_ComboMax;     // 最大コンボ数
    int             m_tPast;        // 経過時間
}

@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)Back*              back;
@property (nonatomic, retain)Player*            player;
@property (nonatomic, retain)Aim*               aim;
@property (nonatomic, retain)Gauge*             gauge;
@property (nonatomic, retain)GaugeHp*           gaugeHp;
@property (nonatomic, retain)Combo*             combo;
@property (nonatomic, retain)ComboResult*       comboResult;
@property (nonatomic, retain)Charge*            charge;
@property (nonatomic, retain)Black*             black;
@property (nonatomic, retain)TokenManager*      mgrShot;
@property (nonatomic, retain)TokenManager*      mgrItem;
@property (nonatomic, retain)TokenManager*      mgrEnemy;
@property (nonatomic, retain)TokenManager*      mgrBullet;
@property (nonatomic, retain)TokenManager*      mgrParticle;
@property (nonatomic, retain)TokenManager*      mgrBanana;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)LevelMgr*          levelMgr;
@property (nonatomic, retain)AsciiFont*         asciiFont2;
@property (nonatomic, retain)AsciiFont*         asciiFont3;
@property (nonatomic, retain)AsciiFont*         asciiFont4;
@property (nonatomic, retain)AsciiFont*         asciiFont5;
@property (nonatomic, retain)AsciiFont*         asciiFontLevel;
@property (nonatomic, retain)AsciiFont*         asciiFontScore;
@property (nonatomic, retain)AsciiFont*         asciiFontLevelUp;
@property (nonatomic, retain)AsciiFont*         asciiFontGameover;

// シングルトンを取得
+ (GameScene*)sharedInstance;

+ (void)releaseInstance;

// 敵を倒した数を取得する
- (int)getDestroyCount;

// レベルアップ演出を開始する
- (void)startLevelUp;

// レベルアップ演出中かどうか
- (BOOL)isLevelUp;

// タイマーを取得する
- (int)getTimer;

// スコアを加算する
- (void)addScore:(int)score;

@end
