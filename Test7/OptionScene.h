//
//  OptionScene.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/14.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "IScene.h"
#import "InterfaceLayer.h"
#import "AsciiFont.h"
#import "Button.h"
#import "BackOption.h"

static const float BGM_BUTTON_CX = 432;
static const float BGM_BUTTON_CY = 72;
static const float BGM_BUTTON_W  = 40;
static const float BGM_BUTTON_H  = 16;

static const float SE_BUTTON_CX = 432;
static const float SE_BUTTON_CY = 24;
static const float SE_BUTTON_W = 40;
static const float SE_BUTTON_H = 16;

static const float EASY_BUTTON_CX = 56;
static const float EASY_BUTTON_CY = 28;
static const float EASY_BUTTON_W  = 48;
static const float EASY_BUTTON_H  = 16;

static const float BACK_BUTTON_CX = 56;
static const float BACK_BUTTON_CY = 28;
static const float BACK_BUTTON_W  = 48;
static const float BACK_BUTTON_H  = 16;

/**
 * オプション画面
 */
@interface OptionScene : IScene {
    
    CCLayer*        baseLayer;      // 基準レイヤー
    InterfaceLayer* interfaceLayer; // 入力受け取り
    BackOption*     back;           // 背景
    
    Button*         btnBgm;         // ボタン（BGM）
    Button*         btnSe;          // ボタン（SE）
    Button*         btnEasy;        // ボタン（EASY）
    Button*         btnBack;        // タイトル画面に戻る
    
    BOOL            m_bNextScene;   // 次のシーンに進む
}

@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)BackOption*        back;
@property (nonatomic, retain)Button*            btnBgm;
@property (nonatomic, retain)Button*            btnSe;
@property (nonatomic, retain)Button*            btnEasy;
@property (nonatomic, retain)Button*            btnBack;

+ (OptionScene*)sharedInstance;
+ (void)releaseInstance;

@end