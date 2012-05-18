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

// ランク選択タッチエリア
static const float RANK_SELECT_RECT_X = 0;
static const float RANK_SELECT_RECT_Y = 160-32;
static const float RANK_SELECT_RECT_W = 480;
static const float RANK_SELECT_RECT_H = 64;

static const float START_BUTTON_RECT_X = 240-64;
static const float START_BUTTON_RECT_Y = 32;
static const float START_BUTTON_RECT_W = 128;
static const float START_BUTTON_RECT_H = 32;

/**
 * タイトル画面
 */
@interface TitleScene : CCScene {
    
    BackTitle*      back;           // 背景
    CCLayer*        baseLayer;      // 描画レイヤー
    InterfaceLayer* interfaceLayer; // 入力受け取り
    AsciiFont*      asciiFont;      // フォント
    AsciiFont*      fontHiScore;    // フォント (ハイスコア)
    AsciiFont*      fontRank;       // フォント (ランク)
    AsciiFont*      fontRankMax;    // フォント (最大ランク)
    AsciiFont*      fontCopyRight;  // フォント（コピーライト）
    
    BOOL            m_bNextScene;   // 次のシーンに進む
    float           m_TouchStartX;  // タッチ開始座標 (X)
    float           m_TouchStartY;  // タッチ開始座標 (Y)
    int             m_RankPrev;     // タッチ前のランク
    BOOL            m_bRankSelect;  // ランク選択タッチ中
}

@property (nonatomic, retain)BackTitle*         back;
@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)AsciiFont*         asciiFont;
@property (nonatomic, retain)AsciiFont*         fontHiScore;
@property (nonatomic, retain)AsciiFont*         fontRank;
@property (nonatomic, retain)AsciiFont*         fontRankMax;
@property (nonatomic, retain)AsciiFont*         fontCopyRight;

+ (TitleScene*)sharedInstance;
+ (void)releaseInstance;

// ランク選択タッチ中
- (BOOL)isTouchRankSelect;

@end
