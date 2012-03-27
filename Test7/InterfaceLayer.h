//
//  InterfaceLayer.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#include "Vec.h"

/**
 * 入力受け取りレイヤー
 */
@interface InterfaceLayer : CCLayer {
    BOOL  m_isTouch; // タッチしているかどうか
    Vec2D m_Pos;     // タッチしている座標
}

// タッチしているかどうか
- (BOOL)isTouch;

// タッチしている座標を取得
- (Vec2D)getPos;

@end
