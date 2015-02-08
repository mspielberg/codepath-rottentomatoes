//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by Miles Spielberg on 2/2/15.
//  Copyright (c) 2015 OrionNet. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieDetailViewController.h"
#import "UIImageView+AnimationUtils.h"
#import "UIImage+Crop.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (strong, nonatomic) UIImage *blankPoster;
@property (strong, nonatomic) NSURL *moviesEndpoint;
@property (strong, nonatomic) NSURL *activeEndpoint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) UIRefreshControl* refreshControl;
@property (atomic) CFTimeInterval lastSearchTextChangeTime;
@property (weak, nonatomic) IBOutlet UILabel *networkFailureLabel;
@end

@implementation MoviesViewController

- (MoviesViewController *)initWithEndpoint:(NSURL *)endpoint {
    self = [super init];
    if (self) {
        _moviesEndpoint = endpoint;
        _activeEndpoint = endpoint;
        _blankPoster = [[UIImage imageNamed:@"icons-v2.png"] crop:CGRectMake(0.0, 0.0, 1.0, 1.0)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MovieCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"movieCell"];
    
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    if (!self.movies)
        [self refresh];
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

#pragma mark Table methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
//    NSLog(@"Loaded cell %lx for row %ld", (unsigned long)cell, (long)indexPath.row);
    
    NSDictionary *movie = self.movies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    [cell.synopsisLabel sizeToFit];
    
    NSURL *posterThumbUrl = [NSURL URLWithString:[movie valueForKeyPath:@"posters.thumbnail"]];
    [cell.posterView setImageWithURL:posterThumbUrl placeholderImage:self.blankPoster duration:0.3];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieDetailViewController *detailController = [[MovieDetailViewController alloc] init];
    detailController.thumbnail = ((MovieCell*)[tableView cellForRowAtIndexPath:indexPath]).posterView.image;
    detailController.movie = self.movies[indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
    [self.searchBar endEditing:NO];
    return nil;
}

#pragma mark UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    CFTimeInterval scheduledAt = CACurrentMediaTime();
    self.lastSearchTextChangeTime = scheduledAt;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(500 * NSEC_PER_MSEC)), dispatch_get_main_queue(), ^{
        if (self.lastSearchTextChangeTime == scheduledAt)
            [self updateWithSearchText:searchText];
    });
}

- (void)updateWithSearchText:(NSString *)searchText {
    if (searchText.length > 0) {
        NSURLComponents *components = [NSURLComponents componentsWithString:@"http://api.rottentomatoes.com/api/public/v1.0/movies.json"];
        components.queryItems = @[
                                  [NSURLQueryItem queryItemWithName:@"apikey" value:@"38sbnkdmjjn89daz4w2z6dtm"],
                                  [NSURLQueryItem queryItemWithName:@"q"      value:searchText]
                                  ];
        self.activeEndpoint = components.URL;
    } else {
        self.activeEndpoint = self.moviesEndpoint;
    }
    
    [self refresh];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:NO];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar endEditing:NO];
}

#pragma mark Refresh control

- (void)onRefresh {
    [self refresh];
    [self.refreshControl endRefreshing];
}

- (void)refresh {
    [SVProgressHUD show];
    NSURLRequest *req = [NSURLRequest requestWithURL:self.activeEndpoint];
    NSLog(@"Connecting to %@", req);
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse* response, NSData* data, NSError* connectionError) {
        if (data) {
            NSDictionary *boxOffice = [NSJSONSerialization JSONObjectWithData:data options:0L error:nil];
            if (boxOffice) {
                self.movies = boxOffice[@"movies"];
                [SVProgressHUD dismiss];
                self.networkFailureLabel.hidden = YES;
                [self.tableView reloadData];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:@"Could not connect to network"];
            self.networkFailureLabel.hidden = NO;
        }
    }];
}

@end
