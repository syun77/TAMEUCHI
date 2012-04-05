//
//  Enemy.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/04.
//  Copyright 2012年 2dgame.jp. All rights reserved.
//

#import "Enemy.h"

#import "Exerinya.h"
#import "GameScene.h"

/**
 * 敵の実装
 */
@implementation Enemy

/**
 * コンストラクタ
 */
- (id)init {
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    [self load:@"all.png"];
    
    NSLog(@"Enemy::Init.");
    
    return self;
    
}

/**
 * 初期化
 */
- (void)initialize {
    [self setRotation:0];
    [self setScale:1];
    
}

/**
 * 敵種別の設定
 */
- (void)setType:(eEnemy)type {
    switch (type) {
        case eEnemy_Nasu:    // ナス
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Nasu)];
            break;
            
        case eEnemy_Tako:    // たこ焼き
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Tako)];
            break;
            
        case eEnemy_5Box:    // ５箱
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_5Box)];
            break;
            
        case eEnemy_Pudding: // プリン
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Pudding)];
            break;
            
        case eEnemy_Milk:    // 牛乳
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Milk)];
            break;
            
        case eEnemy_XBox:    // XBox
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_XBox)];
            break;
            
        case eEnemy_Radish:  // 大根
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Radish)];
            break;
            
        case eEnemy_Carrot:  // 人参
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Carrot)];
            break;
            
        case eEnemy_Pokey:   // ポッキー
            [self setTexRect: Exerinya_GetRect(eExerinyaRect_Pokey)];
            break;
            
        default:
            break;
    }
}

/**
 * 敵の生成
 */

+ (Enemy*)add:(eEnemy)type x:(float)x y:(float)y rot:(float)rot speed:(float)speed {
    GameScene* scene = [GameScene sharedInstance];
    Enemy* e = (Enemy*)[scene.mgrEnemy add];
    if (e) {
        [e set2:x y:y rot:rot speed:speed ax:0 ay:0];
        [e setType:type];
    }
    
    return e;
}

/**
 * 更新
 */
- (void)update:(ccTime)dt {
    
}

@end
