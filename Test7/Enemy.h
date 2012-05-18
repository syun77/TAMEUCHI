//
//  Enemy.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

enum eEnemyVanish {
    eEnemyVanish_Normal,    // 消すだけ
    eEnemyVanish_Reflect,   // 打ち返し弾発生
    eEnemyVanish_Banana,    // バナナボーナス発生
};

/**
 * 敵種別
 */
enum eEnemy {
    eEnemy_Nasu,    // ナス
    eEnemy_Tako,    // たこ焼き
    eEnemy_5Box,    // ５箱
    eEnemy_Pudding, // プリン
    eEnemy_Milk,    // 牛乳
    eEnemy_XBox,    // XBox
    eEnemy_Radish,  // 大根
    eEnemy_Carrot,  // 人参
    eEnemy_Pokey,   // ポッキー
    eEnemy_Pokey2,  // ポッキー２
};

/**
 * 敵の大きさ
 */
enum eSize {
    eSize_Small,    // 小
    eSize_Middle,   // 中
    eSize_Big,      // 大
};

/**
 * 敵
 */
@interface Enemy : Token {
    eEnemy  m_Id;       // 敵番号
    int     m_tPast;    // 経過時間
    int     m_Timer;    // 汎用タイマー
    int     m_Val;      // 汎用パラメータ
    int     m_Val2;     // 汎用パラメータ２
    float   m_AimX;     // 狙い撃ち座標 (X)
    float   m_AimY;     // 狙い撃ち座標 (Y)
    BOOL    m_bWhip;    // ウィップ弾フラグ
    int     m_Step;     // 実行ステップ
    int     m_Hp;       // HP
    int     m_HpMax;    // 最大HP
    int     m_State;    // 状態
}

// 敵の生成
+ (Enemy*)add:(eEnemy)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed;

// 指定の座標に一番近い敵を探す
+ (Enemy*)getNearest:(float)x y:(float)y;

// 敵種別の設定
- (void)setType:(eEnemy)type;

// 敵破壊点を取得する
- (int)getScore;

// サイズの取得
- (eSize)getSize;

// 残りHPの割合を取得(0〜1)
- (float)getHpRatio;

// サイズ・小をすべて消す
+ (void)vanishAllSmall:(eEnemyVanish)type;

/**
 * 弾がヒットした
 * @param dx 弾への距離 (X)
 * @param dy 弾への距離 (Y)
 * @return 死亡したら「YES」
 */
- (BOOL)hit:(float)dx y:(float)dy;

@end
