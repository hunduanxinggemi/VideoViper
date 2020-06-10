//
//  HLTVListViewController.m
//  MVideo
//
//  Created by LiHongli on 16/6/18.
//  Copyright © 2016年 LHL. All rights reserved.
//

#import "HLTVListViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVKit/AVKit.h>
#import "ListTableViewCell.h"
//#import "KxMovieViewController.h"
#import "HLPlayerViewController.h"
#import "MMovieModel.h"
#import "Masonry.h"
#import "SearchTool.h"
#define CanPlayResult   @"CanPlayResult"

@interface HLTVListViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UITableView       *liveListTableView;
@property (nonatomic, strong) UISwitch          *autoPlaySwitch;
@property (nonatomic, strong) UIViewController  *playerController;
@property (nonatomic, strong) NSMutableArray    *originalSource;
@property (nonatomic, strong) NSMutableArray    *dataSource;
@property (nonatomic, assign) BOOL              kxResetPop;

@property (nonatomic, strong) UISearchBar       *searchBar;

@end

@implementation HLTVListViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.dataSource = [NSMutableArray array];
        self.originalSource = [NSMutableArray array];
    }
    return self;
}

- (void)setNeedsStatusBarAppearanceUpdate{
    self.searchBar.frame = CGRectMake(0, kNavgationBarHeight, self.view.bounds.size.width, 44);
    self.liveListTableView.frame = CGRectMake(0, self.searchBar.frame.size.height + kNavgationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.searchBar.frame.size.height);
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationPortrait;
    self.searchBar.frame = CGRectMake(0, kNavgationBarHeight, self.view.bounds.size.width, 44);
    self.liveListTableView.frame = CGRectMake(0, self.searchBar.frame.size.height + kNavgationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.searchBar.frame.size.height - kNavgationBarHeight);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.dict[@"title"] ?: @"电台直播";

    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.liveListTableView];
    
    [self addBackgroundMethod];
    [self requestNetWorkData];
    [self registerObserver];
    [self addMasonry];
}

/**
 *  添加约束
 */
- (void)addMasonry{
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(@(kNavgationBarHeight));
        make.height.mas_equalTo(44);
    }];
    
    [self.liveListTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.searchBar.mas_bottom);
    }];
}

/**
 *  导航条右边添加自动返回开关
 */
- (void)setNavgationRightItem{
    self.autoPlaySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(100-30, 0, 30, 20)];
    [self.autoPlaySwitch addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    NSNumber *oldValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"kAutoPlaySwitch"];
    self.autoPlaySwitch.on = oldValue ? oldValue.boolValue : YES;
    
    UILabel *tipLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tipLable.userInteractionEnabled = YES;
    tipLable.text = @"自动返回";
    tipLable.font = [UIFont systemFontOfSize:14];
    [tipLable addSubview:self.autoPlaySwitch];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:tipLable];
}


/**
 *  Switch 开关值改变方法回调
 *
 *  @param sender switch
 */
- (void)valueChange:(UISwitch *)sender{
    [[NSUserDefaults standardUserDefaults] setObject:@(sender.on) forKey:@"kAutoPlaySwitch"];
}

/**
 *  添加后台方法
 */
- (void)addBackgroundMethod{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}
    
/**
 *  注册前后台观察者
 *  进入后台，暂停。进去前台，播放
 */
- (void)registerObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)applicationWillEnterForegroundNotification:(NSNotification *)notification{
        [((MPMoviePlayerViewController *)self.playerController).moviePlayer play];
}

- (void)applicationDidEnterBackgroundNotification:(NSNotification *)notification{
        [((MPMoviePlayerViewController *)self.playerController).moviePlayer pause];
}

#pragma mark - Private Method

- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, kNavgationBarHeight, self.view.bounds.size.width, 44)];
        _searchBar.searchBarStyle = UISearchBarStyleDefault;
        _searchBar.tintColor = [UIColor lightTextColor];
        _searchBar.returnKeyType = UIReturnKeySearch;
        _searchBar.placeholder = @"请输入要搜索的文字";
        _searchBar.delegate = self;
    }
    return _searchBar;
}

