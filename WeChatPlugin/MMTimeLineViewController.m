//
//  MMTimeLineViewController.m
//  WeChatPlugin
//
//  Created by CorbinChen on 2017/3/24.
//  Copyright © 2017年 CorbinChen. All rights reserved.
//

#import "MMTimeLineViewController.h"
#import "MMTimeLineMgr.h"
#import "MMStatusCell.h"
#import "MMStatusImageMediaView.h"
#import "MMStatusLinkMediaView.h"

@interface MMTimeLineViewController () <NSTableViewDataSource, NSTableViewDelegate, MMStatusCellDelegate, MMTimeLineMgrDelegate>

@property (nonatomic, strong) MMTimeLineMgr *timeLineMgr;

@end

@implementation MMTimeLineViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    _timeLineMgr = [MMTimeLineMgr new];
    _timeLineMgr.delegate = self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.wantsLayer = true;
    self.view.layer.backgroundColor = [NSColor colorWithRed:0.9843 green:0.9843 blue:0.9843 alpha:1.0].CGColor;
    
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MMStatusCell" bundle:[NSBundle pluginBundle]] forIdentifier:@"statusCell"];
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MMStatusImageMediaView" bundle:[NSBundle pluginBundle]] forIdentifier:@"statusImageMediaView"];
    [self.tableView registerNib:[[NSNib alloc] initWithNibNamed:@"MMStatusLinkMediaView" bundle:[NSBundle pluginBundle]] forIdentifier:@"statusLinkMediaView"];
    self.tableView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    NSScrollView *scrollView = [self.tableView enclosingScrollView];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(scrollViewDidScroll:) name:NSViewBoundsDidChangeNotification object:scrollView.contentView];
    
}

- (void)viewWillAppear {
    [super viewWillAppear];
    [self.timeLineMgr updateTimeLineHead];
}

-(void)setupContactDetail:(id)sender{
    NSLog(@"%s",__func__);
}
#pragma mark -

- (void)scrollViewDidScroll:(NSNotification *)notification {
    NSScrollView *scrollView = notification.object;
    CGFloat currentPosition = CGRectGetMaxY([scrollView visibleRect]);
    CGFloat contentHeight = [self.tableView bounds].size.height - 5;
    
    if (currentPosition > contentHeight - 2.0) {
        [self onTableViewScrollToBottom];
    }
}

#pragma mark -

- (void)onTableViewScrollToBottom {
    [self.timeLineMgr updateTimeLineTail];
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [self.timeLineMgr getTimeLineStatusCount];
}

#pragma mark - NSTableViewDelegate

- (nullable MMStatusMediaView *)tableView:(NSTableView *)tableView mediaViewForCell:(MMStatusCell *)cell status:(MMStatus *)status {
    
    MMStatusMediaView *mediaView;
    switch (status.mediaType) {
        case MMStatusMediaObjectTypeImage: {
            mediaView = [tableView makeViewWithIdentifier:@"statusImageMediaView" owner:cell];
        }
            break;
        case MMStatusMediaObjectTypeLink: {
            mediaView = [tableView makeViewWithIdentifier:@"statusLinkMediaView" owner:cell];
        }
            break;
        default:
            break;
    }
    return mediaView;
    
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    
    MMStatus *status = [self.timeLineMgr getTimeLineStatusAtIndex:row];
    MMStatusCell *cell = [tableView makeViewWithIdentifier:@"statusCell" owner:tableView];
    MMStatusMediaView *mediaView = [self tableView:tableView mediaViewForCell:cell status:status];
    [cell updateMediaView:mediaView];
    [cell updateViewWithStatus:status];
    cell.delegate = self;
    return cell;
    
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row {
    MMStatus *status = [self.timeLineMgr getTimeLineStatusAtIndex:row];
    return [MMStatusCell calculateHeightForStatus:status inTableView:tableView];
}

#pragma mark - MMStatusCellDelegate

- (void)cell:(MMStatusCell *)cell didClickMediaLink:(NSString *)url {
    
    [[CBGetClass(MMURLHandler) defaultHandler] handleURL:url];
    
}

#pragma mark - MMTimeLineMgrDelegate

- (void)onTimeLineStatusChange {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
