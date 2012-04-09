//
//  Shot.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * 自弾
 */
@interface Shot : Token {
    int m_Timer; 
}

// 敵に当たった
- (void)hit:(float)x y:(float)y;

// 弾の生成
+ (Shot*)add:(float)x y:(float)y rot:(float)rot speed:(float)speed;

@end
