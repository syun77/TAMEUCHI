//
//  BackTitle.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/05/11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BackTitle.h"
#import "Exerinya.h"
#import "TitleScene.h"

static const float POS_RANK_L = 80;
static const float POS_RANK_R = 480-POS_RANK_L;
static const float POS_RANK_Y = 200;

/**
 * タイトル画面用背景
 */
@implementation BackTitle

- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    [self create];
    
    self._x = System_CenterX();
    self._y = System_CenterY();
    [self move:0];
    
    // 背景画像を設定
    [self setTexRect:Exerinya_GetRect(eExerinyaRect_Back)];
     
    // 変数初期化
    m_tPast = 0;
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    m_tPast++;
}

- (void)visit {
    [super visit];
    
    System_SetBlend(eBlend_Normal);
    
    glColor4f(0, 0, 0, 0.5);
    if ([[TitleScene sharedInstance] isTouchRankSelect]) {
        glColor4f(0.5, 0.5, 0.5, 0.5);
    }
    [self fillRectLT:RANK_SELECT_RECT_X y:RANK_SELECT_RECT_Y w:RANK_SELECT_RECT_W h:RANK_SELECT_RECT_H rot:0 scale:1];
    
    System_SetBlend(eBlend_Add);
    glColor4f(1, 0.2, 0.2, 1);
    
    [self fillTriangle:POS_RANK_L cy:POS_RANK_Y radius:16 rot:270 scale:1];
    [self fillTriangle:POS_RANK_R cy:POS_RANK_Y radius:16 rot:90 scale:1];
    System_SetBlend(eBlend_Normal);
}

@end
