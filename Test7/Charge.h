//
//  Charge.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * チャージエフェクト状態
 */
enum eCharge {
    eCharge_Disable,    // 無効状態
    eCharge_Wait,       // 開始待ち状態
    eCharge_Playing,    // 動作中
};

/**
 * チャージ実装クラス
 */
@interface Charge : Token {
    int     m_Timer;    // 汎用タイマ
    eCharge m_State;    // 状態
}

// パラメータ設定
- (void)setParam:(eCharge)state x:(float)x y:(float)y;

@end
