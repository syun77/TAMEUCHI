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

@interface Charge : Token {
    int m_tPast;    // 経過時間
}

// 座標を設定する
- (void)setPos:(float)x y:(float)y;

@end
