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

  # 「コンセプト」未入力でPrototype投稿
  create_prototype_without_concept

  # Prototype投稿機能のチェック
  create_prototype

  # Prototype詳細表示機能のチェック
  check_top_prototype_display

  # # Prototype編集機能のチェック
  # edit_prototype

  # # Prototype削除機能のチェック
  # destroy_prototype

  # # コメント機能のチェック
  # comment_prototype

  # # ユーザー詳細機能のチェック
  # show_user

  # # ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされること
  # check_10

  # # ログアウト状態でのチェック
  # logout_check
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
    @puts_num_array[1][7] = "[1-007] ×：プロフィール未入力でも登録できてしまう。またはトップ画面に遷移してしまう"  #:プロフィールが必須であること"
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
    @puts_num_array[1][1] = "[1-001] ◯：メールアドレスが必須である"
    @puts_num_array[1][2] = "[1-002] ◯：メールアドレスは一意性である"  #これはまだ立証できない
    @puts_num_array[1][3] = "[1-003] ◯：メールアドレスは@を含む必要がある" #これはまだ立証できない
    @puts_num_array[1][4] = "[1-004] ◯：パスワードが必須である"
    @puts_num_array[1][5] = "[1-005] ◯：パスワードは確認用を含めて2回入力する" #これはまだ立証できない
    @puts_num_array[1][6] = "[1-006] ◯：ユーザー名が必須である" #これはまだ立証できない
    @puts_num_array[1][7] = "[1-007] ◯：プロフィールが必須である"
    @puts_num_array[1][8] = "[1-008] ◯：所属が必須である" #これはまだ立証できない
    @puts_num_array[1][9] = "[1-009] ◯：役職が必須である"  #これはまだ立証できない
    @puts_num_array[1][10] = "[1-010] ◯：必須項目に適切な値を入力すると、ユーザーの新規登録ができる"
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
    @puts_num_array[1][13] = "[1-013] ◯：トップ画面から、ログアウトができること"
  else
    @puts_num_array[1][13] = "[1-013] ×：トップ画面から、ログアウトができない"
    @puts_num_array[0].push("トップ画面から、ログアウトができません。この場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します")
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

  # 【1-012】必要な情報を入力すると、ログインができること
  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[1][12] = "[1-012] ◯：必要な情報を入力すると、ログインができること"
  else
    @puts_num_array[1][12] = "[1-012] ×：ログインが出来ません。もしくはログイン後にトップ画面へ遷移しません。"
    @d.get(@url)
  end

  # 【1-014】ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在すること
  if @d.find_element(:link_text, "ログアウト").displayed?
    @puts_num_array[1][14] = "[1-014] ◯：ログイン状態では、ヘッダーに「ログアウト」のリンクが存在している。"
  else
    @puts_num_array[1][14] = "[1-014] ×：ログイン状態では、ヘッダーに「ログアウト」のリンクが存在していない。"
  end

  if @d.find_element(:link_text, "New Proto").displayed?
    @puts_num_array[1][14] = @puts_num_array[1][14] + "[1-014] ◯：ログイン状態では、ヘッダーに「New Proto」のリンクが存在している。"
  else
    @puts_num_array[1][14] = @puts_num_array[1][14] + "[1-014] ×：ログイン状態では、ヘッダーに「New Proto」のリンクが存在していない。"
  end

  # 【1-015】ログイン状態では、トップ画面に「こんにちは、〇〇さん」とユーザー名が表示されていること
  if /こんにちは/.match(@d.page_source) && @d.find_element(:link_text, "#{@user_name}さん").displayed?
    @puts_num_array[1][15] = "[1-015] ◯：ログイン状態では、トップ画面に「こんにちは、〇〇さん」とユーザー名が表示されている。"
  else
    @puts_num_array[1][15] = "[1-015] ×：ログイン状態では、トップ画面に「こんにちは、〇〇さん」とユーザー名が表示されていない。"
  end
end


