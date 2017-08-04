//
//  ViewController.m
//  TestDragAndDrop
//
//  Created by mao guangqing on 2017/6/26.
//  Copyright © 2017年 NetEase, Inc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIDragInteractionDelegate,UIDropInteractionDelegate>
{
    NSMutableArray<UIDragItem *> *sessions;
    UIImageView *dragView ;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIDragInteraction *dragAction = [[UIDragInteraction alloc] initWithDelegate:self];
    [self.view addInteraction:dragAction];
    
    
    UIDropInteraction *dropAction = [[UIDropInteraction alloc] initWithDelegate:self];
    [self.view addInteraction:dropAction];
    
    dragView.interactions = @[dragAction,dropAction];

}

- (NSArray<UIDragItem *> *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session{
    NSItemProvider *itemProvider = [[NSItemProvider alloc] initWithObject:@"hello world"];
    return @[itemProvider];
}


- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session{
    if (session.localDragSession != nil) { //ignore drag session started within app
        return false;
    }
    
    BOOL canHandle = false;
    canHandle = [session canLoadObjectsOfClass:[UIImage class]];
    return canHandle;
    
    
}
- (void)dropInteraction:(UIDropInteraction *)interaction sessionDidEnter:(id<UIDropSession>)session{
    
}
- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session{
    [session loadObjectsOfClass:[UIImage class] completion:^(NSArray<__kindof id<NSItemProviderReading>> * _Nonnull objects) {
        for (id object in objects) {
            UIImage* image = (UIImage*)object;
            if (image) {
                //handle image
                dragView.image = image;
                [sessions addObject:[[UIDragItem alloc] initWithItemProvider:[[NSItemProvider alloc] initWithObject:image]]];
            }
        }
    }];
    
}


- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session{
    return [[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy];
}
- (nullable UITargetedDragPreview *)dropInteraction:(UIDropInteraction *)interaction previewForDroppingItem:(UIDragItem *)item withDefault:(UITargetedDragPreview *)defaultPreview{
    
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
