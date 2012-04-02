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
#import "Player.h"
#import "AsciiFont.h"

/**
 * ゲームシーン
 */
@interface GameScene : CCScene {
    CCLayer*        baesLayer;
    Player*         player;
    TokenManager*   mgrBullet;
    TokenManager*   mgrParticle;
    InterfaceLayer* interfaceLayer;
    AsciiFont*      ascciFont;
    AsciiFont*      ascciFont2;
}

@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)Player*            player;
@property (nonatomic, retain)TokenManager*      mgrBullet;
@property (nonatomic, retain)TokenManager*      mgrParticle;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)AsciiFont*         asciiFont;
@property (nonatomic, retain)AsciiFont*         asciiFont2;

// シングルトンを取得
+ (GameScene*)sharedInstance;

@end
