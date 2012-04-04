//
//  Back.m
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Back.h"
#import "Exerinya.h"

/**
 * 背景トークン実装
 */
@implementation Back

/**
 * 初期化
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    [self create];
    
    self._x = 480 / 2;
    self._y = 320 / 2;
    
    // 背景画像を設定
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Back)];
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
}
@end