- (UITableView *)liveListTableView{
    if (_liveListTableView == nil) {
        _liveListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.frame.size.height + kNavgationBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-self.searchBar.frame.size.height) style:UITableViewStylePlain];
        _liveListTableView.delegate = self;
        _liveListTableView.estimatedRowHeight = 100;
        _liveListTableView.rowHeight = UITableViewAutomaticDimension;
        _liveListTableView.dataSource = self;
        [_liveListTableView registerClass:[ListTableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _liveListTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (ListTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellName = @"cellName";
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil) {
        cell = [[ListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellName];
    }
    
    if (indexPath.row < [self.dataSource count]) {
        MMovieModel *model =  self.dataSource[indexPath.row];
        [cell setObject:model];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@-%@",@(indexPath.row+1), model.title];
//        [cell checkIsCanPlay:cell.urlLabel.text fileName:self.dict[@"title"]];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row < [self.dataSource count]) {
        
        ListTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        MMovieModel *model =  self.dataSource[indexPath.row];

        // 可播，则转移到下一个播放
        if (self.autoPlaySwitch.isOn && (model.canPlay == YES)) {
            [self autoPlayNextVideo:indexPath delegate:self];
            return;
        }

        
        if (![tableView.visibleCells containsObject:cell]) {
            if ((indexPath.row+2) < [self.dataSource count]) {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row+2) inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }else {
                [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:(indexPath.row) inSection:indexPath.section] atScrollPosition:UITableViewScrollPositionNone animated:YES];
            }
        }
        
        NSString *videoName = model.title;
        NSString *movieUrl = [model.url stringByReplacingOccurrencesOfString:@"[url]" withString:@""];
        
        NSLog(@"title%@\n url = %@", videoName, movieUrl);
        self.title = videoName;
        
        [self playVideoWithMovieUrl:movieUrl movieName:videoName indexPath:indexPath];
    }
}

-(void)viewDidLayoutSubviews {
    if ([self.liveListTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.liveListTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.liveListTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.liveListTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 54;
}

#pragma mark - private Method

/**
 *  播放某一个index下的视频。对于可播放的，存储。然后根据条件自动判断是否进行下一个视频播放
 *
 *  kxResetPop 当自动进行下一个播放时，设置为NO，当进行点击操作时，变为YES，这样dispatch_after（）就可以判断不用自动进行下一个了。另外条件就是switch开关。
 *
 *  @param movieUrl  视频的播放地址
 *  @param movieName 视频的名称
 *  @param indexPath 当前播放的视频cell的索引
 */
- (void)playVideoWithMovieUrl:(NSString *)movieUrl
                    movieName:(NSString *)movieName
                    indexPath:(NSIndexPath *)indexPath{
    if (movieUrl == nil) {
        return;
    }
    
    HLPlayerViewController *playerVC = [[HLPlayerViewController alloc] init];
    [VipURLManager sharedInstance].currentPlayer = playerVC;
    playerVC.canDownload = NO;
    playerVC.url = [NSURL URLWithString:movieUrl];
    __weak typeof(self) weakself = self;
    [playerVC setBackCompleteBlock:^(BOOL finish) {
        __strong typeof(self) strongself = weakself;
        if (strongself) {
            [strongself dismissViewControllerAnimated:YES completion:nil];
        }
    }];
    
    playerVC.modalPresentationStyle = UIModalPresentationFullScreen;

    [self presentViewController:playerVC animated:YES completion:nil];
}



/**
 *  自动播放下一个cell里的视频
 *
 *  @param currentIndexPath 当前播放的视频cell索引
 *  @param vc 代理
 */
- (void)autoPlayNextVideo:(NSIndexPath *)currentIndexPath delegate:(HLTVListViewController *)vc{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:currentIndexPath.row+1 inSection:0];
    [vc tableView:self.liveListTableView didSelectRowAtIndexPath:indexPath];
}


#pragma mark - SearchBar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"searchBar %@, searchText %@",searchBar.text, searchText );
    if ([searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
        [self filterDataSourceWithKey:searchBar.text finish:NO];
    }else{
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.originalSource];
        [self.liveListTableView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

    if ([searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@""].length > 0) {
        [self filterDataSourceWithKey:searchBar.text finish:YES];
    }else {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:self.originalSource];
        [self.liveListTableView reloadData];
    }
}

#pragma Mark 模糊搜索
- (void)filterDataSourceWithKey:(NSString *)searchKey finish:(BOOL)finish{
    NSArray * resultArr = [SearchTool searchWithOriginalArray:self.originalSource andSearchText:searchKey andSearchByPropertyName:@"title"];
    self.dataSource = [NSMutableArray arrayWithArray:resultArr];
    [self.liveListTableView reloadData];
 
    
}

#define FileNamePre         @"TVLiveList"


- (void)requestNetWorkData{
    
   NSError *error = nil;
      NSString *path = [[NSBundle mainBundle] pathForResource:FileNamePre ofType:@"json"];
      if (!path) {
          return;
      }
      NSData *data = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&error];
    self.dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSArray * movieArr = [self.dict valueForKey:@"TVLive"];
    for (NSDictionary * dic in movieArr) {
        
        [self.dataSource addObject:[MMovieModel hrjsonToModel:dic]] ;
    }
    self.originalSource = self.dataSource;
    [self.liveListTableView reloadData];
}



@end
