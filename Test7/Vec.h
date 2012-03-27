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


typedef struct {
    float x;
    float y;
} Vec2D;

void Vec2D_Init(Vec2D* v);
void Vec2D_Set(Vec2D* v, float x, float y);
void Vec2D_IAdd(Vec2D* v, float dx, float dy);
void Vec2D_ISub(Vec2D* v, float dx, float dy);
void Vec2D_Mul(Vec2D* v, float d);
void Vec2D_Div(Vec2D* v, float d);
float Vec2D_LengthSq(Vec2D* v);
float Vec2D_Length(Vec2D* v);

#endif // __JP_2DGAMES_VEC_H__
