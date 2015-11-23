require 'selenium-webdriver'
gem 'minitest'
require 'minitest/autorun'

class IE_Native_Events < Minitest::Test

  def setup
    @url = 'http://trabulmonkee.github.io/se-repos/ie-native-events/'
    @exp_set_time = 2.0
  end
  
  def teardown
  end
  
  def set_textbox_tester(browser)
    browser.manage.timeouts.implicit_wait = 10
    bool, msg = false, "default msg - #{__method__} failed"
    browser.get(@url)
    tb = browser.find_element(id: 'ptb')
    beg_time = Time.now
    tb.send_keys "test 123"
    end_time = Time.now
    act_set_time = (end_time - beg_time)
    if act_set_time >= @exp_set_time
      msg = "slow performance encountered\n" +
            "set textbox expect time: #{@exp_set_time}\n" +
            "set textbox actual time: #{act_set_time}"
    else
      bool, msg = true, 'success'
    end
    return bool, msg
  end
  
  def click_img_link(browser)
    browser.manage.timeouts.implicit_wait = 10
    il = browser.find_element(id: 'pil')
    puts il.text
    il.click
  end
  
  def test_double_image_link_click_native_events_false_debug
    # clicked twice, when expecting only once
    $DEBUG = true
    puts "Open fiddler to see multiple requests when clicking the image link"
    begin
      driver = Selenium::WebDriver.for(:ie, :native_events => false)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal false, driver.capabilities[:native_events], "native events as no caps ':native_events'"
      driver.get(@url)
      click_img_link(driver)
    ensure
      driver.quit
    end
  end

  def test_no_desired_capabilities_nativeEvents_false
    err = assert_raises ArgumentError do 
      driver = Selenium::WebDriver.for(:ie, :nativeEvents => false)
    end
    assert_equal "unknown option: {:nativeEvents=>false}", err.message
  end

  def test_no_desired_capabilities_nativeEvents_true
    err = assert_raises ArgumentError do 
      driver = Selenium::WebDriver.for(:ie, :nativeEvents => true)
    end
    assert_equal "unknown option: {:nativeEvents=>true}", err.message
  end

  def test_no_desired_capabilities_native_events_false
    # fast performance
    begin
      driver = Selenium::WebDriver.for(:ie, :native_events => false)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal false, driver.capabilities[:native_events], "native events as no caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

  def test_no_desired_capabilities_native_events_true
    # slow performance
    begin
      driver = Selenium::WebDriver.for(:ie, :native_events => true)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal true, driver.capabilities[:native_events], "native events as no caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)      
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_nativeEvents_false
    # slow performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :nativeEvents => false
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal false, driver.capabilities[:native_events], "native events as caps ':nativeEvents'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)      
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_nativeEvents_true
    # slow performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :nativeEvents => true
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal true, driver.capabilities[:native_events], "native events as caps ':nativeEvents'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)      
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_native_events_false
    # slow performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :native_events => false
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal false, driver.capabilities[:native_events], "native events as caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)      
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_nativeEvents_false_require_window_focus_true
    # fast performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :nativeEvents => false,
        :requireWindowFocus => true
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal true, driver.capabilities['requireWindowFocus'], "require window focus as caps ':requireWindowFocus'"
      assert_equal false, driver.capabilities[:native_events], "with requireWindowFocus caps included, native events as caps ':nativeEvents'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_nativeEvents_true_require_window_focus_true
    # fast performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :nativeEvents => true,
        :requireWindowFocus => true
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal true, driver.capabilities['requireWindowFocus'], "require window focus as caps ':requireWindowFocus'"
      assert_equal true, driver.capabilities[:native_events], "with requireWindowFocus caps included, native events as caps ':nativeEvents'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_native_events_false_require_window_focus_false
    # slow performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :native_events => false,
        :requireWindowFocus => false
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal false, driver.capabilities['requireWindowFocus'], "require window focus as caps ':requireWindowFocus'"
      assert_equal false, driver.capabilities[:native_events], "with requireWindowFocus caps included, native events as caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_native_events_true_require_window_focus_false_debug_slow
    # slow performance
    $DEBUG = true
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :native_events => true,
        :requireWindowFocus => false
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal false, driver.capabilities['requireWindowFocus'], "require window focus as caps ':requireWindowFocus'"
      assert_equal true, driver.capabilities[:native_events], "with requireWindowFocus caps included, native events as caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_native_events_false_require_window_focus_true
    # fast performance
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :native_events => false,
        :requireWindowFocus => true
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal true, driver.capabilities['requireWindowFocus'], "require window focus as caps ':requireWindowFocus'"
      assert_equal false, driver.capabilities[:native_events], "with requireWindowFocus caps included, native events as caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

  def test_with_desired_capabilities_native_events_true_require_window_focus_true_debug_fast
    # fast performance
    $DEBUG = true
    begin
      caps = Selenium::WebDriver::Remote::Capabilities.ie(
        :native_events => true,
        :requireWindowFocus => true
      )
      driver = Selenium::WebDriver.for(:ie, :desired_capabilities => caps)
      assert_equal Selenium::WebDriver::Driver, driver.class
      assert_equal true, driver.capabilities['requireWindowFocus'], "require window focus as caps ':requireWindowFocus'"
      assert_equal true, driver.capabilities[:native_events], "with requireWindowFocus caps included, native events as caps ':native_events'"
      bool, msg = set_textbox_tester(driver)
      assert(bool, msg)
    ensure
      driver.quit
    end
  end

end