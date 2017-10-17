//
//  BuyUCoinsVC.m
//  YouXingWords
//
//  Created by Apple on 2017/6/1.
//  Copyright © 2017年 孙赵凯. All rights reserved.
//

#import "BuyUCoinsVC.h"

#import "BuyUCell.h"
#import "BuyUModel.h"
#import "XMGWaterflowLayout.h"
#import "PayChooseVC.h"

@interface BuyUCoinsVC ()<UICollectionViewDataSource, XMGWaterflowLayoutDelegate,UICollectionViewDelegate>

/**
 *  collectionView 数据源
 */
@property (strong, nonatomic)  NSMutableArray *dataSource;
@property (strong, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic)  BuyUModel *model;
@property (weak, nonatomic) IBOutlet UIButton *btnBuy;

@end

@implementation BuyUCoinsVC





- (IBAction)tapBuy:(id)sender {
    if (!self.model) {
        [MBProgressHUD showError:@"请先选择套餐"];
        return;
    }
    PayChooseVC *payVC = [[PayChooseVC alloc] init];
    payVC.orderNo = self.model.id;
    payVC.money = self.model.money;
    [self.navigationController pushViewController:payVC animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self addBackgroundView];
    [self initNavi];
    
    [self setupLayout];
    [self request];
    
    self.btnBuy.layer.cornerRadius = 4;
    self.btnBuy.layer.masksToBounds = YES;
    self.btnBuy.backgroundColor = ColorNavBG;
}

#pragma mark---添加背景图
-(void)addBackgroundView
{
    UIImageView *backgroundImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    backgroundImg.image=[UIImage imageNamed:@"barrier_bg@2x (2)"];
    [self.view addSubview:backgroundImg];
    [self.view sendSubviewToBack:backgroundImg];
    
}

-(void)initNavi{
    
//    UIImageView *backImg = [[UIImageView alloc]initWithFrame:self.view.bounds];
//    [backImg setImage:[UIImage imageNamed:@"bg_money_red"]];
//    backImg.userInteractionEnabled = YES;
//    
//    [self.view addSubview:backImg];
    
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:YXFrame(15, 67, 120, 60)];
    [backButton setImage:[UIImage imageNamed:@"barrier_icon_back@2x (2)"] forState:UIControlStateNormal];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont systemFontOfSize:AutoTrans(28)];
    [backButton addTarget:self action:@selector(naviPop:) forControlEvents:UIControlEventTouchUpInside];
//    [backButton sizeToFit];
    [self.view addSubview:backButton];
    
    UILabel *_titleLb=[[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-(AutoTrans(150)), AutoTrans(44), AutoTrans(300), 40)];
    _titleLb.textAlignment=NSTextAlignmentCenter;
    _titleLb.text = @"优钻购买";
    _titleLb.textColor=[UIColor whiteColor];
    _titleLb.font=[UIFont systemFontOfSize:AutoTrans(40)];
    [self.view addSubview:_titleLb];
    
}

-(void)naviPop:(UITapGestureRecognizer *)tap{
    [self.navigationController popViewControllerAnimated:YES];
}


- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
static NSString * const ProductID = @"shop";
#define ColorCollcetionViewBG [UIColor colorWithHexString:@"EAEAEA"]
- (void)setupLayout
{
    
    // 创建布局
    XMGWaterflowLayout *layout = [[XMGWaterflowLayout alloc] init];
    layout.delegate = self;
    
    CGRect frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 70);
    // 创建CollectionView
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    

    
    // 注册
    [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([BuyUCell class]) bundle:nil] forCellWithReuseIdentifier:ProductID];
    
    self.collectionView = collectionView;
}


- (void)request{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionary];
    parameters[@"token"] = [Utils getCurrentToken];
    
    [LGDHttpTool POST:CoinsBuyList parameters:parameters success:^(id dictJSON) {
        if ([dictJSON[@"status"] integerValue] == 1) {
            NSArray * array = dictJSON[@"data"];
            for (NSDictionary * dict in array) {
                BuyUModel * model = [BuyUModel mj_objectWithKeyValues:dict];
                [self.dataSource addObject:model];
            }
            [self.collectionView reloadData];
        }else{
            [MBProgressHUD showError:dictJSON[@"error"]];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BuyUModel * model = _dataSource[indexPath.row];
//    BuyUCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuyUModel" forIndexPath:indexPath];
//    BuyUCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BuyUModel" forIndexPath:indexPath];
    BuyUCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ProductID forIndexPath:indexPath];
    [cell setModel:model];

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    self.model = self.dataSource[indexPath.item];
    
}
#pragma mark - <XMGWaterflowLayoutDelegate>
- (CGFloat)waterflowLayout:(XMGWaterflowLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth
{
    //    XMGShop *shop = self.shops[index];
    //宽高比16：21
    
    //    itemWidth * shop.h / shop.w
    //    CGFloat height = itemWidth * 22 / 16;
//    CGFloat height = itemWidth + 52;
    return 70;
}

//
- (CGFloat)rowMarginInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout
{
    return 10;
}

//
- (CGFloat)columnCountInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout
{
    //    if (self.shops.count <= 50) return 2;
    return 3;
}
//
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)columnMarginInWaterflowLayout:(XMGWaterflowLayout *)waterflowLayout{
    return 10;
}


@end
