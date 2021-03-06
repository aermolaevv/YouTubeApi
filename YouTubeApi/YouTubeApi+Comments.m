//
// Created by Anton Turko on 2/26/16.
// Copyright (c) 2016 Anton Turko. All rights reserved.
//

#import "YouTubeApi+Comments.h"
#import "GTLQueryYouTube.h"
#import "GTLYouTubeLiveChatMessageListResponse.h"
#import "YouTubeComment.h"
#import "GTLYouTubeLiveChatMessage.h"
#import "GTLYouTubeLiveChatMessageSnippet.h"
#import "GTLYouTubeLiveChatMessageAuthorDetails.h"


@implementation YouTubeApi (Comments)


- (void)getCommentsList:(NSString *)chatId withPageToken:(NSString *)pageToken withCompletion:(void(^)(NSArray *, NSString *, NSNumber *))completion {
    GTLQueryYouTube *query = [GTLQueryYouTube queryForLiveChatMessagesListWithLiveChatId:chatId part:@"id, snippet"];
    if (pageToken != nil) {
        query.pageToken = pageToken;
    }
    [self.youTubeService executeQuery:query completionHandler:^(GTLServiceTicket *ticket, GTLYouTubeLiveChatMessageListResponse *response, NSError *error) {
        if (error == nil) {
            NSMutableArray *array = [NSMutableArray new];
            for (GTLYouTubeLiveChatMessage *message in response.items) {
                YouTubeComment *youTubeMessage = [YouTubeComment new];
                youTubeMessage.text = message.snippet.displayMessage;
                youTubeMessage.published = message.snippet.publishedAt.date;
                youTubeMessage.authorName = message.authorDetails.displayName;
                youTubeMessage.profileImageUrl = message.authorDetails.profileImageUrl;
                [array addObject:youTubeMessage];
            }
            completion(array, response.nextPageToken, response.pollingIntervalMillis);
        }
    }];
}


@end