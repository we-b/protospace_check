require 'selenium-webdriver'

d = Selenium::WebDriver.for :chrome
d.manage.timeouts.implicit_wait = 600
d.navigate.to "https://google.com/"

# ターミナルへページタイトルを出力
puts d.title
puts "seleniumの初期設定完了しました。"

#閉じる
d.quit
