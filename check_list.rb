# ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在すること
def check_1
  check_detail = {"チェック番号"=> 1 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在すること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      check_ele1 = @d.find_element(:link_text, "ログアウト").displayed? ? "○：ログイン状態で、ヘッダーに「ログアウト」が表示されている\n" : "×：ログアウト状態では、ヘッダーに「ログアウト」が表示されない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end

    display_flag = @d.find_element(:link_text, "New Proto").displayed? rescue false
    if display_flag
      check_ele2 = @d.find_element(:link_text, "New Proto").displayed? ? "○：ログイン状態で、ヘッダーに「New Proto」が表示されている\n" : "×：ログアウト状態では、ヘッダーに「New Proto」が表示されない\n"
      check_detail["チェック詳細"] << check_ele2
      check_flag += 1
    end

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

  ensure
    @check_log.push(check_detail)
  end
end

# ログイン状態では、トップページに「こんにちは、〇〇さん」とユーザー名が表示されていること
def check_2
  check_detail = {"チェック番号"=> 2 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態では、トップページに「こんにちは、〇〇さん」とユーザー名が表示されていること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    display_flag = /#{@user_name}/ .match(@d.page_source) rescue false
    if display_flag
      check_ele1 = /#{@user_name}/ .match(@d.page_source) ? "○：ログイン状態では、トップページに「こんにちは、〇〇さん」とユーザー名が表示されている\n" : "×：ログイン状態では、トップページに「こんにちは、〇〇さん」とユーザー名が表示されていない\n"
      check_detail["チェック詳細"] << check_ele1
      check_flag += 1
    end

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"

  ensure
    @check_log.push(check_detail)
  end
end


#ユーザー新規登録画面でのエラーハンドリングログを取得
def check_19_1

  #全項目未入力で「登録する」ボタンをクリック
  @d.find_element(:class, "form__btn").click
  @wait.until { /ユーザー新規登録/ .match(@d.page_source) rescue false}

  #念の為登録できてしまわないかチェック
  if /ユーザー新規登録/ .match(@d.page_source)
    @error_log_hash["新規登録"] = "◯：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すと、登録が完了せずエラーメッセージが出力される\n\n"
    @error_log_hash["新規登録"] << "↓↓↓ エラーログ全文(出力された内容) ↓↓↓\n"
  else
    #登録できてしまう場合
    @error_log_hash["新規登録"] = "×：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すと、リダイレクトせず登録画面以外のページへ遷移してしまう(登録できてしまっている可能性あり)\n"

    #トップ画面へ
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

    #ログイン状態であればログアウトしておく
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
      @d.get(@url)
    end

    #再度新規登録画面へ
    @d.find_element(:link_text, "新規登録").click
    @wait.until {@d.find_element(:text, "ユーザー新規登録").displayed? rescue false}

  end
end
