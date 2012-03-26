//
//  Token.m
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Token.h"
#import "Math.h"


@implementation Token

@synthesize m_pSprite;
@synthesize _x;
@synthesize _y;
@synthesize _vx;
@synthesize _vy;
@synthesize _ax;
@synthesize _ay;


// 初期化
- (void)initialize {
    
    // 変数初期化
    m_isExist = NO;
}

// 座標・移動量の設定
- (void)set:(float)x y:(float)y vx:(float)vx vy:(float)vy ax:(float)ax ay:(float)ay {
    
    self._x  = x;  self._y  = y;
    self._vx = vx; self._vy = vy;
    self._ax = ax; self._ay = ay;
}

- (void)set2:(float)x y:(float)y rot:(float)rot speed:(float)speed ax:(float)ax ay:(float)ay {
    
    float vx = Math_CosEx(rot) * speed;
    float vy = -Math_SinEx(rot) * speed;
    
    [self set:x y:y vx:vx vy:vy ax:ax ay:ay];
}

// 移動する
- (void)move:(float)dt {
    self._vx += self._ax;
    self._vy += self._ay;
    self._x  += self._vx * dt;
    self._y  += self._vy * dt;
    
    self.position = ccp(self._x, self._y);
}

// 要素番号の設定
- (void)setIndex:(NSInteger)index {
    
    m_Index = index;
}

// 要素番号の取得
- (NSInteger)getIndex {
    
    return m_Index;
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
