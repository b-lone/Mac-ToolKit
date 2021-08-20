
//#include "spark-client-framework/FileLogger.h"
//#include "spark-client-framework/InitialLogger.h"
//#include "spark-client-framework/DatabaseLogger.h"
#include "RootLogger.h"
//#include "spark-client-framework/TaskTypes.h"
//#include "spark-client-framework/AsyncQueue.h"
//#include "spark-client-framework/LogComponents.h"
//
//#include "spark-client-framework/Utilities/FileUtils.h"
//#include "spark-client-framework/Utilities/StringUtils.h"
//#include "spark-client-framework/Utilities/TimeUtils.h"
//#include "spark-client-framework/Utilities/AsyncUtils.h"
//#include "spark-client-framework/SparkLogger.h"
//
//#include "spark-client-framework/IAsyncQueue.h"

#include <assert.h>
#include <memory>
#include <sstream>
#include <iostream>

namespace overrideable
{
//    using DatabaseLoggingFunc = std::function<void(const std::string&, spark::RootLogger::Level, int, const std::string&, const std::string&)>;
//
//    DatabaseLoggingFunc gDatabaseLoggingFunc = [](const std::string& msg, spark::RootLogger::Level level, int line, const std::string& filename, const std::string& funcname)
//    {
//        // TODO: FedRAMP it should only log to plain text file as we log db errors here
//        spark::RootLogger::sharedInstance().logMessage(msg, level, line, filename, funcname);
//    };
}

namespace spark
{
//    static constexpr auto LevelTrace = "Trace";
//    static constexpr auto LevelDetail = "Detail";
//    static constexpr auto LevelDebug = "Debug";
//    static constexpr auto LevelInfo = "Info";
//    static constexpr auto LevelWarn = "Warn";
//    static constexpr auto LevelError = "Error";
//    static constexpr auto LevelPrivate = "Private";
//    static constexpr auto LevelTest = "Test";
//
//    static constexpr auto PII_FOUND = "********";

//    std::string RootLogger::filterStrings(const std::string& msg)
//    {
//        auto copy = msg;
//        spark::condition_wait done(0);
//        mRootLoggerThreadPool->create_task(__func__, [this, &done, &copy]() mutable {
//            filterStrings(copy, blockListedItems);
//            done.notify();
//        });
//        done.wait();
//        return copy;
//    }
//
//    void RootLogger::filterStrings(std::string& msg, const std::vector<std::string>& blockListItems)
//    {
//        for (const auto& item : blockListItems)
//        {
//            auto pos = msg.find(item);
//            while (pos != std::string::npos)
//            {
//                msg.erase(pos, item.size());
//                msg.insert(pos, PII_FOUND);
//                pos = msg.find(item);
//            }
//        }
//    }

    RootLogger::~RootLogger()
    {
        // the design should mean we never call destructor on this class
        assert(false);
    }

    RootLogger::RootLogger(void)
//        : mRootLoggerThreadPool(std::make_shared<AsyncQueue>("RootLogger"))
    {
    }

//    void RootLogger::initLogger(Logger::Ptr logger, Logger::Ptr wmeLogger, const std::string& logDir, bool secureLog)
//    {
//        Logger::Ptr initialLogger = nullptr;
//
//        auto fileUtils = std::make_shared<FileUtils>();
//
//        if (secureLog)
//        {
//            initialLogger = std::make_shared<InitialLogger>(logDir, fileUtils);
//            registerLogger(initialLogger);
//        }
//
//        registerLogger(logger);
//        mSecureLogEnabled = secureLog;
//
//        if (secureLog)
//        {
//            unregisterLogger(initialLogger);
//
//#ifdef _DEBUG
//            auto fileLogger = std::make_shared<FileLogger>(logDir, 100, fileUtils, false, true);
//            registerLogger(fileLogger);
//#endif
//        }
//
//        if (wmeLogger)
//        {
//            mWMELogger = wmeLogger;
//            mWMELoggerEnable = true;
//        }
//
//        mDefaultDir = logDir;
//    }
//
//    void RootLogger::setLogLocalTime()
//    {
//        mLocalTime = true;
//    }
//
//    void RootLogger::configThreading(std::shared_ptr<IAsyncQueue> rootLoggerThreadPool /*= std::shared_ptr<IAsyncQueue>()*/)
//    {
//        mRootLoggerThreadPool = rootLoggerThreadPool;
//    }

