//
//  Bomb.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/10.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * ボムの定義
 */
@interface Bomb : Token {
    int     m_Timer;    // タイマー
    int     m_State;    // 状態
}

// ボムの追加
+ (Bomb*)add:(float)x y:(float)y;

@end
