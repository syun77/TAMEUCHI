//
//  Bullet.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/31.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"

// 敵弾実装
@interface Bullet : Token {
    int m_Timer;
}

// オブジェクト追加
+ (Bullet*)add:(float)x y:(float)y rot:(float)rot speed:(float)speed;

// ダメージ
- (void)damage:(Token*)t;

@end
