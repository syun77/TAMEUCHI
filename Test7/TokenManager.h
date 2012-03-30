//
//  TokenManager.h
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 2dgame.jp. All rights reserved.
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

/**
 * 生成
 * @param layer     親レイヤー
 * @param size      トークンの数
 * @param className クラス名
 */
- (void)create:(CCLayer*)layer size:(NSInteger)size className:(NSString*)className;

/**
 * トークンの追加・取得
 * @return トークン
 */
- (Token*)add;

/**
 * デバッグ表示
 */
- (void)echo;

@end
