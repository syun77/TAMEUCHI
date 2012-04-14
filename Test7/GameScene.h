//
//  GameScene.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "InterfaceLayer.h"
#import "TokenManager.h"
#import "Back.h"
#import "Player.h"
#import "Aim.h"
#import "AsciiFont.h"
#import "LevelMgr.h"

/**
 * ゲームシーン
 */
@interface GameScene : CCScene {
    CCLayer*        baesLayer;      // 描画レイヤー
    Back*           back;           // 背景画像
    Player*         player;         // プレイヤー
    Aim*            aim;            // 照準
    TokenManager*   mgrShot;        // 自弾
    TokenManager*   mgrEnemy;       // 敵
    TokenManager*   mgrBullet;      // 敵弾
    TokenManager*   mgrParticle;    // パーティクル
    InterfaceLayer* interfaceLayer; // 入力受け取り
    LevelMgr*       levelMgr;       // レベル管理
    AsciiFont*      ascciFont1;     // フォント
    AsciiFont*      ascciFont2;     // フォント
    AsciiFont*      ascciFont3;     // フォント
    AsciiFont*      ascciFont4;     // フォント
    AsciiFont*      ascciFont5;     // フォント
}

@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)Back*              back;
@property (nonatomic, retain)Player*            player;
@property (nonatomic, retain)Aim*               aim;
@property (nonatomic, retain)TokenManager*      mgrShot;
@property (nonatomic, retain)TokenManager*      mgrEnemy;
@property (nonatomic, retain)TokenManager*      mgrBullet;
@property (nonatomic, retain)TokenManager*      mgrParticle;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)LevelMgr*          levelMgr;
@property (nonatomic, retain)AsciiFont*         asciiFont1;
@property (nonatomic, retain)AsciiFont*         asciiFont2;
@property (nonatomic, retain)AsciiFont*         asciiFont3;
@property (nonatomic, retain)AsciiFont*         asciiFont4;
@property (nonatomic, retain)AsciiFont*         asciiFont5;

// シングルトンを取得
+ (GameScene*)sharedInstance;

@end
