//
//  Player.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/03/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"

#import "GameScene.h"

#include "Vec.h"



@implementation Player

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"icon.png"];
    
    return self;
}

- (void)update:(ccTime)dt {
    [self move:dt];
    
    GameScene* scene = [GameScene sharedInstance];
    InterfaceLayer* input = scene.interfaceLayer;
    
    if ([input isTouch]) {
        float x = [input getPosX];
        float y = [input getPosY];
        Vec2D vT = Vec2D(x, y);
        Vec2D vP = Vec2D(self._x, self._y);
        Vec2D vM = vT - vP;
//        vM.Normalize();
        vM *= 0.5f;
        
        self._x += vM.x;
        self._y += vM.y;
    }
}

@end
