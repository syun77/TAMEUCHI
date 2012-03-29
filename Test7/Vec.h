//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#ifndef __JP_2DGAMES_VEC_H__
#define __JP_2DGAMES_VEC_H__

#include "Math.h"

/**
 * 2次元ベクトル
 */
typedef struct {
    float x; // 座標(X)
    float y; // 座標(Y)
} Vec2D;

// 初期化
void Vec2D_Init(Vec2D* v);

// 設定
void Vec2D_Set(Vec2D* v, float x, float y);

// 加算代入
void Vec2D_IAdd(Vec2D* v, float dx, float dy);

// 減算代入
void Vec2D_ISub(Vec2D* v, float dx, float dy);

// 乗算代入
void Vec2D_Mul(Vec2D* v, float d);

// 除算代入
void Vec2D_Div(Vec2D* v, float d);

// 距離の２乗
float Vec2D_LengthSq(Vec2D* v);

// 距離
float Vec2D_Length(Vec2D* v);

#endif // __JP_2DGAMES_VEC_H__
