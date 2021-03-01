require 'selenium-webdriver'

# ユーザー情報
user_email = "user_test@co.jp"
user_name = "テストユーザー"
user_profile = "aaa"
user_occupation = "bbb"
user_position = "ccc"

#パスワードは全ユーザー共通
password = "aaa111"

d = Selenium::WebDriver.for :chrome
d.manage.timeouts.implicit_wait = 600
d.navigate.to "https://protospace2020.herokuapp.com/users/sign_up"

d.find_element(:id, 'user_email').send_keys(user_email)
d.find_element(:id, 'user_password').send_keys(password)
d.find_element(:id, 'user_password_confirmation').send_keys(password)
d.find_element(:id, 'user_name').send_keys(user_name)
d.find_element(:id, 'user_profile').send_keys(user_profile)
d.find_element(:id, 'user_occupation').send_keys(user_occupation)
d.find_element(:id, 'user_position').send_keys(user_position)
d.find_element(:class,"form__btn").click

sleep 300000000
