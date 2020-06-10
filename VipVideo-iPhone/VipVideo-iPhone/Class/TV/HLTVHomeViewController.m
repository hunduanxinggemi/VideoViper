//
//  HLTVHomeViewController.m
//  MVideo
//
//  Created by LHL on 17/2/15.
//  Copyright © 2017年 LHL. All rights reserved.
//

#import "HLTVHomeViewController.h"
#import "HLTVListViewController.h"


#define FileNamePre         @"LiveList"
#define TVHostURL           @"https://iodefog.github.io/text/"
#define VideosTVListName    @"VideosTVListName.txt"

@interface HLTVHomeViewController ()

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation HLTVHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"电台直播";
    
    [self requestNetWorkData];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"HomeTableViewCell"];
}

- (void)requestNetWorkData{
    
    NSString *videosTVListNameUrl = [NSString stringWithFormat:@"%@%@", TVHostURL,VideosTVListName];
    
    __block NSError *error = nil;

    NSString *result = nil;
    if (videosTVListNameUrl) {
        result =  [[NSUserDefaults standardUserDefaults] objectForKey:videosTVListNameUrl];
    }
    [self transformVideoUrlFromString:result error:error];

    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSString *videoList = [NSString stringWithContentsOfURL:[NSURL URLWithString:videosTVListNameUrl] encoding:NSUTF8StringEncoding error:&error];
        error ? NSLog(@"%@", error) : nil;
        [self transformVideoUrlFromString:videoList error:error];
        
        if (videosTVListNameUrl && videoList) {
            [[NSUserDefaults standardUserDefaults] setObject:videoList forKey:videosTVListNameUrl];
        }
    });
}

- (void)transformVideoUrlFromString:(NSString *)videoList error:(NSError *)error
{
    [self.dataSource removeAllObjects];
    NSArray *titleArray = [videoList componentsSeparatedByString:@"\n"];
    for (NSString *title in titleArray) {
        [self.dataSource addObject:@{@"title":title,
                                     @"filePath":[NSString stringWithFormat:@"%@%@", TVHostURL, title]}];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.dataSource[indexPath.row];
    HLTVListViewController *listVC = [[HLTVListViewController alloc] init];
    listVC.dict = dict;
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:YES];
}

@end
