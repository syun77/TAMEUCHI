//
//  Lockon.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/06/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"

/**
 * ロックオン表示
 */
@interface Lockon : Token {
    
    int m_State;    // 状態
    int m_Timer;    // タイマー
    int m_Id;
    
    int m_tPast;
}

- (void)start:(float)idx x:(float)x y:(float)y r:(float)r;
- (void)end;

@end
