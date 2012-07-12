//
//  Button.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/07/12.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Token.h"
#import "InterfaceLayer.h"
#import "AsciiFont.h"

/**
 * ボタンオブジェクト
 */
@interface Button : Token {
    InterfaceLayer* m_pInput;       // 入力管理
    BOOL            m_bSelected;    // 選択状態かどうか
    BOOL            m_bVisibled;    // 表示可能かどうか
    BOOL            m_bEnabled;     // 有効かどうか
    
    AsciiFont*      m_Text;         // フォント
    
    SEL             m_cbDecide;     // 選択時に呼び出すコールバック
}

@property (nonatomic, retain)AsciiFont* m_Text;

/**
 * 初期パラメータを設定する
 */
- (void)initWith:(NSString*)pText cx:(float)cx cy:(float)cy w:(float)w h:(float)h onDecide:(SEL)onDecide;

// 選択しているかどうか
- (BOOL)isSelected;

// テキストの変更
- (void)setText:(NSString*)pText;


@end
