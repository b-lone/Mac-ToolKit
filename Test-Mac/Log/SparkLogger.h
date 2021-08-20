#pragma once
#include <sstream>

#include "RootLogger.h"
#include "ObfuscatedString.h"

#ifndef __ANDROID__
#define SPARK_LOG_MESSAGE_LEVEL(level, messageStream)  \
do {\
    std::ostringstream _oss; _oss << messageStream; \
    constexpr static auto filename = OBFS(__FILE__);   \
    static_assert(filename.length() > 2, "Invalid file name, must be at least three characters - ie x.h"); \
    constexpr static auto funcname = OBFS(__FUNCTION__);   \
    static_assert(funcname.length() > 0, "Invalid function name, must be at least one character");  \
    spark::RootLogger::sharedInstance().logMessage(_oss.str(), level, __LINE__, filename, funcname); \
} while (0)
#else
#define SPARK_LOG_MESSAGE_LEVEL(level, messageStream)  \
{\
    std::ostringstream _oss; _oss << messageStream; \
    spark::RootLogger::sharedInstance().logMessage(_oss.str(), level, __LINE__, __FILE__, __FUNCTION__); \
}
#endif

#define SPARK_LOG_MESSAGE(level, messageStream) SPARK_LOG_MESSAGE_LEVEL(spark::RootLogger::Level:: level, messageStream)

#define LOG_EVERY_N_VARNAME_CONCAT(base, line) base ## line
#define LOG_EVERY_N_VARNAME(base, line) LOG_EVERY_N_VARNAME_CONCAT(base, line)
#define LOG_OCCURRENCES LOG_EVERY_N_VARNAME(occurrences_, __LINE__)

#define SPARK_LOG_EVERY_N(level, n, messageStream) \
    static int LOG_OCCURRENCES = 0;\
    if (++LOG_OCCURRENCES > n) LOG_OCCURRENCES -= n; \
    if (LOG_OCCURRENCES == 1) SPARK_LOG_MESSAGE(level, messageStream)

#define SPARK_LOG_TRACE(messageStream) SPARK_LOG_MESSAGE(Trace, messageStream)
#define SPARK_LOG_DETAIL(messageStream) SPARK_LOG_MESSAGE(Detail, messageStream)
#define SPARK_LOG_DEBUG(messageStream) SPARK_LOG_MESSAGE(Debug, messageStream)
#define SPARK_LOG_INFO(messageStream) SPARK_LOG_MESSAGE(Info, messageStream)
#define SPARK_LOG_WARN(messageStream) SPARK_LOG_MESSAGE(Warn, messageStream)
#define SPARK_LOG_ERROR(messageStream) SPARK_LOG_MESSAGE(Error, messageStream)
#define SPARK_LOG_PRIVATE(messageStream) SPARK_LOG_MESSAGE(Private, messageStream)
#define SPARK_LOG_TEST(messageStream) SPARK_LOG_MESSAGE(Test, messageStream)

#define SPARK_LOG_EVERY_N_TRACE(n,messageStream) SPARK_LOG_EVERY_N(Trace, n, messageStream)
#define SPARK_LOG_EVERY_N_DETAIL(n,messageStream) SPARK_LOG_EVERY_N(Detail, n, messageStream)
#define SPARK_LOG_EVERY_N_DEBUG(n,messageStream) SPARK_LOG_EVERY_N(Debug, n, messageStream)
#define SPARK_LOG_EVERY_N_INFO(n,messageStream) SPARK_LOG_EVERY_N(Info, n, messageStream)
#define SPARK_LOG_EVERY_N_WARN(n,messageStream) SPARK_LOG_EVERY_N(Warn, n, messageStream)
#define SPARK_LOG_EVERY_N_ERROR(n,messageStream) SPARK_LOG_EVERY_N(Error, n, messageStream)
#define SPARK_LOG_EVERY_N_PRIVATE(n,messageStream) SPARK_LOG_EVERY_N(Private, n, messageStream)
#define SPARK_LOG_EVERY_N_TEST(n,messageStream) SPARK_LOG_EVERY_N(Test, n, messageStream)

#define SPARK_LOG_BLOCKLIST_STRING(str) \
{\
    spark::RootLogger::sharedInstance().blockListString(str);\
}

// Conditional logs
#define SPARK_LOG_DEBUG_IF(condition, messageStream)  \
{\
if(condition) { SPARK_LOG_DEBUG(messageStream); } \
}
#define SPARK_LOG_WARN_IF(condition, messageStream)  \
{\
if(condition) { SPARK_LOG_WARN(messageStream); } \
}
#define SPARK_LOG_ERROR_IF(condition, messageStream)  \
{\
if(condition) { SPARK_LOG_ERROR(messageStream); } \
}

#define SPARK_RUN_IF_TRACE(expression_with_int_return)  (spark::RootLogger::sharedInstance().getTraceLevel() ? (expression_with_int_return) : -1)

#ifdef __OBJC__
#include <Foundation/NSString.h>
#include <ostream>
inline std::ostream& operator<<(std::ostream& os, const NSString* str)
{
    os << str.UTF8String;
    return os;
}
#endif
