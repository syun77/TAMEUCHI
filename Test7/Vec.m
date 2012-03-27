//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "Vec.h"
#include "Math.h"

void Vec2D_Init(Vec2D* v)
{
    Vec2D_Set(v, 0, 0);
}

void Vec2D_Set(Vec2D* v, float x, float y)
{
    v->x = x;
    v->y = y;
}

void Vec2D_IAdd(Vec2D* v, float dx, float dy)
{
    v->x += dx;
    v->y += dy;
}

void Vec2D_ISub(Vec2D* v, float dx, float dy)
{
    v->x += dx;
    v->y += dy;
}

void Vec2D_Mul(Vec2D* v, float d)
{
    v->x *= d;
    v->y *= d;
}

void Vec2D_Div(Vec2D* v, float d)
{
    if(d == 0.0f)
    {
        return;
    }
    
    v->x /= d;
    v->y /= d;
}

float Vec2D_LengthSq(Vec2D* v)
{
    return v->x * v->x + v->y * v->y;
}

float Vec2D_Length(Vec2D* v)
{
    return Math_Sqrt(Vec2D_LengthSq(v));
}
