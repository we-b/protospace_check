require 'selenium-webdriver'
require './main'
require './check_list'

#ランダム文字列の生成ライブラリ
require 'securerandom'

#テスト登録用emailのランダム文字列
randm_word = SecureRandom.hex(10) #=> "4a01bbd139f5e94bd249"

# ユーザー情報
@user_email = "user_#{randm_word}@co.jp"
@user_name = "テストユーザー"
@user_profile = "aaa"
@user_occupation = "bbb"
@user_position = "ccc"

# パスワードは全ユーザー共通
@password = "aaa111"

# Prototype投稿情報
@prototype_title = "桜"
@prototype_catch_copy = "自然の息吹"
@prototype_concept = "自然と感情"
@prototype_image_name = "sakura.jpeg"
@prototype_image = "/Users/mizutaryousuke/projects/protospace_check/sakura.jpeg"

@d = Selenium::WebDriver.for :chrome
@wait = Selenium::WebDriver::Wait.new(:timeout => 180000)

# チェック項目の結果や詳細を保存する配列
# チェック項目の内容はハッシュ
# {チェック番号： 3 , チェック合否： "〇" , チェック内容： "〇〇をチェック" , チェック詳細： "○○×"}
@check_log = []

# ユーザー新規登録画面,出品画面,購入画面で表示されるエラーログを保存するハッシュ
@error_log_hash = {}

# 出力文章(メインチェック番号) = [1-001]等のチェック
# @puts_num_array = []
# [[30配列], [], [], .....]
@puts_num_array = Array.new(9).map{Array.new(30, false)}

#各チェックのフラグ変数
@flag_4_001 = 0;

begin
  main()
ensure

   #メインチェック番号の出力([1-001]系のチェック)
   puts "↓↓↓ 【[1-001]系のチェックの詳細】 ↓↓↓"

   #先にfor文に渡すチェック番号配列の長さを整数を生成しておく
   for_end_num = @puts_num_array.length
   for_end_num -= 1
   #index = 0はその他出力情報配列なのでindex = 1から出力していく
   for i in 1..for_end_num
       #各セクション配列の中身を全てループ処理する
       @puts_num_array[i].each{|check|
           #チェック内容が格納されている時だけ出力する
           if check != false
               puts check
           end
       }
   end

  #チェック番号の詳細を出力
  puts "\n\n\n↓↓↓ 【チェック番号の◯×】 ↓↓↓"
  if @check_log.length > 0
      #全てのチェック番号を取得して配列にいれる
      check_log_num_array = @check_log.map { |h| h["チェック番号"] }
      #チェック番号1-50まで出力
      for i in 1..50
          #出力したいチェック番号の配列indexを取得
          index_num = check_log_num_array.index(i)
          #出力番号がなかったら何もしない
          if index_num != nil
              puts "チェック番号" + @check_log[index_num]["チェック番号"].to_s + "： " + @check_log[index_num]["チェック合否"] + "\n"
          end
      end
  end

  #チェック番号の詳細を出力
  puts "\n\n\n↓↓↓ 【チェック番号の詳細】 ↓↓↓"
  if @check_log.length > 0
      #全てのチェック番号を取得して配列にいれる
      check_log_num_array = @check_log.map { |h| h["チェック番号"] }
      #チェック番号1-50までを出力
      for i in 1..50
          #出力したいチェック番号の配列indexを取得
          index_num = check_log_num_array.index(i)
          #出力番号がなかったら何もしない
          if index_num != nil
              puts "--------------------------------------------------------------------------"
              puts "■チェック番号：" + @check_log[index_num]["チェック番号"].to_s + "\n"
              print "■チェック合否：#{@check_log[index_num]["チェック合否"]}\n"
              print "■チェック内容：\n#{@check_log[index_num]["チェック内容"]}\n"
              print "■チェック詳細：\n#{@check_log[index_num]["チェック詳細"]}\n"
          end
      end
      puts "--------------------------------------------------------------------------"
  end

  sleep 300000000
end
