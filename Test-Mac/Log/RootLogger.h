//
//  RootLogger.h
//
// All logging macros come to this class which then formats the message and
// passes it to a set of registered loggers.

#pragma once


#include <atomic>
#include <string>
#include <vector>
#include <memory>

//#include <scf_export.h>

class IAsyncQueue;

namespace spark
{
    struct LogComponents;

    // The real loggers will inherit from Logger and then they need to
    // be registered with RootLogger to receive messages.
    class Logger
    {
    public:
        using Ptr = std::shared_ptr<Logger>;
        // The second argument is the filename, which can be used by the specific logger
        // to decide if the message needs special treatment. Most loggers will ignore it.
        // If better resolution is required this could be changed to a catagory later.
        virtual void logMessage(const std::string&, const LogComponents&) = 0;
        // Removes all vestiges of logs produced by this logger
        virtual void clear() = 0;
        // Close io stream
        virtual void finalize() = 0;
        virtual ~Logger() = default;
    };

    class RootLogger
    {
    public:
        enum class Level
        {
            Unknown = 0,
            Trace,
            Detail,
            Debug,
            Info,
            Warn,
            Error,
            Private,
            Test
        };

        RootLogger();
        ~RootLogger();

        static RootLogger& sharedInstance();

//        std::string filterStrings(const std::string& msg);
//        void filterStrings(std::string& msg, const std::vector<std::string>& blockListItems);
//        void setCanLogPii(bool enable);
//        void setLogLevel(Level level);
//        void setTraceLevel(bool enable);
//        bool getTraceLevel();
//        void setLogFilter(const Level level);
//        void initLogger(Logger::Ptr logger, Logger::Ptr wmeLogger, const std::string& logDir, bool secureLog = false);


//        void setLogLocalTime();
//        void configThreading(std::shared_ptr<IAsyncQueue> rootLoggerThreadPool);
        void logMessage(const std::string&, Level level, int lineNumber = 0, const std::string& filename = {}, const std::string& fnName = {});
//        void blockListString(const std::string& s);
//        void clear();
//
//        void registerLogger(const Logger::Ptr& logger);
//        void unregisterLogger(const Logger::Ptr& logger);
//        void prepareExit();
//
//        // If 'configLogger' ls called, then default log will be set and this API is not need to be called anymore.
//        // This is mainly used on Android, uclogin logs will be saved in this directory.
//        void setDefaultDir(const std::string& logDir)
//        {
//            mDefaultDir = logDir;
//        }
//        std::string getDefaultDir() const
//        {
//            return mDefaultDir;
//        }
//
//        bool checkSecureLogEnabled() const
//        {
//            return mSecureLogEnabled;
//        }
//
//    private:
//        std::vector<Logger::Ptr> observers;
//        std::vector<std::string> blockListedItems;
//
//        std::string mDefaultDir;
//        std::atomic<Level> mLogFilter {Level::Unknown};
//        std::atomic<bool> mLocalTime {false};
//
//        // thread for processing log events
//        std::shared_ptr<IAsyncQueue> mRootLoggerThreadPool;
//
//        std::atomic<bool> mHasLoggers {false};
//
//        std::atomic<bool> mCanLogPii{ false };
//
//        std::atomic<bool> mTraceLevelEnabled{ false };
//
//        std::atomic<bool> mSecureLogEnabled{ false };
//
//        std::atomic<Level> mLevel{ Level::Trace };
//
//        // NOTE: This is a simple solution for a specific use case.
//        // In this mode, WME logs only broadcast to mWMELogger, not all observers.
//        // This is likely fine since CoutLogger filters out WME logs as well.
//        //
//        // We can investigate a more generalized solution to component logging.
//        // Ideally we also clean up the file path duplication between RootLogger and FeedbackManager.
//        std::atomic<bool> mWMELoggerEnable{ false };
//        Logger::Ptr mWMELogger;
    };
} // namespace spark
