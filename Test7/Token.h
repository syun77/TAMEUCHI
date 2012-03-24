//
//  Token.h
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Token : CCNode {
    CCSprite*   m_pSprite; // スプライト
    BOOL        m_isExist; // 存在フラグ
}

// 初期化
- (void)initialize;

// テクスチャをロードしてスプライトを生成
- (void)load:(NSString*)filename;

// 存在するかどうか
- (BOOL)isExist;

// 存在フラグを設定
- (void)setExist:(BOOL)b;

// 消滅処理
- (void)vanish;

@property (nonatomic, retain)CCSprite* m_pSprite;

@end
