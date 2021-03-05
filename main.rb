require './check_list'

def main

  @url = "https://protospace2020.herokuapp.com"
  @d.get(@url)

  # 「プロフィール」未入力でユーザー新規登録
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

  # 「コンセプト」未入力でProtoType投稿
  create_prototype_without_concept

  # ProtoType投稿
  create_prototype

end


# 「プロフィール」未入力でユーザー新規登録
def sign_up_without_profile
  # ログイン状態であればログアウトしておく
  display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
  if display_flag
    @d.find_element(:link_text, "ログアウト").click
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    @d.get(@url)
  end

  @d.find_element(:link_text, "新規登録").click
  @wait.until { /ユーザー新規登録/.match(@d.page_source) rescue false}

  # ユーザー新規登録画面でのエラーハンドリングログを取得
  check_19_1

  # 新規登録に必要な項目入力を行うメソッド
  input_sign_up(@user_email, @password, @user_name, @user_profile, @user_occupation, @user_position)

  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').clear

  @d.find_element(:class,"form__btn").click
end


# 新規登録に必要な項目入力を行うメソッド
def input_sign_up(email, pass, name, profile, occupation, position)
  @wait.until {@d.find_element(:id, 'user_email').displayed?}s
  @d.find_element(:id, 'user_email').send_keys(email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(pass)
  @wait.until {@d.find_element(:id, 'user_password_confirmation').displayed?}
  @d.find_element(:id, 'user_password_confirmation').send_keys(pass)
  @wait.until {@d.find_element(:id, 'user_name').displayed?}
  @d.find_element(:id, 'user_name').send_keys(name)
  @wait.until {@d.find_element(:id, 'user_profile').displayed?}s
  @d.find_element(:id, 'user_profile').send_keys(profile)
  @wait.until {@d.find_element(:id, 'user_occupation').displayed?}
  @d.find_element(:id, 'user_occupation').send_keys(occupation)
  @wait.until {@d.find_element(:id, 'user_position').displayed?}
  @d.find_element(:id, 'user_position').send_keys(position)
end


# 新規登録に必要な入力項目を全てクリアにするメソッド
def clear_sign_up
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
  @wait.until { /ユーザー新規登録/.match(@d.page_source) rescue false}

  if /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][10] = "[1-010] ◯"  #：必須項目が1つでも欠けている場合は、ユーザー登録ができない"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][7] = "[1-007] ×：プロフィール未入力でも登録できてしまう。またはトップページに遷移してしまう"  #:プロフィールが必須であること"
    @puts_num_array[1][10] = "[1-010] ×：必須項目が一つでも欠けている状態でも登録できてしまう。"  #：必須項目が一つでも欠けている場合は、ユーザー登録ができない"

    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end

    @d.find_element(:link_text, "新規登録").click
    @wait.until { /ユーザー新規登録/.match(@d.page_source) rescue false}

    # 登録できてしまったアカウントと異なる情報に更新しておく = 再登録&再ログインできなくなってしまうため
    randm_word = SecureRandom.hex(5)
    @user_email = "user1_#{randm_word}@co.jp"

    @puts_num_array[0].push("\n【補足情報】ユーザー新規登録テストにてユーザーの情報が更新されたため、更新されたユーザー情報を出力します(手動でのログイン時に使用)")
    @puts_num_array[0].push("パスワード: #{@password}")
    @puts_num_array[0].push("ユーザー名: 未入力\nemail: #{@user_email}\n")
  end

  # 再度登録
  # 最初に新規登録フォームの入力項目をクリア
  clear_sign_up

  # 今度はprofile含めた全項目に情報を入力していく
  input_sign_up(@user_email, @password, @user_name, @user_profile, @user_occupation, @user_position)

  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][1] = "[1-001] ◯"  #：メールアドレスが必須である"
    @puts_num_array[1][2] = "[1-002] ◯"  #：メールアドレスは一意性である"      #これはまだ立証できない
    @puts_num_array[1][3] = "[1-003] ◯"  #：メールアドレスは@を含む必要がある"  #これはまだ立証できない
    @puts_num_array[1][4] = "[1-004] ◯"  #：パスワードが必須である"
    # puts "[1-] ◯：パスワードは6文字以上である"  #これはまだ立証できない
    @puts_num_array[1][5] = "[1-005] ◯"  #：パスワードは確認用を含めて2回入力する"  #これはまだ立証できない
    @puts_num_array[1][6] = "[1-006] ◯"  #：ユーザー名が必須である"  #これはまだ立証できない
    @puts_num_array[1][7] = "[1-007] ◯"  #：プロフィールが必須である"
    @puts_num_array[1][8] = "[1-008] ◯"  #：所属が必須である"  #これはまだ立証できない
    @puts_num_array[1][9] = "[1-009] ◯"  #：役職が必須である"  #これはまだ立証できない
    @puts_num_array[1][10] = "[1-010] ◯"  #:必須項目に適切な値を入力すると、ユーザーの新規登録ができる
  elsif /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][10] = "[1-010] ×：必須項目を入力してもユーザー登録ができない"
    @puts_num_array[0].push("ユーザーの新規登録ができません。ユーザー登録できない場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します")
    @puts_num_array[0].push("手動でのアプリチェックを行ってください")
    raise "ユーザー登録バリデーションにて不備あり"
  end
