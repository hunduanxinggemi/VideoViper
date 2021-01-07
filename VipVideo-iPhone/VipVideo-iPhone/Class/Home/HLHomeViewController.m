//
//  HLHomeViewController.m
//  VipVideo-iPhone
//
//  Created by LiHongli on 2019/1/12.
//  Copyright © 2019 SV. All rights reserved.
//

#import "HLHomeViewController.h"
#import "HLWebVideoViewController.h"
#import "Masonry.h"
#import "VipURLManager.h"
#import <MJRefresh/MJRefresh.h>
#import "ShowMemeryTool.h"

@interface HLHomeCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) VipUrlItem * object;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *    titleLabel;

@end

@implementation HLHomeCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }

    return self;
}

- (void)createUI {
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.iconImageView.backgroundColor    = [UIColor lightGrayColor];
    self.iconImageView.layer.cornerRadius = 10;
    [self.iconImageView setClipsToBounds:YES];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;

    self.titleLabel               = [[UILabel alloc] initWithFrame:CGRectZero];
    self.titleLabel.textColor     = [UIColor lightGrayColor];
    self.titleLabel.font          = [UIFont systemFontOfSize:13];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.titleLabel];

    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(self.contentView.mas_width)
            .multipliedBy(4 / 5.0);
        make.center.equalTo(self.contentView);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
        make.height.mas_equalTo(17);
    }];
    
}

- (void)setObject:(VipUrlItem *)object {
    self.titleLabel.text     = object.title;
    self.iconImageView.image = [UIImage imageNamed:object.icon];
    if (!self.iconImageView.image) {
        self.iconImageView.image = [UIImage imageNamed:@"video_normal"];
    } else {
        self.iconImageView.backgroundColor = [UIColor clearColor];
    }
}

@end

#pragma mark---

#define kHLHomeMaxColumCount 5

@interface HLHomeViewController ()

@property (nonatomic, strong) NSMutableArray *dataArray;
/**
 <#Description#>
 */
@property (nonatomic,strong)UILabel * memeryLabel;
@end

@implementation HLHomeViewController

- (instancetype)init {
    UICollectionViewFlowLayout *flowLayout =
        [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemWidth =
        CGRectGetWidth([UIScreen mainScreen].bounds) / kHLHomeMaxColumCount;
    flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth + 20);
    flowLayout.headerReferenceSize =
        CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 20);

    if (self = [super initWithCollectionViewLayout:flowLayout]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    NSDictionary *infoDictionary =
        [[NSBundle mainBundle] infoDictionary]; //获取app版本信息
    self.title = [infoDictionary objectForKey:@"CFBundleDisplayName"];

    self.view.backgroundColor           = [UIColor whiteColor];
    self.collectionView.backgroundColor = [UIColor whiteColor];

    self.dataArray = [NSMutableArray
        arrayWithArray:[VipURLManager sharedInstance].platformItemsArray];
    [self.collectionView registerClass:[HLHomeCollectionViewCell class]
            forCellWithReuseIdentifier:@"HLHomeCollectionViewCell"];

    MJWeakSelf;
    MJRefreshHeader *headerView =
        [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            NSLog(@"111111");
            [SVProgressHUD
                showWithStatus:
                    @"正在想服务器确认Vip身份，请稍后..."];
            [VipListModel initVipList];
            [weakSelf.collectionView.mj_header endRefreshing];
            dispatch_after(
                dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                dispatch_get_main_queue(),
                ^{

                    [SVProgressHUD dismiss];
                });

        }];
    self.collectionView.mj_header = headerView;
    
    [[[UIApplication sharedApplication] keyWindow] addSubview:self.memeryLabel];
    self.memeryLabel.text  = [NSString stringWithFormat:@"当前使用内存：%ldMB",[ShowMemeryTool useMemoryForApp]];
}

//默认是不支持旋转页面适配的
- (BOOL)shouldAutorotate {
    return NO;
}
//默认支持的页面方向是垂直
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (HLHomeCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                      cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *         cellId = @"HLHomeCollectionViewCell";
    HLHomeCollectionViewCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:cellId
                                                  forIndexPath:indexPath];

    if (indexPath.row < self.dataArray.count) {
        cell.object = self.dataArray[indexPath.row];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id        object = self.dataArray[indexPath.row];
    NSString *userPhone =
        [[NSUserDefaults standardUserDefaults] objectForKey:MyPhone];
    NSArray *vipPhones    = [VipURLManager sharedInstance].phoneArray;
    NSString *validateStr = [LoginModel getUserValidate];

    [[NSUserDefaults standardUserDefaults] setObject:validateStr
                                              forKey:LoginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];

    if ([vipPhones containsObject:userPhone] &&
        [LoginModel checkVipDate]) { //校验权限
        HLWebVideoViewController *videoVC =
            [[HLWebVideoViewController alloc] init];
        videoVC.urlItem  = object;
        NSString *tapUrl = videoVC.urlItem.url;
        [[NSUserDefaults standardUserDefaults] setValue:tapUrl forKey:HLTapUrl];
        [[NSUserDefaults standardUserDefaults] synchronize];
        UINavigationController *videoNav =
            [[UINavigationController alloc] initWithRootViewController:videoVC];
        videoNav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:videoNav animated:YES completion:nil];
    } else {
        [SVProgressHUD showImage:[UIImage imageNamed:@"bilibili"]
                          status:VipAlertString];
        return;
    }
}

/**
 懒加载布局
 所有的都可以改写
 @return <#(nonnull NSString *)#>布局
 */
-(UILabel *)memeryLabel
{
    if (!_memeryLabel){
        
        _memeryLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 100, 200, 40)];
        _memeryLabel.font  = [UIFont systemFontOfSize:18];
        _memeryLabel.textColor  = [UIColor whiteColor];
        _memeryLabel.backgroundColor = [UIColor blackColor];
        _memeryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _memeryLabel;
}
@end
