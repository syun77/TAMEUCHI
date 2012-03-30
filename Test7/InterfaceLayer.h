//
//  InterfaceLayer.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * 入力受け取りレイヤー
 */
@interface InterfaceLayer : CCLayer {
    BOOL  m_isTouch; // タッチしているかどうか
    float m_X;     // タッチしている座標
    float m_Y;
}

// タッチしているかどうか
- (BOOL)isTouch;

// タッチしている座標を取得
- (float)getPosX;
- (float)getPosY;

@end
