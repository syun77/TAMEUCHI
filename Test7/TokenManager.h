//
//  TokenManager.h
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

#import "Token.h"

/**
 * トークン管理クラス
 */
@interface TokenManager : CCNode {
    CCLayer*        m_Layer; // トークン描画用レイヤー
    NSMutableArray* m_Pool;  // 管理オブジェクト配列
    NSInteger       m_Idx;   // 検索インデックス
    NSInteger       m_Size;  // 配列のサイズ
}

@property (nonatomic,retain)NSMutableArray* m_Pool;

- (void)create:(CCLayer*)layer size:(NSInteger)size className:(NSString*)className;
- (Token*)add;
- (void)echo;

@end
