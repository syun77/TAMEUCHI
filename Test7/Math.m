//
//  Vec.h
//  Test3
//
//  Created by OzekiSyunsuke on 12/03/15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#include "Math.h"

static const float PI = 3.1415927;

float Math_Deg2Rad(float deg) { return deg * PI / 180.0f; }
float Math_Rad2Deg(float rad) { return rad * 180.0f / PI; };
float Math_Cos(float rad) { return cosf(rad); }
float Math_Sin(float rad) { return sinf(rad); }
float Math_Sqrt(float a) { return sqrt(a); }
float Math_CosEx(float deg) { return Math_Cos(Math_Deg2Rad(deg)); }
float Math_SinEx(float deg) { return Math_Sin(Math_Deg2Rad(deg)); }

