//
//  MoviesViewController.m
//  rottenTomatoes
//
//  Created by Larry Wei on 10/13/14.
//  Copyright (c) 2014 Larry Wei. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "SVProgressHUD.h"


@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSString *nextURL;
@property (strong, nonatomic) NSString *currentURL;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UITabBar *tabBar;
@property (weak, nonatomic) IBOutlet UITabBarItem *movieTabItem;


@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Movies";
    
    //hide the network error
    self.networkErrorView.hidden = YES;
    
    //refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];

    [self.refreshControl addTarget:self action:@selector(loadRottenMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];

    //default to movies
    self.nextURL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?page_limit=16&page=1&country=us&apikey=9jnga6dbumrf23uqqvn9hjqa";
    [self.tabBar setSelectedItem:self.movieTabItem];
    self.tabBar.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //load custom cell
    self.tableView.rowHeight = 150;
    
    [self.tableView registerNib: [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieTableViewCell"];
       [self loadRottenMovies];
}

//switching between tabs
- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)tab{
    switch (tab.tag) {
        case 0:
            self.nextURL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/in_theaters.json?page_limit=16&page=1&country=us&apikey=9jnga6dbumrf23uqqvn9hjqa";
            NSLog(@"Selected Movies");
            break;
        case 1:
            self.nextURL = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/current_releases.json?page_limit=16&page=1&country=us&apikey=9jnga6dbumrf23uqqvn9hjqa";
            NSLog(@"Selected DVDs");
            break;
    }
    
    [self loadRottenMovies];
    
}
- (void) loadRottenMovies {
    
    
    if (self.nextURL != self.currentURL) {
        [SVProgressHUD showWithStatus:@"Loading Movies..."];
        self.currentURL = self.nextURL;
    }
    
    NSURL *url = [NSURL URLWithString:self.nextURL];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];

    
    [NSURLConnection sendAsynchronousRequest:request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        self.networkErrorView.hidden = YES;
        if (connectionError) {
            self.networkErrorView.hidden = NO;
        }
        else {
            self.movies = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil][@"movies"];
            NSLog(@"Refreshed");
            
        }
        [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(dismissHUD:) userInfo:nil repeats:NO];
        [self.tableView reloadData];
    }];
    
    
    NSLog(@"Reached here");
    [self.refreshControl endRefreshing];
}

-(void) dismissHUD:(NSTimer *)timer {
    [SVProgressHUD dismiss];
}



- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Displaying row: %ld", indexPath.row);

    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieTableViewCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = [NSString stringWithFormat: @"%@: %@",movie[@"mpaa_rating"], movie[@"synopsis"]];
    
    NSString *imageURL = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.movieImage setImageWithURL: [NSURL URLWithString:imageURL]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"Selected Row: %ld", indexPath.row);
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSLog(@"Deselecting row: %ld", indexPath.row);
    NSDictionary *movie = self.movies[indexPath.row];
    NSLog(@"Selected Movie %@", movie[@"title"]);
    
    DetailsViewController *dvc = [[DetailsViewController alloc] init];
    dvc.movie = movie;
    [self.navigationController pushViewController:dvc animated:YES];
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

- (IBAction)onButton:(id)sender {
}
@end
