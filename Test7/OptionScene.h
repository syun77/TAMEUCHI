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

static const float BACK_BUTTON_CX = 240;
static const float BACK_BUTTON_CY = 72;
static const float BACK_BUTTON_W  = 96;
static const float BACK_BUTTON_H  = 24;

/**
 * オプション画面
 */
@interface OptionScene : IScene {
    
    CCLayer*        baseLayer;      // 基準レイヤー
    InterfaceLayer* interfaceLayer; // 入力受け取り
    BackOption*     back;           // 背景
    
    
    Button*         btnBack;        // タイトル画面に戻る
    
    BOOL            m_bNextScene;   // 次のシーンに進む
}

@property (nonatomic, retain)CCLayer*           baseLayer;
@property (nonatomic, retain)InterfaceLayer*    interfaceLayer;
@property (nonatomic, retain)BackOption*        back;
@property (nonatomic, retain)Button*            btnBack;

+ (OptionScene*)sharedInstance;
+ (void)releaseInstance;

@end
