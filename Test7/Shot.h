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
 * ショット種別
 */
enum eShot {
    eShot_Normal, // 通常
    eShot_Power,  // パワーショット
};

/**
 * 自弾
 */
@interface Shot : Token {
    eShot   m_Id;
    int     m_Power;
    int     m_Timer; 
}

- (void)setId:(eShot)type;

// 敵に当たった
- (void)hit:(float)x y:(float)y;

// 弾の生成
+ (Shot*)add:(eShot)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed;

@end
