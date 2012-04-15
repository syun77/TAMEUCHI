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
    
    // エフェクト非表示
    [self reqestEnd];
    m_tPast = 0;
    
    // エフェクト描画設定
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
    
    // 拡縮値設定
    self.scale = (1.0f - time) * 1.5f;
    
    // α値設定
    [self setAlpha:64 + time*192];
    
    [self move:dt];
}

// チャージ開始
- (void)reqestStart:(float)x y:(float)y {
    self._x = x;
    self._y = y;
    [self setVisible:YES];
}

// チャージ終了
- (void)reqestEnd {
    [self setVisible:NO];
}


@end
