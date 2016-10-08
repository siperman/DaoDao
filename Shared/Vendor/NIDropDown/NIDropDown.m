//
//  NIDropDown.m
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import "NIDropDown.h"
#import "QuartzCore/QuartzCore.h"

@interface NIDropDown ()
@property(nonatomic, strong) UITableView *table;
@property(nonatomic, strong) UIButton *btnSender;
@property(nonatomic, retain) NSArray *list;
@property(nonatomic, retain) NSArray *imageList;
@property (nonatomic, strong) UIControl *bgView;
@end

@implementation NIDropDown
@synthesize table;
@synthesize btnSender;
@synthesize list;
@synthesize imageList;
@synthesize delegate;
@synthesize animationDirection;

- (id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imgArr:(NSArray *)imgArr direction:(NSString *)direction
{
    btnSender = b;
    animationDirection = direction;
    self.table = (UITableView *)[super init];
    if (self) {
        // Initialization code
        
        CGRect btn = b.frame;
        self.list = [NSArray arrayWithArray:arr];
        self.imageList = [NSArray arrayWithArray:imgArr];
        
        table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, 0)];
        table.delegate = self;
        table.dataSource = self;
        table.backgroundColor = WhiteColor;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.layer.cornerRadius = kCornerRadius;
        table.scrollEnabled = NO;
        
        CGRect frame = [btnSender convertRect:btnSender.frame toView:APP_DELEGATE.window];
        CGFloat offset = 2;
        
        if ([direction isEqualToString:@"up"]) {
            self.frame = CGRectMake(btn.origin.x, btn.origin.y - *height, btn.size.width, *height);
        } else if([direction isEqualToString:@"down"]) {
            self.frame = CGRectMake(btn.origin.x, frame.origin.y - 7.0, btn.size.width, *height - offset);
        }
        
        {
            UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.size.width, btn.size.height)];
            maskView.backgroundColor = [UIColor colorFromHexRGB:@"E7E7E7" alpha:1];
            [self addSubview:maskView];
            
            UILabel *lab = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 0, table.width, btn.size.height)];
            lab.font = btnSender.titleLabel.font;
            lab.backgroundColor = ClearColor;
            lab.text = btnSender.titleLabel.text;
            [self addSubview:lab];
            
            UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12.0, 12.0)];
#ifdef SOOUYA
            img.left = table.width - img.width - 10.0;
#elif SELLER
            img.left = table.width - img.width - 15.0;
#endif
            img.centerY = btn.size.height / 2;
            img.image = Image(@"drop_arrow");
            [self addSubview:img];
            
            [self addSubview:table];
            
            UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, btn.size.height - offset, table.width, 1)];
            sep.backgroundColor = [UIColor colorFromHexRGB:@"CCCCD1" alpha:1];
            [self addSubview:sep];
        }
        
        table.frame = CGRectMake(0, btn.size.height - offset, btn.size.width, *height - btn.size.height);

        [[UIApplication sharedApplication].keyWindow addSubview:self];

        self.layer.borderWidth = 1.0;
        self.layer.borderColor = MainColor.CGColor;
        self.layer.shadowColor = MainColor.CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowOpacity = 0.4;
        self.layer.cornerRadius = kCornerRadius;
        self.backgroundColor = ClearColor;
        
        self.bgView = [[UIControl alloc] initWithFrame:SCREEN_BOUNDS];
        self.bgView.backgroundColor = ClearColor;
        [self.bgView addTarget:self action:@selector(hideDropDown:) forControlEvents:UIControlEventTouchUpInside];
        [[UIApplication sharedApplication].keyWindow insertSubview:self.bgView belowSubview:self];
    }
    return self;
}

-(void)hideDropDown:(UIButton *)b {
    [self.bgView removeFromSuperview];
    [self removeFromSuperview];
    
    [self myDelegate];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView.height / [self.list count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.list count];
}

static NSUInteger labTitleTag = 1000;
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    cell.contentView.clipsToBounds = YES;
    
    UILabel *lab = (UILabel *)[cell viewWithTag:labTitleTag];
    if (!lab) {
        lab = [[UILabel alloc] initWithFrame:cell.bounds];
        lab.left = 10.0;
        lab.font = btnSender.titleLabel.font;
        lab.tag = labTitleTag;
        lab.height = btnSender.height;
        [cell.contentView addSubview:lab];
        
        UIView *sep = [[UIView alloc] initWithFrame:CGRectMake(0, btnSender.height - 1, table.width, 1)];
        sep.backgroundColor = [UIColor colorFromHexRGB:@"CCCCD1" alpha:1];
        [cell.contentView addSubview:sep];
    }
    
    lab.text = [NSString stringWithFormat:@"%@", [list objectAtIndex:indexPath.row]];
    
    cell.textLabel.textColor = BlackColor;
    
    UIView * v = [[UIView alloc] init];
    v.backgroundColor = [UIColor grayColor];
    cell.selectedBackgroundView = v;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    UILabel *lab = (UILabel *)[c viewWithTag:labTitleTag];
    if (lab) {
        [btnSender setTitle:lab.text forState:UIControlStateNormal];
    }
    [self hideDropDown:btnSender];
}

- (void) myDelegate
{
    [self.delegate niDropDownDelegateMethod:self];
}

@end
