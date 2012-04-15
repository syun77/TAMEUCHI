//
//  Charge.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/15.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Charge.h"
#import "Exerinya.h"

@implementation Charge

// コンストラクタ
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    [self load:@"all-hd.png"];
    
    [super create];
    [self setPos:System_CenterX() y:System_Height()];
    m_tPast = 0;
    
    CGRect r = Exerinya_GetRect(eExerinyaRect_EftRing);
    [self setTexRect:r];
    
    [self setBlend:eBlend_Add];
    [self setColor:ccc3(0xFF, 0xFF, 0x00)];
    
    return self;
}

// 更新
- (void)update:(ccTime)dt {
    m_tPast++;
    float time = (m_tPast % 30) / 30.0f;
    
    self.scale = (1.0f - time) * 1.5f;
    [self setAlpha:64 + time*192];
    
    [self move:dt];
}

// 座標を設定する
- (void)setPos:(float)x y:(float)y {
    self._x = x;
    self._y = y;
}

@end
