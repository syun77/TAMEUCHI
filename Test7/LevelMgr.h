//
//  LevelMgr.h
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/07.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

/**
 * レベル管理
 */
@interface LevelMgr : CCNode {
    int m_tPast; // 経過時間
}

// 初期化
- (void)initialize;

// 更新
- (void)update:(ccTime)dt;

@end
