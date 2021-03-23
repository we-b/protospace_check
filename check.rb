require 'ruby_jard'
require 'selenium-webdriver'
require 'securerandom'
require './main'
require './check_list'

#テスト登録用emailのランダム文字列
randm_word = SecureRandom.hex(8) #=> "4a01bbd139f5e94bd249"

# ユーザー情報
@user_email = "user1_#{randm_word}@co.jp"
@user_name = "進撃のアーティスト"
@user_profile = "aaa"
@user_occupation = "bbb"
@user_position = "ccc"

@user_email2 = "user2_#{randm_word}@co.jp"
@user_name2 = "テストユーザー2"
@user_profile2 = "ddd"
@user_occupation2 = "eee"
@user_position2 = "fff"

# パスワードは全ユーザー共通
@password = "aaa111"

# Prototype投稿情報
@prototype_title = "999"
@prototype_catch_copy = "自然の息吹"
@prototype_catch_copy2 = "色の迫力"
@prototype_concept = "感情と色"
@prototype_image_name = "sakura.jpeg"
@prototype_image = "/Users/mizutaryousuke/projects/protospace_check/sakura.jpeg"
@comment = "素晴らしい！"

@d = Selenium::WebDriver.for :chrome
@wait = Selenium::WebDriver::Wait.new(:timeout => 180000)

# チェック項目の結果や詳細を保存する配列
# チェック項目の内容はハッシュ
# {チェック番号： 3 , チェック合否： "〇" , チェック内容： "〇〇をチェック" , チェック詳細： "○○×"}
@check_log = []

# 出力文章(メインチェック番号) = [1-001]等のチェック
# @puts_num_array = []
# [[30配列], [], [], .....]
@puts_num_array = Array.new(10).map{Array.new(30, false)}

#各チェックのフラグ変数
@flag_1_012 = 0;
@flag_1_015 = 0;
@flag_1_017 = 0;
@flag_3_001 = 0;
@flag_3_002 = 0;
@flag_4_001 = 0;
@flag_7_001 = 0;
@flag_8_001 = 0;
@flag_9_002 = 0;

begin
  main()
ensure
   #メインチェック番号の出力([1-001]系のチェック)
   puts "↓↓↓ 【[1-001]系のチェックの詳細】 ↓↓↓"

   #先にfor文に渡すチェック番号配列の長さの整数を生成しておく
   for_end_num = @puts_num_array.length
   for_end_num -= 1
   #index = 0はその他出力情報配列なのでindex = 1から出力していく
   for i in 1..for_end_num
    #各セクション配列の中身を全てループ処理する
    @puts_num_array[i].each{|check|
        #チェック内容が格納されている時だけ出力する
        if check != false
            if check.include?("001") && ! check.include?("1-001")
                puts "--------------------------------------------------------------------------"
                puts check
            else
                puts check
            end
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

  # その他情報の出力(URL情報やユーザーアカウントの詳細)
  puts "\n\n\n↓↓↓ 【その他情報の詳細】 ↓↓↓"
  # index = 0はその他出力情報配列
  @puts_num_array[0].each{|check|
      # チェック内容が格納されている時だけ出力する
      if check != false
          puts check
      end
  }

  # 自動チェック終了のお知らせ
  puts "自動チェックツール全プログラム終了"
  puts "手動チェック時は、以下のアカウント情報をお使いください。\n\n"
  puts "ユーザー名: 進撃のアーティスト\nemail: #{@user_email}\n\nユーザー名: テストユーザー2\nemail: #{@user_email2}\n\n"
  puts "パスワード: #{@password} (全ユーザー共通)\n"

  sleep 3000000000
end
