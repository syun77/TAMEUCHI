//
//  Player.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Token.h"
#include "Vec.h"

@interface Player : Token {
    Vec2D m_Target;
}

@end
