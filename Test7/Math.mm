//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 2dgame.jp. All rights reserved.
//

#include "Math.h"
#import "cocos2d.h"

static const float PI = 3.1415927;

// 数学関数の初期化
void Math_Init()
{
    // 乱数を初期化する
    struct timeval t;
    gettimeofday(&t, nil);
    unsigned int i;
    i = t.tv_sec;
    i += t.tv_usec;
    srandom(i);    
}

// 度をラジアンに変換する
float Math_Deg2Rad(float deg)
{
    return deg * PI / 180.0f;
}

// ラジアンを度に変換する
float Math_Rad2Deg(float rad)
{
    return rad * 180.0f / PI;
}

// コサインを求める
float Math_Cos(float rad)
{
    return cosf(rad);
}

// サインを求める
float Math_Sin(float rad)
{
    return sinf(rad);
}

// 平方根を求める
float Math_Sqrt(float a)
{
    return sqrt(a);
}

// コサインを求める(度指定)
float Math_CosEx(float deg)
{
    return Math_Cos(Math_Deg2Rad(deg));
}

// サインを求める(度指定)
float Math_SinEx(float deg)
{
    return Math_Sin(Math_Deg2Rad(deg));
}

// アークタンジェントを求める
float Math_Atan2(float y, float x)
{
    return atan2f(y, x);
}

// アークタンジェントを求める（度）
float Math_Atan2Ex(float y, float x)
{
    return Math_Rad2Deg(Math_Atan2(y, x));
}

// 乱数の取得
int Math_Rand(int range)
{
    return random() % range;
}

// 乱数の取得 (float 指定)
float Math_Randf(float range)
{
    return CCRANDOM_0_1() * range;
}
