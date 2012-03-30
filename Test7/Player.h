//
//  Player.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/30.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"
#include "Vec.h"

/**
 * 自機クラス定義
 */
@interface Player : Token {
    
    Vec2D m_Target; // 目標座標
}

@end
