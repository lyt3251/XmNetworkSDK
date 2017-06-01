// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: Message.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers_RuntimeSupport.h>
#else
 #import "GPBProtocolBuffers_RuntimeSupport.h"
#endif

 #import "Message.pbobjc.h"
// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

#pragma mark - XMBASEMessageRoot

@implementation XMBASEMessageRoot

// No extensions in the file and no imports, so no need to generate
// +extensionRegistry.

@end

#pragma mark - XMBASEMessageRoot_FileDescriptor

static GPBFileDescriptor *XMBASEMessageRoot_FileDescriptor(void) {
  // This is called by +initialize so there is no need to worry
  // about thread safety of the singleton.
  static GPBFileDescriptor *descriptor = NULL;
  if (!descriptor) {
    GPB_DEBUG_CHECK_RUNTIME_VERSIONS();
    descriptor = [[GPBFileDescriptor alloc] initWithPackage:@"XMBASE"
                                                 objcPrefix:@"XMBASE"
                                                     syntax:GPBFileSyntaxProto3];
  }
  return descriptor;
}

#pragma mark - XMBASERequest

@implementation XMBASERequest

@dynamic URL;
@dynamic body;
@dynamic token;
@dynamic version;
@dynamic osName;
@dynamic osVersion;

typedef struct XMBASERequest__storage_ {
  uint32_t _has_storage_[1];
  NSString *URL;
  NSData *body;
  NSString *token;
  NSString *version;
  NSString *osName;
  NSString *osVersion;
} XMBASERequest__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "URL",
        .dataTypeSpecific.className = NULL,
        .number = XMBASERequest_FieldNumber_URL,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(XMBASERequest__storage_, URL),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "body",
        .dataTypeSpecific.className = NULL,
        .number = XMBASERequest_FieldNumber_Body,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(XMBASERequest__storage_, body),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
      {
        .name = "token",
        .dataTypeSpecific.className = NULL,
        .number = XMBASERequest_FieldNumber_Token,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(XMBASERequest__storage_, token),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "version",
        .dataTypeSpecific.className = NULL,
        .number = XMBASERequest_FieldNumber_Version,
        .hasIndex = 3,
        .offset = (uint32_t)offsetof(XMBASERequest__storage_, version),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeString,
      },
      {
        .name = "osName",
        .dataTypeSpecific.className = NULL,
        .number = XMBASERequest_FieldNumber_OsName,
        .hasIndex = 4,
        .offset = (uint32_t)offsetof(XMBASERequest__storage_, osName),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "osVersion",
        .dataTypeSpecific.className = NULL,
        .number = XMBASERequest_FieldNumber_OsVersion,
        .hasIndex = 5,
        .offset = (uint32_t)offsetof(XMBASERequest__storage_, osVersion),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[XMBASERequest class]
                                     rootClass:[XMBASEMessageRoot class]
                                          file:XMBASEMessageRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(XMBASERequest__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\003\001!!!\000\005\006\000\006\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end

#pragma mark - XMBASEResponse

@implementation XMBASEResponse

@dynamic status;
@dynamic statusTxt;
@dynamic body;

typedef struct XMBASEResponse__storage_ {
  uint32_t _has_storage_[1];
  int32_t status;
  NSString *statusTxt;
  NSData *body;
} XMBASEResponse__storage_;

// This method is threadsafe because it is initially called
// in +initialize for each subclass.
+ (GPBDescriptor *)descriptor {
  static GPBDescriptor *descriptor = nil;
  if (!descriptor) {
    static GPBMessageFieldDescription fields[] = {
      {
        .name = "status",
        .dataTypeSpecific.className = NULL,
        .number = XMBASEResponse_FieldNumber_Status,
        .hasIndex = 0,
        .offset = (uint32_t)offsetof(XMBASEResponse__storage_, status),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeInt32,
      },
      {
        .name = "statusTxt",
        .dataTypeSpecific.className = NULL,
        .number = XMBASEResponse_FieldNumber_StatusTxt,
        .hasIndex = 1,
        .offset = (uint32_t)offsetof(XMBASEResponse__storage_, statusTxt),
        .flags = (GPBFieldFlags)(GPBFieldOptional | GPBFieldTextFormatNameCustom),
        .dataType = GPBDataTypeString,
      },
      {
        .name = "body",
        .dataTypeSpecific.className = NULL,
        .number = XMBASEResponse_FieldNumber_Body,
        .hasIndex = 2,
        .offset = (uint32_t)offsetof(XMBASEResponse__storage_, body),
        .flags = GPBFieldOptional,
        .dataType = GPBDataTypeBytes,
      },
    };
    GPBDescriptor *localDescriptor =
        [GPBDescriptor allocDescriptorForClass:[XMBASEResponse class]
                                     rootClass:[XMBASEMessageRoot class]
                                          file:XMBASEMessageRoot_FileDescriptor()
                                        fields:fields
                                    fieldCount:(uint32_t)(sizeof(fields) / sizeof(GPBMessageFieldDescription))
                                   storageSize:sizeof(XMBASEResponse__storage_)
                                         flags:GPBDescriptorInitializationFlag_None];
#if !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    static const char *extraTextFormatInfo =
        "\001\002\t\000";
    [localDescriptor setupExtraTextInfo:extraTextFormatInfo];
#endif  // !GPBOBJC_SKIP_MESSAGE_TEXTFORMAT_EXTRAS
    NSAssert(descriptor == nil, @"Startup recursed!");
    descriptor = localDescriptor;
  }
  return descriptor;
}

@end


#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)
