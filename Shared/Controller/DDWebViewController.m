//
//  DDWebViewController.m
//  DaoDao
//
//  Created by hetao on 2016/10/27.
//  Copyright © 2016年 soouya. All rights reserved.
//

#import "DDWebViewController.h"
#import "DDReloadView.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"
#import <Masonry/Masonry.h>
#import "SystemServices.h"

@interface DDWebViewController () <UIWebViewDelegate, UIAlertViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) DDReloadView *reloadView;
@property (nonatomic, strong) NJKWebViewProgress *progressProxy;
@property (nonatomic, strong) NJKWebViewProgressView *progressView;

@end

@implementation DDWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    SystemServices *services = [SystemServices sharedServices];
    NSString *userAgent = [NSString stringWithFormat:@"DaoDao/%@ (%@; %@)$%@", [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"], services.systemDeviceTypeFormatted, services.systemsVersion, [SYUtils unifiedUUID]];
    [[NSUserDefaults standardUserDefaults] registerDefaults:[NSDictionary dictionaryWithObject:userAgent forKey:@"UserAgent"]];


    self.webView = [[UIWebView alloc] init];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    self.progressProxy = [[NJKWebViewProgress alloc] init]; // instance variable
    self.webView.delegate = self.progressProxy;
    self.progressProxy.webViewProxyDelegate = self;
    self.progressProxy.progressDelegate = self;

    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    self.progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;

    if (self.url.length > 0) {
        [self startURL:self.url];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.progressView setProgress:0 animated:NO];
    [self.navigationController.navigationBar addSubview:self.progressView];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.progressView removeFromSuperview];
}

- (void)startURL:(NSString *)url
{
    NSArray *urlComponents = [url componentsSeparatedByString:@"?"];
    if (urlComponents.count == 2) {
        NSString *urlString = urlComponents.firstObject;

        NSString *queryString = urlComponents.lastObject;
        queryString = [queryString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        NSString *encodedString = [NSString stringWithFormat:@"%@?%@", urlString, queryString];

        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:encodedString]];
        [self.webView loadRequest:request];
    } else {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [self.webView loadRequest:request];
    }
}


#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{

    [self.progressView setProgress:0 animated:YES];

    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.title = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.progressView setProgress:1.0 animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    if (!self.reloadView) {
        WeakSelf;
        self.reloadView = [DDReloadView showReloadViewOnView:self.view reloadAction:^{
            StrongSelf;
            [strongSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:weakSelf.url]]];
            [strongSelf.reloadView removeFromSuperview];
            strongSelf.reloadView = nil;
        }];
    } else {
        [self showNotice:@"网络异常，请检查网络信号！"];
    }
}

#pragma mark - NJKWebViewProgressDelegate

- (void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    if (self.progressView.progress < progress) {
        [self.progressView setProgress:progress animated:YES];
    }

    self.title = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.title"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
