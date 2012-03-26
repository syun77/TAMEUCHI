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
    float _x, _y;
    float _vx, _vy;
    float _ax, _ay;
    NSInteger   m_Index;    // 要素番号
    BOOL        m_isExist;  // 存在フラグ
    CCSprite*   m_pSprite;  // スプライト
}

// 初期化
- (void)initialize;

// 座標・移動量の設定
- (void)set:(float)x y:(float)y vx:(float)vx vy:(float)vy ax:(float)ax ay:(float)ay;

- (void)set2:(float)x y:(float)y rot:(float)rot speed:(float)speed ax:(float)ax ay:(float)ay;

// 移動する
- (void)move:(float)dt;

// 要素番号の設定
- (void)setIndex:(NSInteger)index;

// 要素番号の取得
- (NSInteger)getIndex;

// テクスチャをロードしてスプライトを生成
- (void)load:(NSString*)filename;

// 存在するかどうか
- (BOOL)isExist;

// 存在フラグを設定
- (void)setExist:(BOOL)b;

// 消滅処理
- (void)vanish;


// ■プロパティ設定
@property (nonatomic, retain)CCSprite* m_pSprite;
@property (nonatomic, readwrite)float _x;
@property (nonatomic, readwrite)float _y;
@property (nonatomic, readwrite)float _vx;
@property (nonatomic, readwrite)float _vy;
@property (nonatomic, readwrite)float _ax;
@property (nonatomic, readwrite)float _ay;

@end
