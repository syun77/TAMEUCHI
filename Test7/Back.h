//
//  Back.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * 背景トークン
 */
@interface Back : Token {
    float   m_TargetX;
    float   m_TargetY;
    int     m_State;
    int     m_Timer;
}

// 移動座標の設定
- (void)setTarget:(float)x y:(float)y; 

// 背景変化
- (void)beginDark;
- (void)beginLight;

@end
