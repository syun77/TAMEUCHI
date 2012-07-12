//
//  Button.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Button.h"


@implementation Button

@synthesize m_Text;

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    [self create];
    [self setVisible:NO];
    
    return self;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
    if ([m_pInput isTouch]) {
        float px = [m_pInput getPosX];
        float py = [m_pInput getPosY];
        
        if([self isHitPoint:px y:py]) {
            
            // 選択状態
            m_bEnabled = YES;
        }
        else {
            
            // 非選択状態
            m_bEnabled = NO;
        }
    }
    else {
        
        // 非選択状態
        m_bEnabled = NO;
    }
    
    
    if (NO) {
        // 項目を決定した
        [self performSelector:m_cbDecide];
    }
}

/**
 * 枠の描画
 */
- (void)visit {
    
    float cx = self._x;
    float cy = self._y;
    float w  = self._w;
    float h  = self._h;
    
    glColor4f(0.5, 0.5, 0.5, 0.5);
    [self fillRect:cx cy:cy w:w+2 h:h+2 rot:0 scale:1];
    
    if (m_bSelected) {
        
        // 選択中
        glColor4f(0, 0, 0.5, 0.4);
    }
    else {
        
        // 非選択
        glColor4f(0.2, 0.2, 0.2, 0.5);
    }
    
    [self fillRect:cx cy:cy w:w h:h rot:0 scale:1];
}

/**
 * 初期パラメータを設定する
 */
- (void)initWith:(NSString *)pText cx:(float)cx cy:(float)cy w:(float)w h:(float)h onDecide:(SEL)onDecide {
    
    self._x = cx;
    self._y = cy;
    self._w = w;
    self._h = h;
    
    m_bSelected = NO;
    m_bVisibled = YES;
    m_bEnabled  = YES;
    m_cbDecide = onDecide;
    
}

/**
 * 選択中かどうか
 */
- (BOOL)isSelected {
    return m_bSelected;
}

/**
 * 文字を設定をする
 */
- (void)setText:(NSString *)pText {
    [self.m_Text setText:pText];
}

@end
