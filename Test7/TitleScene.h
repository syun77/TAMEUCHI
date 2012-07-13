//
//  TitleScene.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/21.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "InterfaceLayer.h"
#import "AsciiFont.h"
#import "BackTitle.h"
#import "Button.h"

// ランク選択タッチエリア
static const float RANK_SELECT_RECT_X = 0;
static const float RANK_SELECT_RECT_Y = 160-32;
static const float RANK_SELECT_RECT_W = 480;
static const float RANK_SELECT_RECT_H = 64;

static const float START_BUTTON_CX = 240;
static const float START_BUTTON_CY = 72;
static const float START_BUTTON_W  = 96;
static const float START_BUTTON_H  = 24;

static const float BGM_BUTTON_CX = 432;
static const float BGM_BUTTON_CY = 72;
static const float BGM_BUTTON_W  = 40;
static const float BGM_BUTTON_H  = 16;

static const float SE_BUTTON_CX = 432;
static const float SE_BUTTON_CY = 24;
static const float SE_BUTTON_W = 40;
static const float SE_BUTTON_H = 16;

static const float EASY_BUTTON_CX = 8+48;
static const float EASY_BUTTON_CY = 28;
static const float EASY_BUTTON_W  = 48;
static const float EASY_BUTTON_H  = 16;

/**
 * タイトル画面
 */
@interface TitleScene : CCScene {
    
    BackTitle*      back;           // 背景
    CCLayer*        baseLayer;      // 描画レイヤー
    InterfaceLayer* interfaceLayer; // 入力受け取り
    AsciiFont*      asciiFont;      // フォント
    AsciiFont*      fontLite;       // フォント (Lite)
    AsciiFont*      fontHiScore;    // フォント (ハイスコア)
    AsciiFont*      fontRank;       // フォント (ランク)
    AsciiFont*      fontRankMax;    // フォント (最大ランク)
    AsciiFont*      fontCopyRight;  // フォント（コピーライト）
    
    Button*         btnStart;       // ボタン（スタート）
    Button*         btnBgm;         // ボタン（BGM）
    Button*         btnSe;          // ボタン（SE）
    Button*         btnEasy;        // ボタン（EASY）
    
    BOOL            m_bNextScene;   // 次のシーンに進む
    float           m_TouchStartX;  // タッチ開始座標 (X)
    float           m_TouchStartY;  // タッチ開始座標 (Y)
    int             m_RankPrev;     // タッチ前のランク
    BOOL            m_bRankSelect;  // ランク選択タッチ中
    
    BOOL            m_bInit;
}

@property (nonatomic, retain)BackTitle*         back;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)AsciiFont*         asciiFont;
@property (nonatomic, retain)AsciiFont*         fontLite;
@property (nonatomic, retain)AsciiFont*         fontHiScore;
@property (nonatomic, retain)AsciiFont*         fontRank;
@property (nonatomic, retain)AsciiFont*         fontRankMax;
@property (nonatomic, retain)AsciiFont*         fontCopyRight;
@property (nonatomic, retain)Button*            btnStart;
@property (nonatomic, retain)Button*            btnBgm;
@property (nonatomic, retain)Button*            btnSe;
@property (nonatomic, retain)Button*            btnEasy;

+ (TitleScene*)sharedInstance;
+ (void)releaseInstance;

// ランク選択タッチ中
- (BOOL)isTouchRankSelect;

@end
