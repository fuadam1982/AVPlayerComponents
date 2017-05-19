//
//  Tools.m
//  testModule
//
//  Created by fuhan on 2017/5/16.
//  Copyright © 2017年 fuhan. All rights reserved.
//

#import "Tools.h"
#import <objc/runtime.h>

BOOL conformsToProtocol(Protocol * protocol, Protocol *parentProtocol) {
    unsigned int protocolCount;
    Protocol* __unsafe_unretained* protocolList = protocol_copyProtocolList(protocol, &protocolCount);
    
    for (int i = 0; i< protocolCount; i++) {
        Protocol *protocol = protocolList[i];
        if ([NSStringFromProtocol(protocol) isEqualToString:NSStringFromProtocol(parentProtocol)]) {
            return YES;
        }
    }
    
    free(protocolList);
    return NO;
}

NSDictionary* getPropertiesInfo(objc_property_t *props, unsigned int count, BOOL forReadonly) {
    NSMutableDictionary* propTypes = [[NSMutableDictionary alloc] initWithCapacity:64];
    for (int i = 0; i < count; i++) {
        objc_property_t property = props[i];
        const char * name = property_getName(property);
        const char * type = property_getAttributes(property);
        NSString * typeString = [NSString stringWithUTF8String:type];
        NSArray * attributes = [typeString componentsSeparatedByString:@","];
        
        // 处理只读属性
        if (forReadonly) {
            BOOL isReadonly = NO;
            for (NSString *ta in attributes) {
                if ([ta isEqualToString:@"R"]) {
                    isReadonly = YES;
                    break;
                }
            }
            if (!isReadonly) {
                continue;
            }
        }
        
        // 处理属性encode
        NSString * typeAttribute = [attributes objectAtIndex:0];
        NSString * propertyType = [typeAttribute substringFromIndex:1];
        const char * rawPropertyType = [propertyType UTF8String];
        NSString* key = [NSString stringWithFormat:@"%s", name];
        
        if (strcmp(rawPropertyType, @encode(BOOL)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(BOOL)];
        } else if (strcmp(rawPropertyType, @encode(int)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(int)];
        } else if (strcmp(rawPropertyType, @encode(long)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(long)];
        } else if (strcmp(rawPropertyType, @encode(long long)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(long long)];
        } else if (strcmp(rawPropertyType, @encode(float)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(float)];
        } else if (strcmp(rawPropertyType, @encode(double)) == 0) {
            propTypes[key] = [NSString stringWithFormat:@"%s", @encode(double)];
        } else if (strcmp(rawPropertyType, @encode(id)) == 0) {
            propTypes[key] = @"@";
        } else {
            propTypes[key] = @"@";
        }
    }
    
    return propTypes;
}

////////////////////////////////////////////////////////////

NSDictionary * parseObjProtocolPropertiesInfo(id obj, Protocol *parentProtocol, BOOL forReadonly) {
    NSDictionary *propertiesInfo = nil;
    Class cls = [obj class];
    unsigned count;
    Protocol __unsafe_unretained** protocolList = class_copyProtocolList(cls, &count);
    
    for (unsigned i = 0; i < count; i++) {
        Protocol *protocol = protocolList[i];
        if (![NSStringFromProtocol(protocol) isEqualToString:@"NSObject"]
            && conformsToProtocol(protocol, parentProtocol)) {
            propertiesInfo = parseProtocolPropertiesInfo(protocol, forReadonly);
        }
    }
    
    free(protocolList);
    return propertiesInfo;
}

NSDictionary * parseProtocolPropertiesInfo(Protocol *protocol, BOOL forReadonly) {
    unsigned int count;
    objc_property_t* props = protocol_copyPropertyList(protocol, &count);
    NSDictionary *info = getPropertiesInfo(props, count, forReadonly);
    free(props);
    return info;
}

NSDictionary * parseClassPropertiesInfo(Class class) {
    unsigned int count;
    objc_property_t* props = class_copyPropertyList(class, &count);
    NSDictionary *info = getPropertiesInfo(props, count, NO);
    free(props);
    return info;
}
