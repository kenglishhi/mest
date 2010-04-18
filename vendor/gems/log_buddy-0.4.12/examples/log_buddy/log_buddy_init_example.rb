require File.expand_path(File.join(File.dirname(__FILE__), *%w[example_helper]))

describe LogBuddy do
  describe "init" do
    after  { reset_safe_log_buddy_mode }

    it "should call log_gems! if log_gems is true" do
      LogBuddy::GemLogger.expects(:log_gems!)
      LogBuddy.init :log_gems => true
    end
    
    it "doesnt mixin to object if SAFE_LOG_BUDDY is true" do
      LogBuddy.expects(:init).never
      ENV["SAFE_LOG_BUDDY"] = "true"
      load_init
    end

    it "mixin to object if SAFE_LOG_BUDDY is true" do
      LogBuddy.expects(:init).once
      load_init
    end

    def load_init
      silence_warnings do
        load File.join(File.dirname(__FILE__), *%w[.. .. init.rb])
      end
    end

    def reset_safe_log_buddy_mode
      ENV["SAFE_LOG_BUDDY"] = nil
    end
    
    it "should be disabled when the :disabled key is true" do
      LogBuddy.init(:disabled => true)
      fake_logger = mock('logger')
      LogBuddy.stubs(:logger).returns(fake_logger)
      fake_logger.expects(:debug).never
      d { "Hello, World!" }
    end
  end

end