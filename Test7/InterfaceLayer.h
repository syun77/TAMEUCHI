//
//  InterfaceLayer.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * 入力受け取りレイヤー
 */
@interface InterfaceLayer : CCLayer {
    BOOL  m_isTouch;    // タッチしているかどうか
    float m_StartX;     // タッチ開始座標(X)
    float m_StartY;     // タッチ開始座標(Y)
    float m_X;          // タッチしている座標(X)
    float m_Y;          // タッチしている座標(Y)
}

// タッチしているかどうか
- (BOOL)isTouch;

// タッチ開始座標
- (float)startX;
- (float)startY;

// タッチ開始座標をリセットする
- (void)resetStartPos;

// タッチしている座標を取得
- (float)getPosX;
- (float)getPosY;

@end
