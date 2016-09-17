#import "RuntimeUtils.h"
#import "../Global.h"
@interface Utils : NSObject {
}
+(id)sharedManager;
+(NSMutableArray*)classListForSelector:(SEL)Selector;
#if 0
-(NSArray*)possibleClassNameFromSignature:(NSString*)className;
#endif
@property(nonatomic,strong) NSDictionary *signatureDatabase;
@property(nonatomic,strong) NSNumber* MinimumMatchConfidence;
@end
