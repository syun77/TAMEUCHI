//
//  Exerinya.mm
//  Test7
//
//  Created by OzekiSyunsuke on 12/04/03.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Exerinya.h"


// 指定のタイプに対応する矩形を取得する
CGRect Exerinya_GetRect(eExerinyaRect rect) {
    static const CGRect tbl[] = {
        {0,   0,   128, 128}, // eExerinyaRect_Player1,      // プレイヤー１
        {128, 0,   128, 128}, // eExerinyaRect_Player2,      // プレイヤー２
        {256, 0,   128, 128}, // eExerinyaRect_PlayerDamage, // プレイヤーダメージ
        {0,   128, 128, 128}, // eExerinyaRect_Nasu,         // ナス
        {128, 128, 128, 128}, // eExerinyaRect_5Box,         // 5箱
        {128, 396, 128, 128}, // eExerinyaRect_Tako,         // たこ焼き
        {768, 256, 256, 256}, // eExerinyaRect_Pudding,      // プリン
        {256, 128, 256, 256}, // eExerinyaRect_Milk,         // 牛乳
        {512, 128, 256, 256}, // eExerinyaRect_XBox,         // XBox
        {0,   396, 128, 128}, // eExerinyaRect_Radish,       // 大根
        {128, 256, 128, 128}, // eExerinyaRect_Carrot,       // 人参
    };
    
    return tbl[rect];
}
