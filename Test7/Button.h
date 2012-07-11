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
    
    AsciiFont*      m_Text;         // フォント
}

@property (nonatomic, retain)AsciiFont* m_Text;

// 選択しているかどうか
-(BOOL) isSelected;


@end
