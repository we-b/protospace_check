require './check_list'

def main

  @url = "https://protospace2020.herokuapp.com"
  @d.get(@url)

  # ユーザー新規登録
  # プロフィール未入力
  sign_up_without_profile

  # 必須項目を入力して再登録
  sign_up_retry

  # トップメニューからログアウト
  logout_from_the_topMenu

  # ログイン
  login_user

  # ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在すること
  check_1

  # ログイン状態では、トップページに「こんにちは、〇〇さん」とユーザー名が表示されていること
  check_2

end


# ユーザー新規登録
# プロフィールは未入力
def sign_up_without_profile
  # ログイン状態であればログアウトしておく
  display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
  if display_flag
    @d.find_element(:link_text, "ログアウト").click
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    @d.get(@url)
  end

  @d.find_element(:link_text, "新規登録").click
  @wait.until { /ユーザー新規登録/ .match(@d.page_source) rescue false}

  # ユーザー新規登録画面でのエラーハンドリングログを取得
  check_19_1

  # 新規登録に必要な項目入力を行うメソッド
  input_sign_up_method(@user_email, @password, @user_name, @user_profile, @user_occupation, @user_position)

  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').clear

  @d.find_element(:class,"form__btn").click
end


# 新規登録に必要な項目入力を行うメソッド
def input_sign_up_method(email, pass, name, profile, occupation, position)
  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').send_keys(email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(pass)
  @wait.until {@d.find_element(:id, 'user_password_confirmation').displayed?}
  @d.find_element(:id, 'user_password_confirmation').send_keys(pass)
  @wait.until {@d.find_element(:id, 'user_name').displayed?}
  @d.find_element(:id, 'user_name').send_keys(name)
  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').send_keys(profile)
  @wait.until {@d.find_element(:id, 'user_occupation').displayed?}
  @d.find_element(:id, 'user_occupation').send_keys(occupation)
  @wait.until {@d.find_element(:id, 'user_position').displayed?}
  @d.find_element(:id, 'user_position').send_keys(position)
end


# 新規登録に必要な入力項目を全てクリアにするメソッド
def clear_sign_up_method
  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').clear
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').clear
  @wait.until {@d.find_element(:id, 'user_password_confirmation').displayed?}
  @d.find_element(:id, 'user_password_confirmation').clear
  @wait.until {@d.find_element(:id, 'user_name').displayed?}
  @d.find_element(:id, 'user_name').clear
  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').clear
  @wait.until {@d.find_element(:id, 'user_occupation').displayed?}
  @d.find_element(:id, 'user_occupation').clear
  @wait.until {@d.find_element(:id, 'user_position').displayed?}
  @d.find_element(:id, 'user_position').clear
end



# まだ登録が完了していない場合、再度登録
def sign_up_retry
  @wait.until { /ユーザー新規登録/ .match(@d.page_source) rescue false}

  if /ユーザー新規登録/ .match(@d.page_source)
    @puts_num_array[1][1] = "[1-001] ◯"  #：必須項目が一つでも欠けている場合は、ユーザー登録ができない"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][2] = "[1-002] ×：プロフィール未入力でも登録できてしまう。またはトップページに遷移してしまう"  #:プロフィールが必須であること"
    @puts_num_array[1][1] = "[1-001] ×：必須項目が一つでも欠けている状態でも登録できてしまう。"  #：必須項目が一つでも欠けている場合は、ユーザー登録ができない"

    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end

    @d.find_element(:link_text, "新規登録").click
    @wait.until { /ユーザー新規登録/ .match(@d.page_source) rescue false}

    # 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまうため
    randm_word = SecureRandom.hex(5)
    @user_email = "user1_#{randm_word}@co.jp"

    @puts_num_array[0].push("\n【補足情報】ユーザー新規登録テストにてユーザーの情報が更新されたため、更新されたユーザー情報を出力します(手動でのログイン時に使用)")
    @puts_num_array[0].push("パスワード: #{@password}")
    @puts_num_array[0].push("ユーザー名: 未入力\nemail: #{@user_email}\n")
  end

  # 再度登録
  # まず新規登録フォームの入力項目をクリア
  clear_sign_up_method

  # 今度はprofile含めた全項目に情報を入力していく
  input_sign_up_method(@user_email, @password, @user_name, @user_profile, @user_occupation, @user_position)

  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  if  @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][2]  = "[1-002] ◯"  #：メールアドレスが必須である"
    @puts_num_array[1][3]  = "[1-003] ◯"  #：メールアドレスは一意性である"      #これはまだ立証できない
    @puts_num_array[1][4]  = "[1-004] ◯"  #：メールアドレスは@を含む必要がある"  #これはまだ立証できない
    @puts_num_array[1][5]  = "[1-005] ◯"  #：パスワードが必須である"
    # puts "[1-] ◯：パスワードは6文字以上である"  #これはまだ立証できない
    @puts_num_array[1][6]  = "[1-006] ◯"  #：パスワードは確認用を含めて2回入力する"  #これはまだ立証できない
    @puts_num_array[1][7]  = "[1-007] ◯"  #：ユーザー名が必須である"  #これはまだ立証できない
    @puts_num_array[1][8]  = "[1-008] ◯"  #：プロフィールが必須である"
    @puts_num_array[1][9]  = "[1-009] ◯"  #：所属名が必須である"  #これはまだ立証できない
    @puts_num_array[1][10] = "[1-010] ◯"  #：役職名が必須である"  #これはまだ立証できない
    @puts_num_array[1][11] = "[1-011] ◯"  #:必須項目に適切な値を入力すると、ユーザーの新規登録ができる

  # 登録に失敗した場合はパスワードを疑う
  elsif /ユーザー新規登録/ .match(@d.page_source)
    @puts_num_array[0].push("×：ユーザー新規登録時にパスワードに大文字が入っていないと登録できない可能性あり、パスワード文字列に大文字(aaa111 → Aaa111)を追加して再登録トライ")
    @puts_num_array[1][11] = "[1-011] ×：必須項目を入力してもユーザー登録ができない"
    @puts_num_array[0].push("ユーザー登録バリデーションが複雑なためユーザー登録ができません。ユーザー登録できない場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します")
    @puts_num_array[0].push("手動でのアプリチェックを行ってください")
    raise "ユーザー登録バリデーションにて不備あり"
  end
end


# トップメニューに戻ってきた後にログアウトする
def logout_from_the_topMenu
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
end


# ログイン
def login_user
  @wait.until {@d.find_element(:link_text, "ログイン").displayed?}
  @d.find_element(:link_text, "ログイン").click

  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').send_keys(@user_email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(@password)

  @wait.until {@d.find_element(:class, "form__btn").displayed?}
  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  @puts_num_array[1][15] = "[1-013] ◯"  #：ヘッダーの新規登録/ログインボタンをクリックすることで、各ページに遷移できること
  @puts_num_array[1][16] = "[1-014] ◯"  #：ヘッダーのログアウトボタンをクリックすることで、ログアウトができること

  # トップ画面に戻れているか
  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][14] = "[1-012] ◯"  #：ログイン/ログアウトができる"
  else
    @puts_num_array[1][14] = "[1-012] ×：ログイン/ログアウトができない、もしくはログイン後にトップページへ遷移しない"
    @d.get(@url)
  end
end
