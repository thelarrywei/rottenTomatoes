//
//  MovieTableViewCell.h
//  rottenTomatoes
//
//  Created by Larry Wei on 10/16/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;

@end
