//
//  CollectionViewController.m
//  FrostMobileTest
//
//  Created by Mikaela Koller on 2016-04-28.
//  Copyright © 2016 Mikaela Koller. All rights reserved.
//

#import "CollectionViewCell.h"
#import "ViewController.h"


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic) NSMutableArray *puffs;
@property (nonatomic, strong) NSMutableDictionary *jsonDictionary;

#define GREEN [UIColor colorWithRed:62.0/255 green:171.0/255 blue:150.0/255 alpha:1.0]
#define CREAMWHITE [UIColor colorWithRed:254.0/255 green:249.0/255 blue:224.0/255 alpha:1.0]

@end

@implementation ViewController 

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self readFromJson];
    
    self.navigationController.navigationBar.barTintColor = GREEN;
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:CREAMWHITE}];
    
    self.webView.hidden = YES;
    self.removeWebview.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionView:) name:@"jsonDone" object:nil];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.collectionView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)updateCollectionView:(NSNotification*)note{
    [self.collectionView reloadData];
}


- (void) readFromJson{
    NSURL *URL = [NSURL URLWithString:@"http://fake-api.frostcloud.se/api"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          
                                          if(error == nil){
                                              self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                              self.puffs = [self.jsonDictionary objectForKey:@"puffs"];
                                              // NSLog(@"puffs = %@",self.jsonDictionary[@"puffs"]);
                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"jsonDone" object:nil];
                                          }
                                    });
                                  }];
    [task resume];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (unsigned long)self.puffs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.backgroundColor = GREEN;
    
    //button
    NSString *buttonText = [[self.puffs objectAtIndex:indexPath.row] objectForKey:@"buttonText"];
    [cell.button setTitle:buttonText forState:UIControlStateNormal];
    [cell.button setTintColor:CREAMWHITE];
    
    cell.button.tag = indexPath.row;
    [cell.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //image
    NSString *path = [[self.puffs objectAtIndex:indexPath.row] objectForKey:@"image"];
    NSURL *url = [NSURL URLWithString:path];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.image.image = image;
    
    return cell;
}

-(void)buttonClicked:(UIButton*)sender{
    //open url in webview
    NSString *currentUrlString = [[self.puffs objectAtIndex:sender.tag] objectForKey:@"url"];
    NSURL *url = [NSURL URLWithString:currentUrlString];
    [self setUpWebView:url];
}

-(void)setUpWebView:(NSURL*)url{
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    
    [UIView animateWithDuration:0.7f animations:^{
        [self.webView setAlpha:0.0f];
        
    }completion:^(BOOL finished) {
        self.webView.hidden = NO;
        self.removeWebview.hidden = NO;
        [UIView animateWithDuration:0.7f animations:^{
            [self.webView setAlpha:1.0f];
        } completion:nil];
        
    }];
    
}

- (IBAction)removeWebview:(id)sender {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];

    [UIView animateWithDuration:0.4f animations:^{
        [self.webView setAlpha:1.0f];
        
    }completion:^(BOOL finished) {
        self.webView.hidden = NO;
        self.removeWebview.hidden = NO;
        [UIView animateWithDuration:0.4f animations:^{
            [self.webView setAlpha:0.0f];
        } completion:nil];
        
    }];
}
@end

