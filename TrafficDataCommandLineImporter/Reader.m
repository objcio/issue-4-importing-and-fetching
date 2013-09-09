//
// Created by chris on 6/17/13.
//

#import "Reader.h"
#import "NSData+EnumerateComponents.h"



@interface Reader () <NSStreamDelegate>

@property (nonatomic, strong) NSInputStream* inputStream;
@property (nonatomic, strong) NSURL *fileURL;
@property (nonatomic, copy) NSData *delimiter;
@property (nonatomic, strong) NSMutableData *remainder;
@property (nonatomic, copy) void (^callback) (NSUInteger lineNumber, NSString* line);
@property (nonatomic) NSUInteger lineNumber;
@property (nonatomic) NSUInteger bytesReadCount;
@property (nonatomic) NSUInteger totalByteCount;

@end



@implementation Reader

- (id)initWithFileAtURL:(NSURL *)fileURL;
{
    if (![fileURL isFileURL]) {
        return nil;
    }
    self = [super init];
    if (self) {
        self.fileURL = fileURL;
        self.delimiter = [NSData dataWithBytes:"\n" length:1];

        NSNumber *fileSize = nil;
        if (! [self.fileURL getResourceValue:&fileSize forKey:NSURLFileSizeKey error:NULL]) {
            return nil;
        }
        self.totalByteCount = [fileSize unsignedIntegerValue];
    }
    return self;
}

- (void)enumerateLinesWithBlock:(void (^)(NSUInteger lineNumber, NSString *line))block;
{
    
    NSAssert(self.inputStream == nil, @"Cannot process multiple input streams in parallel");
    self.callback = block;

    self.inputStream = [NSInputStream inputStreamWithURL:self.fileURL];
    [self.inputStream open];
    
    [self readInputStream];

    [self.inputStream close];
    self.inputStream = nil;
}

- (void)readInputStream
{
    while (YES) {
        @autoreleasepool {
            NSMutableData *buffer = [NSMutableData dataWithLength:4 * 1024];
            NSInteger length = [self.inputStream read:[buffer mutableBytes] maxLength:[buffer length]];
            if (length <= 0) {
                break;
            }
            self.bytesReadCount += length;
            [buffer setLength:length];
            [self processDataChunk:buffer];
        }
    }
    [self emitLineWithData:self.remainder];
    self.remainder = nil;
}

- (double)relativeProgress
{
    return (self.totalByteCount == 0) ? 0. : (self.bytesReadCount / (double) self.totalByteCount);
}

- (void)processDataChunk:(NSMutableData *)buffer;
{
    if (self.remainder != nil) {
        [self.remainder appendData:buffer];
    } else {
        self.remainder = buffer;
    }
    [self.remainder obj_enumerateComponentsSeparatedBy:self.delimiter usingBlock:^(NSData* component, BOOL last){
        if (!last) {
            [self emitLineWithData:component];
        } else if (0 < [component length]) {
            self.remainder = [component mutableCopy];
        } else {
            self.remainder = nil;
        }
    }];
}

- (void)emitLineWithData:(NSData *)data;
{
    NSUInteger lineNumber = self.lineNumber;
    self.lineNumber = lineNumber + 1;
    if (0 < data.length) {
        NSString *line = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        self.callback(lineNumber, line);
    }
}

@end
