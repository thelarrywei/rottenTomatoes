//
//  MoviesViewController.h
//  rottenTomatoes
//
//  Created by Larry Wei on 10/13/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITabBarDelegate>
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end
