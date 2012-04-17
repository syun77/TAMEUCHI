//
//  Gauge.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/18.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * ゲージ描画モジュール
 */
@interface Gauge : Token {
    int m_Now;  // 現在のゲージ量
    int m_Max;  // 最大のゲージ量
    int m_tPast; // 経過時間
}

// 初期化
- (void)initialize:(int)max;

// 現在値を設定
- (void)set:(int)v x:(float)x y:(float)y;

// 現在値を取得する
- (int)getNow;

// 値を追加する
- (int)add:(int)v;

// 値を減らす
- (int)sub:(int)v;

@end
