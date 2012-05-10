//
//  Banana.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/07.
//  Copyright 2012年 2dgames.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * バナナボーナス種別
 */
enum eBanana {
   eBanana_Normal, // 通常 
};


/**
 * バナナボーナス
 */
@interface Banana : Token {
    eBanana m_Id;       // 種別
    int     m_Timer;    // タイマー
}

// 種別の設定
- (void)setId:(eBanana)type;

// バナナボーナスの追加
+ (Banana*)add:(eBanana)type x:(float)x y:(float)y;

@end
