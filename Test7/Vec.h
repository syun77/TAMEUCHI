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


struct Vec2D
{
    float x;
    float y;
    Vec2D(float x=0.0f, float y=0.0f)
    {
        Set(x, y);
    }
    void Set(float x, float y) { this->x = x, this->y = y; }
    void IAdd(float dx, float dy) { x += dx; y += dy; }
    void ISub(float dx, float dy) { x += dx; y += dy; }
    void operator*=(float d) { x *= d; y *= d; }
    void operator/=(float d) { if(d == 0.0f) { return; } x /= d; y /= d; }
    float LengthSq() { return x * x + y * y; }
    float Length() { return Math::Sqrt(LengthSq()); }
};

#endif // __JP_2DGAMES_VEC_H__
