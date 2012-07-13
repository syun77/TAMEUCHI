//
//  Button.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Button.h"

#import <objc/runtime.h>

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
    
    [self load:@"font.png"];
    [self create];
    [self setVisible:NO];
    
    return self;
}

/**
 * デストラクタ
 */
- (void)dealloc {
    
    m_Class  = nil;
    m_pInput = nil;
    
    [super dealloc];
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
}

/**
 * 枠の描画
 */
- (void)visit {
    
    float cx = self._x;
    float cy = self._y;
    float w  = self._w;
    float h  = self._h;
    
    glColor4f(0.2, 0.2, 0.2, 0.5);
    [self fillRect:cx cy:cy w:w+2 h:h+2 rot:0 scale:1];
    
    if (m_bSelected) {
        
        // 選択中
        glColor4f(0, 0, 0.5, 0.4);
    }
    else {
        
        // 非選択
        glColor4f(0.5, 0.5, 0.5, 0.5);
    }
    
    [self fillRect:cx cy:cy w:w h:h rot:0 scale:1];
}

/**
 * 初期パラメータを設定する
 */
- (void)initWith:(InterfaceLayer *)pInput text:(NSString *)pText cx:(float)cx cy:(float)cy w:(float)w h:(float)h cls:(id)cls onDecide:(SEL)onDecide {
    
    self._x = cx;
    self._y = cy;
    self._w = w;
    self._h = h;
    
    m_pInput    = pInput;
    m_bSelected = NO;
    m_bVisibled = YES;
    m_bEnabled  = YES;
    m_cbDecide  = onDecide;
    m_Class     = cls;
    
    [[pInput parent] addChild:self];
    // コールバックに登録
    [pInput addCB:self];
    
    // フォント生成
    self.m_Text = [AsciiFont node];
    [self.m_Text createFont:(CCLayer*)[pInput parent] length:16];
    [self.m_Text setPosScreen:self._x y:self._y];
    [self.m_Text setAlign:eFontAlign_Center];
    [self.m_Text setText:pText];
    
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

/**
 * タッチ開始
 */
- (void)cbTouchStart:(float)x y:(float)y {
    
    if([self isHitPoint:x y:y]) {
            
        // 選択状態
        m_bSelected = YES;
    }
    else {
        
        // 非選択状態
        m_bSelected = NO;
    }
}

/**
 * タッチ移動中
 */
- (void)cbTouchMove:(float)x y:(float)y {
    
    if([self isHitPoint:x y:y]) {
            
        // 選択状態
        m_bSelected = YES;
    }
    else {
        
        // 非選択状態
        m_bSelected = NO;
    }
}

/**
 * タッチ終了
 */
- (void)cbTouchEnd:(float)x y:(float)y {
    
    if (m_bSelected) {
        // 項目を決定した
        Method  method  = class_getInstanceMethod([m_Class class], m_cbDecide);
        IMP     imp     = method_getImplementation(method);
        imp(m_Class, m_cbDecide);
//        [self performSelector:m_cbDecide];
    }
    
    m_bSelected = NO;
}
@end