    RootLogger& RootLogger::sharedInstance()
    {
        static RootLogger* rootLoggerInstancePtr = new RootLogger;
        return *rootLoggerInstancePtr;
    }

    void RootLogger::logMessage(const std::string& msg, Level level, int lineNumber, const std::string& filename, const std::string& fnName)
    {
        std::cout << fnName << ":" << msg << std::endl;
    }

//    void RootLogger::setCanLogPii(bool enable)
//    {
//        if (enable)
//        {
//            SPARK_LOG_DEBUG("PRIVATE LOGGING ENABLED. This build may record private info in the log file");
//        }
//
//        mCanLogPii = enable;
//    }
//
//    void RootLogger::setLogLevel(Level level)
//    {
//        mLevel = level;
//    }
//
//    void RootLogger::setTraceLevel(bool enable)
//    {
//        if (enable)
//        {
//            SPARK_LOG_DEBUG("Trace level log enabled");
//        }
//
//        mTraceLevelEnabled = enable;
//    }
//
//    bool RootLogger::getTraceLevel()
//    {
//        return mTraceLevelEnabled;
//    }
//
//    void RootLogger::setLogFilter(const Level level)
//    {
//        mLogFilter = level;
//    }
//
//    void RootLogger::logMessage(const std::string& msg, Level level, int lineNumber, const std::string& filename, const std::string& fnName)
//    {
//        try
//        {
//#ifndef _DEBUG
//            if (level == Level::Trace && !mTraceLevelEnabled)
//            {
//                return;
//            }
//#endif
//
//#ifdef _DEBUG
//            mCanLogPii = true;
//#endif
//            if(!mHasLoggers)
//            {
//                return;
//            }
//
//            if ((level == Level::Private) && !mCanLogPii)
//            {
//                return;
//            }
//
//            // don't log if the level is less than the log level and trace is not enabled
//            if (level < mLevel && !mTraceLevelEnabled)
//            {
//                return;
//            }
//
//            auto checkLevel = [](const auto lhs, const auto rhs)
//            {
//                return static_cast<int>(lhs) < static_cast<int>(rhs);
//            };
//
//            if (const auto filter = mLogFilter.load(); filter != Level::Unknown && checkLevel(level, filter))
//            {
//                return;
//            }
//
//            std::string date;
//            if (mLocalTime)
//            {
//                date = TimeUtils::getCurrentLocalTime();
//            }
//            else
//            {
//                date = TimeUtils::getCurrentTime();
//            }
//
//            std::string levelString;
//            switch (level)
//            {
//                case Level::Trace:
//                    levelString = LevelTrace;
//                    break;
//                case Level::Debug:
//                    levelString = LevelDebug;
//                    break;
//                case Level::Info:
//                    levelString = LevelInfo;
//                    break;
//                case Level::Warn:
//                    levelString = LevelWarn;
//                    break;
//                case Level::Error:
//                    levelString = LevelError;
//                    break;
//                case Level::Private:
//                    levelString = LevelPrivate;
//                    break;
//                case Level::Test:
//                    levelString = LevelTest;
//                    break;
//                case Level::Detail:
//                    levelString = LevelDetail;
//                    break;
//                default:
//                    assert(false);
//            }
//
//            const std::string trimmedFilename = StringUtils::filenameFromPath(filename);
//            auto logComponents = std::make_shared<LogComponents>(date, levelString,
//                                                                 std::this_thread::get_id(),
//                                                                 trimmedFilename,
//                                                                 fnName,
//                                                                 msg,
//                                                                 lineNumber);
//
//            mRootLoggerThreadPool->create_task(__func__, [this, logComponents]() mutable {
//                filterStrings(logComponents->msg, blockListedItems);
//
//                std::stringstream strformattedMsg;
//                strformattedMsg << logComponents->date << " <" << logComponents->levelString << "> ["
//                                << logComponents->threadId << "] " << logComponents->trimmedFilename
//                                << ":" << logComponents->lineNumber << " " << logComponents->fnName << ":" << logComponents->msg;
//
//                const auto formatedStr = strformattedMsg.str();
//                if (mWMELoggerEnable && logComponents->trimmedFilename == "WME")
//                {
//                    mWMELogger->logMessage(formatedStr, *logComponents);
//                }
//                else
//                {
//                    for (const auto& logger : observers)
//                    {
//                        logger->logMessage(formatedStr, *logComponents);
//                    }
//                }
//            },
//                                               TASK_URGENCY::NORMAL, TaskTypes::NORMAL);
//        }
//        catch (...)
//        {
//            // Cant really log anything here...
//            assert(false);
//        }
//    }
//
//    void RootLogger::registerLogger(const Logger::Ptr& logger)
//    {
//        mRootLoggerThreadPool->create_task(__func__, [logger, this]() {
//
//            mHasLoggers = true;
//
//            if (std::find(observers.begin(), observers.end(), logger) == observers.end())
//            {
//                observers.emplace_back(logger);
//            }
//        },
//                                           TASK_URGENCY::NORMAL, TaskTypes::NORMAL);
//    }
//
//    void RootLogger::unregisterLogger(const Logger::Ptr& logger)
//    {
//        mRootLoggerThreadPool->create_task(__func__, [logger, this]() {
//            auto loggerIter = std::find(observers.begin(), observers.end(), logger);
//            if (loggerIter != observers.end())
//            {
//                logger->finalize();
//                observers.erase(loggerIter);
//            }
//            else
//            {
//                logMessage("Logger not found in unregisterLogger ", Level::Error, 0, "RootLogger");
//            }
//        },
//                                           TASK_URGENCY::NORMAL, TaskTypes::NORMAL);
//    }
//
//
//
//    void RootLogger::prepareExit()
//    {
//        logMessage("Exiting. Shutting down logger", Level::Info, 0, "RootLogger");
//
//        if(!mHasLoggers)
//        {
//            return;
//        }
//
//        mRootLoggerThreadPool->create_task(__func__, [this]() {
//            for (const auto& logger : observers)
//            {
//                logger->finalize();
//            }
//            observers.clear();
//        },
//                                           TASK_URGENCY::NORMAL, TaskTypes::NORMAL);
//    }
//
//    void RootLogger::blockListString(const std::string& s)
//    {
//        mRootLoggerThreadPool->create_task(__func__, [this, s]() {
//            if (s.empty())
//            {
//                return;
//            }
//
//            if (std::find(blockListedItems.begin(), blockListedItems.end(), s) == blockListedItems.end())
//            {
//                blockListedItems.push_back(s);
//                std::sort(blockListedItems.begin(), blockListedItems.end(), [](const std::string& l, const std::string r) {
//                    return l.size() > r.size();
//                });
//            }
//        },
//                                           TASK_URGENCY::URGENT, TaskTypes::NORMAL);
//    }
//
//    void RootLogger::clear()
//    {
//        mRootLoggerThreadPool->create_task(__func__, [this]() {
//            for (const auto& logger : observers)
//            {
//                logger->clear();
//            }
//            if (mWMELoggerEnable) {
//                mWMELogger->clear();
//            }
//        },
//                                           TASK_URGENCY::NORMAL, TaskTypes::NORMAL);
//    }
} // namespace spark
