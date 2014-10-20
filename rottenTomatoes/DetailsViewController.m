//
//  DetailsViewController.m
//  rottenTomatoes
//
//  Created by Larry Wei on 10/18/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *movieImage;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *imageURL = [self.movie valueForKeyPath:@"posters.detailed"];
    NSString *imageURLDetailed = [imageURL stringByReplacingOccurrencesOfString:@"tmb" withString:@"ori"];
    NSLog(@"%@",imageURLDetailed);
    [self.movieImage setImageWithURL: [NSURL URLWithString:imageURL]];
    [self.movieImage setImageWithURL: [NSURL URLWithString:imageURLDetailed]];
    

    //[self.movieImage sizeToFit];
    self.scrollView.delegate = self;
    self.synopsisLabel.text = self.movie[@"synopsis"];
    self.title = self.movie[@"title"];
    self.titleLabel.text = self.title;
    [self.synopsisLabel sizeToFit];
    [self.scrollView setContentSize:CGSizeMake(self.synopsisLabel.frame.size.width, self.synopsisLabel.frame.size.height + 100)];

    [self.view bringSubviewToFront:self.scrollView];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    //[scrollView sizeToFit];
    NSLog(@"Scrolling");
    //self.scrollView.frame = self.view.frame;
    //[self.view bringSubviewToFront:self.scrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
