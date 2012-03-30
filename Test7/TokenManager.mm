//
//  TokenManager.m
//  Test6
//
//  Created by OzekiSyunsuke on 12/03/21.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TokenManager.h"

@implementation TokenManager

@synthesize m_Pool;

/**
 * 生成
 * @param layer     親レイヤー
 * @param size      トークンの数
 * @param className クラス名
 */
- (void)create:(CCLayer *)layer size:(NSInteger)size className:(NSString *)className {
    
    if (self.m_Pool) {
        
        // 生成済み
        assert(0);
    }
    
    // 配列を確保
    self.m_Pool = [NSMutableArray arrayWithCapacity:size];
    
    // トークンのインスタンスを生成
    for (int i = 0; i < size; i++) {
        
        Token* token = [NSClassFromString(className) node];
        if (token == nil) {
            
            // クラス名が違うとか未実装とかでエラー
            NSLog(@"Error: %@ is nil.", className);
            assert(0);
        }
        
        // 要素番号の設定
        [token setIndex:i];
        
        // 配列に追加
        [self.m_Pool addObject:token];
    }
    
    // 初期化・設定
    m_Idx   = 0;
    m_Size  = size;
    m_Layer = layer;
}

// デストラクタ
- (void)dealloc {
    self.m_Pool = nil;
    
    [super dealloc];
}

/**
 * トークンの追加
 * @return トークン（追加出来なかったときは nil)
 */
- (Token*)add {
    
    for (int i = 0; i < m_Size; i++) {
        
        Token* ret = [self.m_Pool objectAtIndex:m_Idx];
        m_Idx = (m_Idx + 1) % m_Size;
        if ([ret isExist] == NO) {
            
            // 空きが見つかったので生成
            [m_Layer addChild:ret];
            
            // 初期化
            [ret initialize];
            
            // 表示開始
            [ret create];
            
            return ret;
        }
        
    }
    
    return nil;
}

- (void)echo {
    NSLog(@"Hello.");
}

@end
