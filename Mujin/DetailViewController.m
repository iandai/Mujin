//
//  DetailViewController.m
//  Mujin
//
//  Created by Ian on 2014/06/08.
//  Copyright (c) 2014年 com.yumemi.ian. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Url encoding
    NSString *escapedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                                   kCFAllocatorDefault,
                                                                                                   (CFStringRef)self.kanji, // ←エンコード前の文字列(NSStringクラス)
                                                                                                   NULL,
                                                                                                   (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                                   kCFStringEncodingUTF8));
    
    NSString *fullURL = [@"http://m.hujiang.com/d/jp/" stringByAppendingString:escapedString];
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
    // Load web view
    [self.webView loadRequest:request];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
