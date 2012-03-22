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

- (void)create:(NSInteger)size className:(NSString *)className {
    m_Pool = [NSMutableArray arrayWithCapacity:size];
    
    for (int i = 0; i < size; i++) {
        Token* token = [NSClassFromString(className) node];
        [m_Pool addObject:token];
    }
    
    m_Idx = 0;
}

// デストラクタ
- (void)dealloc {
    m_Pool = nil;
    
    [super dealloc];
}

// トークンの追加
- (Token*)add {
    NSInteger cnt = [m_Pool count];
    
    for (int i = 0; i < cnt; i++) {
        Token* ret = [m_Pool objectAtIndex:m_Idx];
        m_Idx++;
        if ([ret isExist] == NO) {
            return ret;
        }
        
    }
    
    return nil;
}

@end
