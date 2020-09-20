//
//  BlockHandlers.h
//  TestTaskGiphyObjC
//
//  Created by Oleg Soloviev on 03.09.2020.
//  Copyright © 2020 varton. All rights reserved.
//

typedef void (^Block1Bool)(BOOL value);

static inline void Block1BoolSafeCall(Block1Bool action, BOOL value)
{
    if( NULL != action )
    {
        action(value);
    }
}