# 別名義のユーザーで新規登録/ログイン
def login_user2
  # 最初にログアウトしておく
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 新規登録
  @d.find_element(:link_text, "新規登録").click
  @wait.until { /ユーザー新規登録/.match(@d.page_source) rescue false}

  # 新規登録に必要な項目入力を行うメソッド
  input_sign_up(@user_email2, @password, @user_name2, @user_profile2, @user_occupation2, @user_position2)

  @d.find_element(:class,"form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
end


# 引数のデータを持つユーザーでログイン
def login_any_user(email, pass)
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # ログイン状態であればログアウトしておく
  display_flag = @d.find_element(:class, "ログアウト").displayed? rescue false
  if display_flag
    @d.find_element(:link_text, "ログアウト").click
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  end

  @d.find_element(:link_text, "ログイン").click
  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').send_keys(@user_email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(@password)

  @wait.until {@d.find_element(:class, "form__btn").displayed?}
  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # トップ画面に遷移
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

end


# ProtoType投稿
# コンセプト未入力
def create_prototype_without_concept
  @wait.until {@d.find_element(:link_text,"New Proto").displayed?}
  @d.find_element(:link_text,"New Proto").click
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source) rescue false}

  # 【2-001】ログイン状態のユーザーだけが、投稿ページへ遷移できること
  if /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[2][1] = "[2-001] ◯：ログイン状態のユーザーだけが、投稿ページへ遷移できること。"
  else
    @puts_num_array[2][1] = "[2-001] ×：ログイン状態のユーザーが「New Proto」を押下すると、不適切なページへ遷移してしまう。"
  end

  # 何も入力せずに「保存する」ボタンをクリック
  @d.find_element(:class,"form__btn").click

  # Prototype投稿時の必須項目へ入力するメソッド
  input_prototype(@prototype_title, @prototype_catch_copy, @prototype_concept, @prototype_image)

  # コンセプトのみ空白
  @d.find_element(:id,"prototype_concept").clear

  # 「保存する」ボタンをクリック
  @d.find_element(:class,"form__btn").click
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source) rescue false}

  if /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[2][6] = "[2-006] ◯：投稿に必要な情報が入力されていない場合は、投稿できずにその画面に留まること"
    @puts_num_array[2][7] = "[2-007] ◯：必要な情報を入力すると、投稿ができること"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[2][6] = "[2-006] ×：コンセプトの入力なしでPrototype投稿をしても、Prototype投稿画面にリダイレクトされず、トップ画面へ遷移してしまう。"
    @puts_num_array[2][4] = "[2-004] ×：コンセプトの入力なしでも、Prototype投稿ができてしまう。"
  else
    @puts_num_array[2][6] = "[2-006] ×：コンセプトの入力なしでPrototype投稿を行うと、Prototype投稿画面にリダイレクトされない。"
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
    @puts_num_array[2][2] = "[2-002] ◯：プロトタイプの名称が必須であること"
    @puts_num_array[2][3] = "[2-003] ◯：キャッチコピーが必須であること"
    @puts_num_array[2][4] = "[2-004] ◯：コンセプトの情報が必須であること"
    @puts_num_array[2][5] = "[2-005] ◯：画像は1枚必須であること(ActiveStorageを使用)"
    @puts_num_array[2][7] = "[2-007] ◯：必要な情報を入力すると、投稿ができること"
    @puts_num_array[2][8] = "[2-008] ◯：正しく投稿できた場合は、トップ画面へ遷移すること"
  else
    @puts_num_array[2][8] = "[2-008] ×：Prototype投稿後には、トップ画面へ遷移しません"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
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


 # Prototype投稿時の必須項目を全クリアにするメソッド
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


# ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧可能か確認
def check_top_prototype_display
  if @d.find_element(:class, "card").displayed?
    @puts_num_array[3][1] = "[3-001] ◯：ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧できること"
  else
    @puts_num_array[3][1] = "[3-001] ×：ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧できない"
  end

  # プロトタイプ毎に、画像・プロトタイプ名・キャッチコピー・投稿者名の、4つの情報について表示できること/ログインのログアウトの状態に関わらず、プロトタイプ一覧を閲覧できること
  check_4

  # ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細画面へ遷移すること
  check_5
end