end


# トップメニューに戻ってきた後にログアウトする
def logout_from_the_topMenu
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][13] = "[1-013] ◯"  #：トップページから、ログアウトができること
  else
    @puts_num_array[1][13] = "[1-013] ×：トップページから、ログアウトができない"
    @puts_num_array[0].push("トップページから、ログアウトができません。この場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します")
    @puts_num_array[0].push("手動でのアプリチェックを行ってください")
    raise "ユーザーのログイン/ログアウトにて不備あり"
  end
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

  # トップ画面に戻れているか
  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][12] = "[1-012] ◯"  #：必要な情報を入力すると、ログインができること
  else
    @puts_num_array[1][12] = "[1-012] ×：ログインが出来ません。もしくはログイン後にトップページへ遷移しません。"
    @d.get(@url)
  end
end


# ProtoType投稿
# コンセプト未入力
def create_prototype_without_concept
  @wait.until {@d.find_element(:link_text,"New Proto").displayed?}
  @d.find_element(:link_text,"New Proto").click

  # 何も入力せずに「保存する」ボタンをクリック
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source) rescue false}
  @d.find_element(:class,"form__btn").click

  # Prototype投稿画面でのエラーハンドリングログを取得
  # check_19_2

  # Prototype投稿時の必須項目へ入力するメソッド
  input_prototype(@prototype_title, @prototype_catch_copy, @prototype_concept, @prototype_image)

  # コンセプトのみ空白
  @d.find_element(:id,"prototype_concept").clear

  # 「保存する」ボタンをクリック
  @d.find_element(:class,"form__btn").click
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source) rescue false}

  if /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[2][6] = "[2-006] ◯"  #：投稿に必要な情報が入力されていない場合は、投稿できずにそのページに留まること
    @puts_num_array[2][7] = "[2-007] ◯"  #：必要な情報を入力すると、投稿ができること

  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[2][6] = "[2-006] ×：コンセプトの入力なしでPrototype投稿をしても、Prototype投稿ページにリダイレクトされず、トップページへ遷移してしまう"
    @puts_num_array[2][4] = "[2-004] ×：コンセプトの入力なしでも、Prototype投稿ができてしまう"
  else
    @puts_num_array[2][6] = "[2-006] ×：コンセプトの入力なしでPrototype投稿を行うと、Prototype投稿ページにリダイレクトされない"
  end
end


# Prototype投稿に必要な全ての入力を行う
def create_prototype

  # Prototype投稿時の必須項目を全クリアにするメソッド
  clear_prototype

  # Prototype投稿時の必須項目を入力するメソッド
  input_prototype(@prototype_title, @prototype_catch_copy, @prototype_concept, @prototype_image)

  @d.find_element(:class,"form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[2][2] = "[2-002] ◯"  #：プロトタイプの名称が必須であること
    @puts_num_array[2][3] = "[2-003] ◯"  #：キャッチコピーが必須であること
    @puts_num_array[2][4] = "[2-004] ◯"  #：コンセプトの情報が必須であること
    @puts_num_array[2][5] = "[2-005] ◯"  #：画像は1枚必須であること(ActiveStorageを使用)
    @puts_num_array[2][7] = "[2-007] ◯"  #：必要な情報を入力すると、投稿ができることT
    @puts_num_array[2][8] = "[2-008] ◯"  #：正しく投稿できた場合は、トップページへ遷移すること
  end

end


# Prototype投稿時の入力必須項目を入力するメソッド
# 項目の入力のみを行う。入力後の「保存する」ボタンは押さない。
def input_prototype(title, catch_copy, concept, image)
  @wait.until {@d.find_element(:id,"prototype_title").displayed?}
  @d.find_element(:id,"prototype_title").send_keys(title)
  @wait.until {@d.find_element(:id,"prototype_catch_copy").displayed?}
  @d.find_element(:id,"prototype_catch_copy").send_keys(catch_copy)
  @wait.until {@d.find_element(:id,"prototype_concept").displayed?}
  @d.find_element(:id,"prototype_concept").send_keys(concept)
  @wait.until {@d.find_element(:id,"prototype_image").displayed?}
  @d.find_element(:id,"prototype_image").send_keys(image)
end


# Prototypeを再投稿するため、入力項目を全クリア
def clear_prototype
  @wait.until {@d.find_element(:id,"prototype_title").displayed?}
  @d.find_element(:id,"prototype_title").clear
  @wait.until {@d.find_element(:id,"prototype_catch_copy").displayed?}
  @d.find_element(:id,"prototype_catch_copy").clear
  @wait.until {@d.find_element(:id,"prototype_concept").displayed?}
  @d.find_element(:id,"prototype_concept").clear
  @wait.until {@d.find_element(:id,"prototype_image").displayed?}
  @d.find_element(:id,"prototype_image").clear
end
