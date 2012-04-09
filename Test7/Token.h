//
//  Token.h
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "System.h"

enum eBlend {
    eBlend_Normal,  // 通常合成 (透過・α付き)
    eBlend_Add,     // 加算合成
    eBlend_Mul,     // 乗算合成
    eBlend_Reverse, // 反転合成
    eBlend_Screen,  // スクリーン合成
    eBlend_XOR,     // 排他的論理和
};

/**
 * トークン基底クラス
 */
@interface Token : CCNode {
    float _x, _y;           // 座標
    float _vx, _vy;         // 移動量
    float _ax, _ay;         // 加速度
    float _w, _h;           // サイズ
    float _r;               // サイズ（半径）
    BOOL        m_ReqVanish; // 削除リクエストフラグ
    NSInteger   m_Index;    // 要素番号
    BOOL        m_isExist;  // 存在フラグ
    BOOL        m_isCreate; // 生成フラグ
    CCSprite*   m_pSprite;  // スプライト
}

// 初期化
- (void)initialize;

// 表示開始
- (void)create;

// 座標・移動量の設定
- (void)set:(float)x y:(float)y vx:(float)vx vy:(float)vy ax:(float)ax ay:(float)ay;

- (void)set2:(float)x y:(float)y rot:(float)rot speed:(float)speed ax:(float)ax ay:(float)ay;

// サイズを設定する
- (void)setSize:(float)w h:(float)h;
- (void)setSize2:(float)r;

// 画面外に出たかどうか
- (BOOL)isOut;

// 画面外に出たかどうか（矩形）
- (BOOL)isOutRect:(float)w h:(float)h;

// 画面外に出たかどうか（円）
- (BOOL)isOutCircle:(float)r;

// 画面外の跳ね返りチェック（矩形）
- (BOOL)isBoundRect:(float)w h:(float)h;

// 画面外の跳ね返りチェック（矩形）
- (BOOL)isBoundRectX:(float)w;

// 画面外の跳ね返りチェック（矩形）
- (BOOL)isBoundRectY:(float)h;

// 画面外の跳ね返りチェック（円）
- (BOOL)isBoundCircle:(float)r;

// 当たり判定チェック
- (BOOL)isHit:(Token*)t;

// 消滅要求
- (void)reqestVanish;

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

// 色を設定する
- (void)setColor:(ccColor3B) color;

// α値を設定する (0〜255)
- (void)setAlpha:(int) alpha;

// ブレンドモードを設定する
- (void)setBlend:(eBlend) mode;

// テクスチャ描画範囲を指定する
- (void)setTexRect:(CGRect) rect;



// ■プロパティ設定
@property (nonatomic, retain)CCSprite* m_pSprite;
@property (nonatomic, readwrite)float _x;
@property (nonatomic, readwrite)float _y;
@property (nonatomic, readwrite)float _vx;
@property (nonatomic, readwrite)float _vy;
@property (nonatomic, readwrite)float _ax;
@property (nonatomic, readwrite)float _ay;
@property (nonatomic, readwrite)float _w;
@property (nonatomic, readwrite)float _h;
@property (nonatomic, readwrite)float _r;

@end