# トップ画面でPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移
def prototype_title_click_from_top(title)
  # トップ画面のPrototype名要素を全部取得
  prototypes = @d.find_elements(:class, "card__title")
  prototypes.each{|prototype|
    if prototype.text == title
      prototype.click
      @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}
      break
    end
  }
end


# Prototype編集機能のチェック
def edit_prototype
  # トップ画面にてPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移する
  prototype_title_click_from_top(@prototype_title)

  # 【4-001】ログイン状態の投稿したユーザーだけに、「編集」「削除」のリンクが存在すること
  if /編集する/.match(@d.page_source)
    @puts_num_array[4][1] = "[4-001] ◯：ログイン状態の投稿したユーザーだけに、「編集する」のリンクが存在している。"
    @flag_4_001 += 1
  else
    @puts_num_array[4][1] = "[4-001] ×：ログイン状態の投稿したユーザーでも、「編集する」のリンクが存在していない。"
  end

  if /削除する/.match(@d.page_source)
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001] ◯：ログイン状態の投稿したユーザーだけに、「削除する」のリンクが存在している。"
  else
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001] ×：ログイン状態の投稿したユーザーでも、「削除する」のリンクが存在していない。"
  end

  # 【5-002】何も編集せずに更新をしても、画像無しのプロトタイプにならないこと
  @wait.until {@d.find_element(:partial_link_text, "編集").displayed?}
  @d.find_element(:partial_link_text, "編集").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source) rescue false}
  @d.find_element(:class, "form__btn").click

  if @d.find_element(:class, "prototype__image").displayed?
    @puts_num_array[5][2] = "[5-002] ◯：何も編集せずに更新をしても、画像無しのプロトタイプにならないこと。"
  else
    @puts_num_array[5][2] = "[5-002] ×：何も編集せずに更新をすると、画像無しのプロトタイプになってしまう。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  # 【5-003】空の入力欄がある場合は、編集できずにその画面に留まること
  @wait.until {@d.find_element(:partial_link_text, "編集").displayed?}
  @d.find_element(:partial_link_text, "編集").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source) rescue false}

  @wait.until {@d.find_element(:id, "prototype_concept").displayed?}
  @d.find_element(:id, "prototype_concept").clear
  @d.find_element(:class, "form__btn").click

  if /プロトタイプ編集/.match(@d.page_source)
    @puts_num_array[5][3] = "[5-003] ◯：空の入力欄がある場合は、編集できずにその画面に留まること。"
    @d.get(@url)
    prototype_title_click_from_top(@prototype_title)
  else
    @puts_num_array[5][3] = "[5-003] ×：空の入力欄がある場合は、編集できずにその画面に留まること。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  @wait.until {@d.find_element(:partial_link_text, "編集").displayed?}
  @d.find_element(:partial_link_text, "編集").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source) rescue false}

  # 「キャッチコピー」項目に違う値を入れ、正常に編集できるか検証
  @wait.until {@d.find_element(:id, "prototype_catch_copy").displayed?}
  @d.find_element(:id, "prototype_catch_copy").clear
  @d.find_element(:id, "prototype_catch_copy").send_keys(@prototype_catch_copy2)
  @d.find_element(:class, "form__btn").click

  # 【5-001】投稿に必要な情報を入力すると、プロトタイプが編集できること
  if /#{@prototype_catch_copy2}/.match(@d.page_source)
    @puts_num_array[5][1] = "[5-001] ◯：投稿に必要な情報を入力すると、プロトタイプが編集できること。"
  elsif /#{@prototype_catch_copy}/.match(@d.page_source)
    @puts_num_array[5][1] = "[5-001] ×：Prototype編集画面にて「キャッチコピー」を編集し保存ボタンをクリックしたが、編集前の情報が表示されている。"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[5][1] = "[5-001] △：Prototype編集画面にて「キャッチコピー」を編集し保存ボタンをクリックすると、トップ画面へ遷移してしまうため、「キャッチコピー」項目を確認できません。\n手動確認をお願いします。"
  else
    @puts_num_array[5][1] = "[5-001] ×：Prototype編集画面にて「キャッチコピー」を編集し保存ボタンをクリックしたが、挙動が正常ではありません。"
  end

  # 【5-004】正しく編集できた場合は、詳細画面へ遷移すること
  if @d.find_element(:class, "prototype__wrapper").displayed?
    @puts_num_array[5][4] = "[5-004] ◯：正しく編集できた場合は、詳細画面へ遷移すること。"
  else
    @puts_num_array[5][4] = "[5-004] ×：Prototype編集画面で「保存する」を押下しても、詳細画面へ遷移しない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end
