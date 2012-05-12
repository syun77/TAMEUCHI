//
//  GaugeHp.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/18.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * HPゲージ表示
 */
@interface GaugeHp : Token {
    float m_X; // 描画座標(X)
    float m_Y; // 描画座標(Y)
    int m_Now; // 現在のゲージ量
    int m_Max; // 最大のゲージ量
    int m_tPast; // 経過時間
}

// 初期化
- (void)initialize:(int)max;

// 現在値を設定
- (void)set:(int)v x:(float)x y:(float)y;

// 現在値を取得
- (int)getNow;


@end
