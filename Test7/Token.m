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

// テクスチャをロードしてスプライトを生成
- (void)load:(NSString *)filename {
    
    m_pSprite = [CCSprite spriteWithFile:filename];
    [self addChild:m_pSprite];
}

// 存在するかどうか
- (BOOL)isExist {
    return m_isExist;
}

// 存在フラグを設定
- (void)setExist:(BOOL)b {
    m_isExist = b;
}

// レイヤーに登録する
- (void)addLayer:(CCLayer*)layer {
    [layer addChild: self.m_pSprite];
}

@end