end


# Prototype削除機能のチェック
def destroy_prototype
  # トップ画面でPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移
  prototype_title_click_from_top(@prototype_title)

  # 【6-001】削除が完了すると、トップ画面へ遷移すること
  @wait.until {@d.find_element(:partial_link_text, "削除").displayed?}
  @d.find_element(:partial_link_text, "削除").click

  if @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[6][1] = "[6-001] ◯：Prototypeの削除が完了すると、トップ画面へ遷移すること。"
  else
    @puts_num_array[6][1] = "[6-001] ×：Prototypeの「削除ボタン」押下しても、トップ画面に遷移しない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end
end


# Prototypeコメント機能のチェック
def comment_prototype
  # 新規Prototype作成
  @wait.until {@d.find_element(:link_text,"New Proto").displayed?}
  @d.find_element(:link_text,"New Proto").click

  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source) rescue false}
  @post_prototype_url = @d.current_url
  input_prototype(@prototype_title, @prototype_catch_copy, @prototype_concept, @prototype_image)

  @d.find_element(:class,"form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 別名義のユーザーで新規登録/ログイン
  login_user2

  # トップ画面でPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移
  prototype_title_click_from_top(@prototype_title)

  # 【7-005】フォームを空のまま投稿しようとすると、投稿できずにその画面に留まること
  @wait.until {@d.find_element(:class, "prototype__comments").displayed? rescue false}
  # check_10で使用する。
  @edit_prototype_url = @d.current_url + "/edit"
  @d.find_element(:class,"form__btn").click

  if @d.find_element(:class, "prototype__comments").displayed?
    @puts_num_array[7][5] = "[7-005] ◯：フォームを空のまま投稿しようとすると、投稿できずにその画面に留まること。"
  else
    @puts_num_array[7][5] = "[7-005] ×：フォームを空のまま投稿しても、他の画面に遷移してしまう"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  @wait.until {@d.find_element(:class, "prototype__comments").displayed? rescue false}
  @d.find_element(:id, "comment_text").send_keys(@comment)
  @d.find_element(:class,"form__btn").click

  # 【7-002】正しくフォームを入力すると、コメントが投稿できること
  if /#{@comment}/.match(@d.page_source)
    @puts_num_array[7][2] = "[7-002] ◯：正しくフォームを入力すると、コメントが投稿できること。"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[7][2] = "[7-002] △：フォームを入力して「送信する」ボタンを押下すると、トップ画面に遷移してしまう。"
  else
    @puts_num_array[7][2] = "[7-002] ×：フォームを入力して「送信する」ボタンを押下しても、正しく表示されていない。"
  end

  # 【7-003】コメントを投稿すると、詳細画面に戻ってくること
  if @d.find_element(:class, "prototype__wrapper").displayed?
    @puts_num_array[7][3] = "[7-003] ◯：コメントを投稿すると、詳細画面に戻ってくること。"
  else
    @puts_num_array[7][3] = "[7-003] ×：コメントを投稿しても、詳細画面へ留まらず違う画面に遷移してしまう。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  # コメントを投稿すると、投稿したコメントとその投稿者名が、対象プロトタイプの詳細画面にのみ表示されること
  check_8
end


# ユーザー詳細機能のチェック
def show_user
  # 【8-001】ログイン・ログアウトの状態に関わらず、各画面のユーザー名をクリックすると、ユーザーの詳細画面へ遷移すること
  # トップ画面で検証
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  @d.find_element(:class, "card__user").click
  @wait.until {@d.find_element(:class, "user__wrapper").displayed? rescue false}

  if @d.find_element(:class, "user__wrapper").displayed?
    @puts_num_array[8][1] = "[8-001] ◯：ログイン・ログアウトの状態に関わらず、トップ画面のユーザー名をクリックすると、ユーザーの詳細画面へ遷移すること。"
  else
    @puts_num_array[8][1] = "[8-001] ×：ログイン・ログアウトの状態に関わらず、トップ画面のユーザー名をクリックしても、ユーザーの詳細画面へ遷移しない。"
  end

  # Prototype詳細画面で検証
  @d.get(@url)
  prototype_title_click_from_top(@prototype_title)
  @d.find_element(:class, "prototype__user").click
  @wait.until {@d.find_element(:class, "user__wrapper").displayed? rescue false}

  if @d.find_element(:class, "user__wrapper").displayed?
    @puts_num_array[8][1] = @puts_num_array[8][1] + "\n[8-001] ◯：ログイン・ログアウトの状態に関わらず、プロトタイプ詳細画面のユーザー名をクリックすると、ユーザーの詳細画面へ遷移すること。"
  else
    @puts_num_array[8][1] = @puts_num_array[8][1] + "\n[8-001] ×：ログイン・ログアウトの状態に関わらず、プロトタイプ詳細画面のユーザー名をクリックしても、ユーザーの詳細画面へ遷移しない。"
  end

  # ログイン・ログアウトの状態に関わらず、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること
  check_9
end


# ログアウト状態でのチェック
def logout_check
  # 最初にログアウトする。
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 【1-016】ログアウト状態では、ヘッダーに「新規登録」「ログイン」のリンクが存在すること
  if @d.find_element(:link_text, "新規登録").displayed?
    @puts_num_array[1][16] = "[1-016] ◯：ログアウト状態では、ヘッダーに「新規登録」のリンクが存在すること。"
  else
    @puts_num_array[1][16] = "[1-016] ×：ログアウト状態では、ヘッダーに「新規登録」のリンクが存在していない。"
  end

  if @d.find_element(:link_text, "ログイン").displayed?
    @puts_num_array[1][16] = @puts_num_array[1][16] + "[1-016] ◯：ログアウト状態では、ヘッダーに「ログイン」のリンクが存在している。"
  else
    @puts_num_array[1][16] = @puts_num_array[1][16] + "[1-016] ×：ログアウト状態では、ヘッダーに「ログイン」のリンクが存在していない。"
  end

  # 【9-001】ログアウト状態のユーザーは、プロトタイプ新規投稿/編集ページに遷移しようとすると、ログインページにリダイレクトされること
  # プロトタイプ新規投稿ページの検証
  @d.get(@post_prototype_url)
  @wait.until {/ログイン/.match(@d.page_source) rescue false}

  if /ログイン/.match(@d.page_source)
    @puts_num_array[9][1] = "[9-001] ◯：ログアウト状態のユーザーは、プロトタイプ新規投稿画面に遷移しようとすると、ログインページにリダイレクトされること。"
  elsif /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[9][1] = "[9-001] ×：ログアウト状態のユーザーが、プロトタイプ新規投稿画面に遷移できてしまう。"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[9][1] = "[9-001] ×：ログアウト状態のユーザーが、プロトタイプ新規投稿画面へ遷移しようとするとトップ画面に遷移してしまう。"
  else
    @puts_num_array[9][1] = "[9-001] ×：ログアウト状態のユーザーが、プロトタイプ新規投稿画面へ遷移しようとすると不適切なページへ遷移してしまう。"
  end

  # プロトタイプ編集ページの検証
  @d.get(@edit_prototype_url)
  @wait.until {/ログイン/.match(@d.page_source) rescue false}

  if /ログイン/.match(@d.page_source)
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ◯：ログアウト状態のユーザーは、プロトタイプ編集画面に遷移しようとすると、ログインページにリダイレクトされること"
  elsif /プロトタイプ編集/.match(@d.page_source)
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ×：ログアウト状態のユーザーが、プロトタイプ編集画面に遷移できてしまう。"
  elsif @d.find_element(:class, "card__wrapper").displayed?
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ×：ログアウト状態のユーザーが、プロトタイプ編集画面へ遷移しようとするとトップ画面に遷移してしまう。"
  else
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ×：ログアウト状態のユーザーが、プロトタイプ編集画面へ遷移しようとすると不適切なページへ遷移してしまう。"
  end
end
