//
//  ViewModel.h
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Componentable.h"

@interface YCMoviePlayerVM : NSObject<YCStates>

@property (nonatomic, assign) BOOL canPlay;

@end
