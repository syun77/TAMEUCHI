//
//  Token.m
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Token.h"


@implementation Token

@synthesize m_pSprite;

// 初期化
- (void)initialize {
    
    // 変数初期化
    m_isExist = NO;
}

// テクスチャをロードしてスプライトを生成
- (void)load:(NSString *)filename {
    
    self.m_pSprite = [CCSprite spriteWithFile:filename];
    [self addChild:self.m_pSprite];
}

// 存在するかどうか
- (BOOL)isExist {
    return m_isExist;
}

// 存在フラグを設定
- (void)setExist:(BOOL)b {
    m_isExist = b;
}

// 消滅処理
- (void)vanish {
    
    // スケジューラから破棄
    [self removeAllChildrenWithCleanup:YES];
    
    // 存在フラグを下げる
    [self setExist:NO];
}

@end
