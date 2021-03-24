require './check_list'

def main
  # チェック前の準備
  start

  # ユーザー管理機能のチェック
  sign_up_check

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

  # Prototype一覧表示機能のチェック
  check_top_prototype_display

  # Prototype編集機能のチェック
  edit_prototype

  # Prototype削除機能のチェック
  destroy_prototype

  # コメント機能のチェック
  comment_prototype

  # ユーザー詳細機能のチェック
  show_user

  # ログアウト状態でのチェック
  logout_check

end


# チェック前の準備
def start

  puts <<-EOT
----------------------------
自動チェックツールを起動します。

動作チェックするアプリの本番環境URLを入力し、
入力しenterキーを押してください (例：http://protospace2020.herokuapp.com/)

EOT

  input_url = gets.chomp
  # 「https://」を削除
  @url_ele = input_url.gsub(/https:\/\/|http:\/\//, "https:\/\/" => "", "http:\/\/" => "")

  puts "\n自動チェックを開始します。\n"

  @url = "https://" + @url_ele
  @d.get(@url)
end


# ユーザー管理機能のチェック
def sign_up_check
  # ログイン状態であればログアウトしておく
  display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
  if display_flag
    @d.find_element(:link_text, "ログアウト").click
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    @d.get(@url)
  end

  @d.find_element(:link_text, "新規登録").click
  @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}

  #全項目未入力で「登録する」ボタンをクリック
  @d.find_element(:class, "form__btn").click
  @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}

  #念の為登録できてしまわないかチェック
  if /ユーザー新規登録/.match(@d.page_source)
    @flag_1_012 += 1
  else
    @puts_num_array[1][12] = "[1-012] ×：フォームに適切な値が入力されていない状態で、「新規登録」を押下してもそのページに留まらない。"

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
    @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  end

  # 【1-003】メールアドレスは@を含む必要があること
  check_1_003

  # 【1-005】パスワードは6文字以上であること
  check_1_005

  # 【1-006】パスワードは確認用を含めて2回入力する
  check_1_006

  # 【1-008】プロフィールが必須であること
  check_1_008
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
  input_sign_up(@user_email, @password, @user_name, @user_profile, @user_occupation, @user_position)

  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[1][1] = "[1-001] ◯：メールアドレスが必須であること。"
    @puts_num_array[1][4] = "[1-004] ◯：パスワードが必須であること。"
    @puts_num_array[1][7] = "[1-007] ◯：ユーザー名が必須であること。"
    @puts_num_array[1][9] = "[1-009] ◯：所属が必須であること。"
    @puts_num_array[1][10] = "[1-010] ◯：役職が必須であること。"
    @puts_num_array[1][11] = "[1-011] ◯：必須項目に適切な値を入力すると、ユーザーの新規登録ができること。"
  elsif /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][11] = "[1-011] ×：必須項目を入力してもユーザー登録ができない。"
    @puts_num_array[0].push("ユーザーの新規登録ができません。ユーザー登録できない場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します。")
    @puts_num_array[0].push("手動でのチェックをお願いします。")
    raise "ユーザー登録バリデーションにて不備あり。"
  else
    @puts_num_array[1][1] = "[1-001] ×：メールアドレスが必須であること。"
    @puts_num_array[1][4] = "[1-004] ×：パスワードが必須であること。"
    @puts_num_array[1][7] = "[1-007] ×：ユーザー名が必須であること。"
    @puts_num_array[1][9] = "[1-009] ×：所属が必須であること。"
    @puts_num_array[1][10] = "[1-010] ×：役職が必須であること。"
    @puts_num_array[1][11] = "[1-011] ×：必須項目に適切な値を入力すると、ユーザーの新規登録ができること。"
  end
end


# トップメニューに戻ってきた後にログアウトする
def logout_from_the_topMenu
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[1][14] = "[1-014] ◯：トップ画面から、ログアウトができること。"
  else
    @puts_num_array[1][14] = "[1-014] ×：トップ画面から、ログアウトができない。"
    @puts_num_array[0].push("トップ画面からログアウトができません。この場合、以降の自動チェックにて不備が発生するため自動チェック処理を終了します。")
    @puts_num_array[0].push("手動でのチェックをお願いします。")
    raise "ユーザーのログイン/ログアウトにて不備あり。"
  end
end


# ログイン
def login_user
  @wait.until {@d.find_element(:link_text, "ログイン").displayed? rescue false}
  @d.find_element(:link_text, "ログイン").click

  #全項目未入力で「ログイン」ボタンをクリック
  @wait.until {@d.find_element(:class, "form__btn").displayed? rescue false}
  @d.find_element(:class, "form__btn").click
  @wait.until {/ユーザーログイン/.match(@d.page_source)}

  if /ユーザーログイン/.match(@d.page_source)
    @flag_1_012 += 1
  else
    @puts_num_array[1][12] = "[1-012] ×：フォームに適切な値が入力されていない状態で、「ログイン」を押下してもそのページに留まらない。"

    #再度ログイン画面へ
    @d.get(@url)
    @wait.until {@d.find_element(:link_text, "ログイン").displayed? rescue false}
    @d.find_element(:link_text, "ログイン").click
  end

  if @flag_1_012 == 2
    @puts_num_array[1][12] = "[1-012] ◯：フォームに適切な値が入力されていない状態では、新規登録/ログインはできず、そsのページに留まること。"
  end

  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').send_keys(@user_email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(@password)

  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 【1-013】必要な情報を入力すると、ログインができること
  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[1][13] = "[1-013] ◯：必要な情報を入力すると、ログインができること。"
  else
    @puts_num_array[1][13] = "[1-013] ×：必要な情報を入力しても、ログインができない。"
    @d.get(@url)
  end

  # 【1-015】ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在すること
  display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
  if display_flag
    @flag_1_015 += 1
  else
    @puts_num_array[1][15] = "[1-015] ×：ログイン状態では、ヘッダーに「ログアウト」のリンクが存在していない。"
  end

  display_flag = @d.find_element(:link_text, "New Proto").displayed? rescue false
  if display_flag
    @flag_1_015 += 1
  elsif @puts_num_array[1][15]
    @puts_num_array[1][15] = @puts_num_array[1][15] + "\n[1-015] ×：ログイン状態では、ヘッダーに「New Proto」のリンクが存在していない。"
  else
    @puts_num_array[1][15] = "\n[1-015] ×：ログイン状態では、ヘッダーに「New Proto」のリンクが存在していない。"
  end

  if @flag_1_015 == 2
    @puts_num_array[1][15] = "[1-015] ◯：ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在すること。"
  end

  # 【1-016】ログイン状態では、トップ画面に「こんにちは、〇〇さん」とユーザー名が表示されていること
  if /こんにちは/.match(@d.page_source) && /#{@user_name}/.match(@d.page_source)
    @puts_num_array[1][16] = "[1-016] ◯：ログイン状態では、トップ画面に「こんにちは、〇〇さん」とユーザー名が表示されている。"
  else
    @puts_num_array[1][16] = "[1-016] ×：ログイン状態では、トップ画面に「こんにちは、〇〇さん」とユーザー名が表示されていない。"
  end
end


# 別名義のユーザーで新規登録/ログイン
def login_user2
  # 最初にログアウトしておく
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 新規登録
  @d.find_element(:link_text, "新規登録").click
  @wait.until {/ユーザー新規登録/.match(@d.page_source)}

  # 【1-002】メールアドレスは一意性であること
  input_sign_up(@user_email, @password, @user_name2, @user_profile2, @user_occupation2, @user_position2)
  @d.find_element(:class,"form__btn").click
  @wait.until {/ユーザー新規登録/.match(@d.page_source)}

  if /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][2] = "[1-002] ◯：メールアドレスは一意性であること。"
  else
    @puts_num_array[1][2] = "[1-002] ×：メールアドレスが一意性ではない。"

    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end

    @d.find_element(:link_text, "新規登録").click
    @wait.until {/ユーザー新規登録/.match(@d.page_source)}
  end

  # 新規登録フォームの入力項目をクリア
  clear_sign_up

  input_sign_up(@user_email2, @password, @user_name2, @user_profile2, @user_occupation2, @user_position2)
  @d.find_element(:class,"form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
end


# ProtoType投稿
# コンセプト未入力
def create_prototype_without_concept
  @d.find_element(:link_text, "New Proto").click
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source)}

  # 【2-001】ログイン状態のユーザーだけが、投稿ページへ遷移できること
  if /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[2][1] = "[2-001] ◯：ログイン状態のユーザーだけが、投稿ページへ遷移できること。"
  else
    @puts_num_array[2][1] = "[2-001] ×：ログイン状態のユーザーが「New Proto」を押下すると、不適切なページへ遷移してしまう。"
  end

  # Prototype投稿時の必須項目へ入力するメソッド
  input_prototype(@prototype_title, @prototype_catch_copy, @prototype_concept, @prototype_image)

  # コンセプトのみ空白
  @d.find_element(:id, "prototype_concept").clear

  # 「保存する」ボタンをクリック
  @d.find_element(:class, "form__btn").click
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source)}

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[2][6] = "[2-006] ◯：投稿に必要な情報が入力されていない場合は、投稿できずにその画面に留まること。"
  elsif display_flag
    @puts_num_array[2][6] = "[2-006] ×：コンセプトの入力なしでプロトタイプ投稿をしても、Prototype投稿画面にリダイレクトされず、トップ画面へ遷移してしまう。"
    @puts_num_array[2][4] = "[2-004] ×：コンセプトの入力なしでも、プロトタイプ投稿ができてしまう。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    @d.find_element(:link_text, "New Proto").click
    @wait.until {/新規プロトタイプ投稿/.match(@d.page_source)}
  else
    @puts_num_array[2][6] = "[2-006] ×：コンセプトの入力なしでPrototype投稿をしても、Prototype画面にリダイレクトされない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    @d.find_element(:link_text, "New Proto").click
    @wait.until {/新規プロトタイプ投稿/.match(@d.page_source)}
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

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[2][2] = "[2-002] ◯：プロトタイプの名称が必須であること。"
    @puts_num_array[2][3] = "[2-003] ◯：キャッチコピーが必須であること。"
    @puts_num_array[2][4] = "[2-004] ◯：コンセプトの情報が必須であること。"
    @puts_num_array[2][5] = "[2-005] ◯：画像は1枚必須であること(ActiveStorageを使用)。"
    @puts_num_array[2][7] = "[2-007] ◯：必要な情報を入力すると、投稿ができること。"
    @puts_num_array[2][8] = "[2-008] ◯：正しく投稿できた場合は、トップ画面へ遷移すること。"
  else
    @puts_num_array[2][2] = "[2-002] ×：プロトタイプの名称が必須であること。"
    @puts_num_array[2][3] = "[2-003] ×：キャッチコピーが必須であること。"
    @puts_num_array[2][4] = "[2-004] ×：コンセプトの情報が必須であること。"
    @puts_num_array[2][5] = "[2-005] ×：画像は1枚必須であること(ActiveStorageを使用)。"
    @puts_num_array[2][7] = "[2-007] ×：必要な情報を入力すると、投稿ができること。"
    @puts_num_array[2][8] = "[2-008] ×：Prototype投稿後には、トップ画面へ遷移しません。"
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


# Prototype一覧表示機能のチェック
def check_top_prototype_display
  # 【3-001】ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧可能か確認
  display_flag = @d.find_element(:class, "card").displayed? rescue false
  if display_flag
    @flag_3_001 += 1
  else
    @puts_num_array[3][1] = "[3-001] ×：ログイン状態では、プロトタイプ一覧を閲覧できない。"
  end

  # 投稿した情報は、トップページに表示されること
  check_1

  # 【3-002】ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細画面へ遷移すること
  # 画像をクリックして、Prototype詳細画面に遷移するか確認
  @d.find_element(:class,"card__img").click
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "prototype__wrapper").displayed? rescue false
  if display_flag
    @flag_3_002 += 1
  else
    @puts_num_array[3][2] = "×：ログイン状態で、一覧表示されている画像をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  end

  # トップ画面へ戻る
  @d.get(@url)

  # Prototypeのタイトルをクリックして、Prototype詳細画面に遷移するか確認
  @d.find_element(:class,"card__title").click
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "prototype__wrapper").displayed? rescue false
  if display_flag
    @flag_3_002 += 1
  elsif @puts_num_array[3][2]
    @puts_num_array[3][2] = @puts_num_array[3][2] + "×：ログイン状態で、一覧表示されているプロトタイプ名をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  else
    @puts_num_array[3][2] = "×：ログイン状態で、一覧表示されているプロトタイプ名をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  end

  # トップ画面へ戻る
  @d.get(@url)
end


# トップ画面でPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移
def prototype_title_click_from_top(title)
  # トップ画面のPrototype名要素を全部取得
  prototypes = @d.find_elements(:class, "card__title")
  prototypes.each{|prototype|
    if prototype.text == title
      prototype.click
      @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false || @d.find_element(:class, "card__wrapper").displayed? rescue false}
      break
    end
  }
end


# Prototype編集機能のチェック
def edit_prototype
  # トップ画面にてPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移する
  prototype_title_click_from_top(@prototype_title)

  # ログイン・ログアウトの状態に関わらず、プロダクトの情報（プロトタイプ名・投稿者・画像・ キャッチコピー・コンセプト）が表示されていること
  check_2_login

  # 【4-001】ログイン状態の投稿したユーザーだけに、「編集」「削除」のリンクが存在すること
  display_flag = @d.find_element(:partial_link_text, "編集").displayed? rescue false
  if display_flag
    @flag_4_001 += 1
  else
    @puts_num_array[4][1] = "[4-001] ×：ログイン状態の投稿者でも、「編集」のリンクが存在していない。"
  end

  display_flag = @d.find_element(:partial_link_text, "削除").displayed? rescue false
  if display_flag
    @flag_4_001 += 1
  elsif @puts_num_array[4][1]
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001] ×：ログイン状態の投稿者でも、「削除」のリンクが存在していない。"
  else
    @puts_num_array[4][1] = "\n[4-001] ×：ログイン状態の投稿者でも、「削除」のリンクが存在していない。"
  end

  # 【5-003】ログイン状態のユーザーに限り、自身の投稿したプロトタイプの詳細ページから編集ボタンをクリックすると、編集ページへ遷移できること
  @wait.until {@d.find_element(:partial_link_text, "編集").displayed? rescue false}
  @d.find_element(:partial_link_text, "編集").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source)}

  # プロトタイプ情報について、すでに登録されている情報は、編集画面を開いた時点で表示されること
  check_3

  if /プロトタイプ編集/.match(@d.page_source)
    @puts_num_array[5][3] = "[5-003] ◯：ログイン状態のユーザーに限り、自身の投稿したプロトタイプの詳細ページから編集ボタンをクリックすると、編集ページへ遷移できること。"
  else
    @puts_num_array[5][3] = "[5-003] ×：ログイン状態のユーザーで、自身の投稿したプロトタイプの詳細ページから編集ボタンをクリックしても、編集ページへ遷移できない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  # 【5-002】何も編集せずに更新をしても、画像無しのプロトタイプにならないこと
  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:partial_link_text, "編集").displayed? rescue false}

  display_flag = @d.find_element(:class, "prototype__image").displayed? rescue false
  if display_flag
    @puts_num_array[5][2] = "[5-002] ◯：何も編集せずに更新をしても、画像無しのプロトタイプにならないこと。"
  else
    @puts_num_array[5][2] = "[5-002] ×：何も編集せずに更新をすると、画像無しのプロトタイプになってしまう。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  # 【5-004】空の入力欄がある場合は、編集できずにその画面に留まること
  @d.find_element(:partial_link_text, "編集").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source)}

  @d.find_element(:id, "prototype_concept").clear
  @d.find_element(:class, "form__btn").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source)}

  if /プロトタイプ編集/.match(@d.page_source)
    @puts_num_array[5][4] = "[5-004] ◯：空の入力欄がある場合は、編集できずにその画面に留まること。"
    @d.get(@url)
    prototype_title_click_from_top(@prototype_title)
  else
    @puts_num_array[5][4] = "[5-004] ×：空の入力欄がある状態で「編集する」を押下しても、その画面に留まらない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  @wait.until {@d.find_element(:partial_link_text, "編集").displayed? rescue false}
  @d.find_element(:partial_link_text, "編集").click
  @wait.until {/プロトタイプ編集/.match(@d.page_source)}

  # 「キャッチコピー」項目に違う値を入れ、正常に編集できるか検証
  @d.find_element(:id, "prototype_catch_copy").clear
  @d.find_element(:id, "prototype_catch_copy").send_keys(@prototype_catch_copy2)
  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}

  # 【5-001】投稿に必要な情報を入力すると、プロトタイプが編集できること
  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if /#{@prototype_catch_copy2}/.match(@d.page_source)
    @puts_num_array[5][1] = "[5-001] ◯：投稿に必要な情報を入力すると、プロトタイプが編集できること。"
  elsif /#{@prototype_catch_copy}/.match(@d.page_source)
    @puts_num_array[5][1] = "[5-001] ×：Prototype編集画面にて「キャッチコピー」を編集し保存ボタンをクリックしたが、編集前の情報が表示されている。"
  elsif display_flag
    @puts_num_array[5][1] = "[5-001] △：Prototype編集画面にて「キャッチコピー」を編集し保存ボタンをクリックすると、トップ画面へ遷移してしまうため、「キャッチコピー」項目を確認できません。\n手動確認をお願いします。"
  else
    @puts_num_array[5][1] = "[5-001] ×：Prototype編集画面にて「キャッチコピー」を編集し保存ボタンをクリックしたが、挙動が正常ではありません。"
  end

  # 【5-005】正しく編集できた場合は、詳細画面へ遷移すること
  display_flag = @d.find_element(:class, "prototype__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[5][5] = "[5-005] ◯：正しく編集できた場合は、詳細画面へ遷移すること。"
  else
    @puts_num_array[5][5] = "[5-005] ×：Prototype編集画面で「保存する」を押下しても、詳細画面へ遷移しない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end
end


# Prototype削除機能のチェック
def destroy_prototype
  # 【6-001】ログイン状態のユーザーに限り、自身の投稿したプロトタイプの詳細ページから削除ボタンをクリックすると、プロトタイプを削除できること
  # 【6-002】削除が完了すると、トップ画面へ遷移すること
  @d.find_element(:partial_link_text, "削除").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[6][1] = "[6-001] ◯：ログイン状態のユーザーに限り、自身の投稿したプロトタイプの詳細ページから削除ボタンをクリックすると、プロトタイプを削除できること。"
    @puts_num_array[6][2] = "[6-002] ◯：Prototypeの削除が完了すると、トップ画面へ遷移すること。"
  else
    @puts_num_array[6][1] = "[6-001] ×：ログイン状態のユーザーで、自身の投稿したプロトタイプの詳細ページから削除ボタンをクリックしても、プロトタイプを削除できない。"
    @puts_num_array[6][2] = "[6-002] ×：Prototypeの「削除ボタン」押下しても、トップ画面に遷移しない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  end
end


# Prototypeコメント機能のチェック
def comment_prototype
  # 新規Prototype作成
  @wait.until {@d.find_element(:link_text, "New Proto").displayed? rescue false}
  @d.find_element(:link_text, "New Proto").click
  @wait.until {/新規プロトタイプ投稿/.match(@d.page_source)}

  # 【9-001】で使用
  @post_prototype_url = @d.current_url
  input_prototype(@prototype_title, @prototype_catch_copy, @prototype_concept, @prototype_image)

  @d.find_element(:class,"form__btn").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 別名義のユーザーで新規登録/ログイン
  login_user2

  # トップ画面でPrototype名を基準に、該当のPrototype投稿をクリックしてPrototype詳細画面へ遷移
  prototype_title_click_from_top(@prototype_title)
  @wait.until {@d.find_element(:class, "prototype__comments").displayed? rescue false}

  # check_6で使用
  @edit_prototype_url = @d.current_url + "/edit"

  # 【7-001】コメント投稿欄は、ログイン状態のユーザーへのみ、詳細ページに表示されていること
  display_flag = @d.find_element(:id, "comment_text").displayed? rescue false
  if display_flag
    @flag_7_001 += 1
  else
    @puts_num_array[7][1] = "[7-001] ×：ログイン状態のユーザーでも、プロトタイプ詳細ページにコメント投稿欄が表示されていない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  # 【7-004】フォームを空のまま投稿しようとすると、投稿できずにその画面に留まること
  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "prototype__comments").displayed? rescue false}

  display_flag = @d.find_element(:class, "prototype__comments").displayed? rescue false
  if display_flag
    @puts_num_array[7][4] = "[7-004] ◯：フォームを空のまま投稿しようとすると、投稿できずにその画面に留まること。"
  else
    @puts_num_array[7][4] = "[7-004] ×：フォームを空のまま投稿しても、他の画面に遷移してしまう"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  @d.find_element(:id, "comment_text").send_keys(@comment)
  @d.find_element(:class, "form__btn").click
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 【7-002】正しくフォームを入力すると、コメントが投稿できること
  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if /#{@comment}/.match(@d.page_source)
    @puts_num_array[7][2] = "[7-002] ◯：正しくフォームを入力すると、コメントが投稿できること。"
  elsif display_flag
    @puts_num_array[7][2] = "[7-002] △：フォームを入力して「送信する」ボタンを押下すると、トップ画面に遷移してしまう。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  else
    @puts_num_array[7][2] = "[7-002] ×：フォームを入力して「送信する」ボタンを押下しても、正しく表示されていない。"
  end

  # 【7-003】コメントを投稿すると、詳細画面に戻ってくること
  display_flag = @d.find_element(:class, "prototype__wrapper").displayed? rescue false
  if display_flag
    @puts_num_array[7][3] = "[7-003] ◯：コメントを投稿すると、詳細画面に戻ってくること。"
  else
    @puts_num_array[7][3] = "[7-003] ×：コメントを投稿しても、詳細画面へ留まらず違う画面に遷移してしまう。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
    prototype_title_click_from_top(@prototype_title)
  end

  # コメントを投稿すると、投稿したコメントとその投稿者名が、対象プロトタイプの詳細画面にのみ表示されること
  check_4
end


# ユーザー詳細機能のチェック
def show_user
  # 【8-001】ログイン・ログアウトの状態に関わらず、各画面のユーザー名をクリックすると、ユーザーの詳細画面へ遷移すること
  # トップ画面で検証
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  @d.find_element(:class, "card__user").click
  @wait.until {@d.find_element(:class, "user__wrapper").displayed? rescue false || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "user__wrapper").displayed? rescue false
  if display_flag
    @flag_8_001 += 1
  else
    @puts_num_array[8][1] = "[8-001] ×：ログイン状態で、トップ画面のユーザー名をクリックしても、ユーザーの詳細画面へ遷移しない。"
  end

  # Prototype詳細画面で検証
  @d.get(@url)
  prototype_title_click_from_top(@prototype_title)
  @wait.until {@d.find_element(:class, "prototype__user").displayed? rescue false}
  @d.find_element(:class, "prototype__user").click
  @wait.until {@d.find_element(:class, "user__wrapper").displayed? rescue false || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "user__wrapper").displayed? rescue false
  if display_flag
    @flag_8_001 += 1
  elsif @puts_num_array[8][1]
    @puts_num_array[8][1] = @puts_num_array[8][1] + "\n[8-001] ×：ログイン状態で、プロトタイプ詳細画面のユーザー名をクリックしても、ユーザーの詳細画面へ遷移しない。"
  else
    @puts_num_array[8][1] = "\n[8-001] ×：ログイン状態で、プロトタイプ詳細画面のユーザー名をクリックしても、ユーザーの詳細画面へ遷移しない。"
  end

  if @flag_8_001 += 2
    @puts_num_array[8][1] = "[8-001] ◯：ログイン・ログアウトの状態に関わらず、トップ画面のユーザー名及びプロトタイプ詳細画面のユーザー名をクリックすると、ユーザーの詳細画面へ遷移すること。"
  end

  # ログイン状態で、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること
  check_5_login

  # ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされること
  check_6
end


# ログアウト状態でのチェック
def logout_check
  # 最初にログアウトする。
  @d.find_element(:link_text, "ログアウト").click
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 【1-016】ログアウト状態では、ヘッダーに「新規登録」「ログイン」のリンクが存在すること
  display_flag = @d.find_element(:link_text, "新規登録").displayed? rescue false
  if display_flag
    @flag_1_017 += 1
  else
    @puts_num_array[1][17] = "[1-017] ×：ログアウト状態では、ヘッダーに「新規登録」のリンクが存在していない。"
  end

  display_flag = @d.find_element(:link_text, "ログイン").displayed? rescue false
  if display_flag
    @flag_1_017 += 1
  elsif @puts_num_array[1][17]
    @puts_num_array[1][17] = @puts_num_array[1][17] + "[1-017] ×：ログアウト状態では、ヘッダーに「ログイン」のリンクが存在していない。"
  else
    @puts_num_array[1][17] = "[1-017] ×：ログアウト状態では、ヘッダーに「ログイン」のリンクが存在していない。"
  end

  if @flag_1_017 == 2
    @puts_num_array[1][17] = "[1-017] ◯：ログアウト状態では、ヘッダーに「新規登録」「ログイン」のリンクが存在すること。"
  end

  # 【3-001】ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧可能か確認
  display_flag = @d.find_element(:class, "card").displayed? rescue false
  if display_flag
    @flag_3_001 += 1
  elsif @puts_num_array[3][1]
    @puts_num_array[3][1] = @puts_num_array[3][1] + "[3-001] ×：ログアウトの状態では、プロトタイプ一覧が表示されていない。"
  else
    @puts_num_array[3][1] = "[3-001] ×：ログアウトの状態では、プロトタイプ一覧が表示されていない。"
  end

  if @flag_3_001 == 2
    @puts_num_array[3][1] = "[3-001] ◯：ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧できること。"
  end

  # 【3-002】ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細画面へ遷移すること
  # 画像をクリックして、Prototype詳細画面に遷移するか確認
  @d.find_element(:class,"card__img").click
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "prototype__wrapper").displayed? rescue false
  if display_flag
    @flag_3_002 += 1
  elsif @puts_num_array[3][2]
    @puts_num_array[3][2] = @puts_num_array[3][2] + "×：ログアウト状態で、一覧表示されている画像をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  else
    @puts_num_array[3][2] = "×：ログアウト状態で、一覧表示されている画像をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  end

  # トップ画面へ戻る
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # Prototypeのタイトルをクリックして、Prototype詳細画面に遷移するか確認
  @d.find_element(:class,"card__title").click
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  display_flag = @d.find_element(:class, "prototype__wrapper").displayed? rescue false
  if display_flag
    @flag_3_002 += 1
  elsif @puts_num_array[3][2]
    @puts_num_array[3][2] = @puts_num_array[3][2] + "×：ログアウト状態で、一覧表示されているプロトタイプ名をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  else
    @puts_num_array[3][2] = "×：ログアウト状態で、一覧表示されているプロトタイプ名をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
  end

  if @flag_3_002 == 4
    @puts_num_array[3][2] = "[3-002] ◯：ログイン・ログアウトの状態に関わらず、一覧表示されている画像をクリックすると、該当するプロトタイプの詳細画面へ遷移すること。"
  end

  # トップ画面へ戻る
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  # 【9-001】ログアウト状態のユーザーは、プロトタイプ新規投稿/編集ページに遷移しようとすると、ログインページにリダイレクトされること
  # プロトタイプ新規投稿ページの検証
  @d.get(@post_prototype_url)
  @wait.until {/ログイン/.match(@d.page_source)}

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if /ログイン/.match(@d.page_source)
    @puts_num_array[9][1] = "[9-001] ◯：ログアウト状態のユーザーは、プロトタイプ新規投稿画面に遷移しようとすると、ログインページにリダイレクトされること。"
  elsif /新規プロトタイプ投稿/.match(@d.page_source)
    @puts_num_array[9][1] = "[9-001] ×：ログアウト状態のユーザーが、プロトタイプ新規投稿画面に遷移できてしまう。"
  elsif display_flag
    @puts_num_array[9][1] = "[9-001] ×：ログアウト状態のユーザーが、プロトタイプ新規投稿画面へ遷移しようとするとトップ画面に遷移してしまう。"
  else
    @puts_num_array[9][1] = "[9-001] ×：ログアウト状態のユーザーが、プロトタイプ新規投稿画面へ遷移しようとすると不適切なページへ遷移してしまう。"
  end

  # プロトタイプ編集ページの検証
  @d.get(@edit_prototype_url)
  @wait.until {/ログイン/.match(@d.page_source)}

  display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
  if /ログイン/.match(@d.page_source)
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ◯：ログアウト状態のユーザーは、プロトタイプ編集画面に遷移しようとすると、ログインページにリダイレクトされること。"
  elsif /プロトタイプ編集/.match(@d.page_source)
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ×：ログアウト状態のユーザーが、プロトタイプ編集画面に遷移できてしまう。"
  elsif display_flag
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ×：ログアウト状態のユーザーが、プロトタイプ編集画面へ遷移しようとするとトップ画面に遷移してしまう。"
  else
    @puts_num_array[9][1] = @puts_num_array[9][1] + "\n[9-001] ×：ログアウト状態のユーザーが、プロトタイプ編集画面へ遷移しようとすると不適切なページへ遷移してしまう。"
  end

  # 【4-001】ログイン状態の投稿したユーザーだけに、「編集」「削除」のリンクが存在すること
  @d.get(@url)
  prototype_title_click_from_top(@prototype_title)

  # ログアウト状態で、プロダクトの情報（プロトタイプ名・投稿者・画像・ キャッチコピー・コンセプト）が表示されていること
  check_2_logout

  if /編集/.match(@d.page_source) && @puts_num_array[4][1]
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001] ×：ログアウト状態のユーザーでも、「編集」のリンクが存在している。"
  elsif /編集/.match(@d.page_source)
    @puts_num_array[4][1] = "\n[4-001] ×：ログアウト状態のユーザーでも、「編集」のリンクが存在している。"
  else
    @flag_4_001 += 1
  end

  if /削除/.match(@d.page_source) && @puts_num_array[4][1]
    @puts_num_array[4][1] = @puts_num_array[4][1] + "\n[4-001] ×：ログアウト状態のユーザーでも、「削除」のリンクが存在している。"
  elsif /削除/.match(@d.page_source)
    @puts_num_array[4][1] = "\n[4-001] ×：ログアウト状態のユーザーでも、「削除」のリンクが存在している。"
  else
    @flag_4_001 += 1
  end

  if @flag_4_001 == 4
    @puts_num_array[4][1] = "[4-001] ◯：ログイン状態の投稿したユーザーだけに、「編集」「削除」のリンクが存在すること。"
  end

  # 【7-001】コメント投稿欄は、ログイン状態のユーザーへのみ、詳細ページに表示されていること
  # 修正の必要あり
  if /送信する/.match(@d.page_source) && @puts_num_array[7][1]
    @puts_num_array[7][1] = @puts_num_array[7][1] + "\n[7-001] ×：ログアウト状態のユーザーでも、プロトタイプ詳細ページにコメント投稿欄が表示されている。"
  elsif /送信する/.match(@d.page_source)
    @puts_num_array[7][1] = "\n[7-001] ×：ログアウト状態のユーザーでも、プロトタイプ詳細ページにコメント投稿欄が表示されている。"
  else
    @flag_7_001 += 1
  end

  if @flag_7_001 == 2
    @puts_num_array[7][1] = "[7-001] ◯：コメント投稿欄は、ログイン状態のユーザーへのみ、詳細ページに表示されること。"
  end

  # ユーザー詳細画面に遷移
  @d.find_element(:class, "prototype__user").click
  @wait.until {@d.find_element(:class, "user__wrapper").displayed? rescue false}

  # ログアウト状態で、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること
  check_5_logout

  # 【9-002】ログアウト状態のユーザーであっても、トップページ・プロトタイプ詳細ページ・ユーザー詳細ページ・ユーザー新規登録ページ・ログインページには遷移できること
  # トップページ・プロトタイプ詳細ページ・ユーザー詳細ページへ遷移可否は、他のチェック項目で検証済みのため「ユーザー新規登録ページ・ログインページ」のみ検証する。
  @d.get(@url)
  @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

  @d.find_element(:link_text, "新規登録").click
  @wait.until {/ユーザー新規登録/.match(@d.page_source)}

  if /ユーザー新規登録/.match(@d.page_source)
    @flag_9_002 += 1
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  else
    @puts_num_array[9][2] = "[9-002] ×：ログアウト状態では、ユーザー新規登録ページに遷移できない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  end

  @d.find_element(:link_text, "ログイン").click
  @wait.until {/ユーザーログイン/.match(@d.page_source)}

  if /ユーザーログイン/.match(@d.page_source)
    @flag_9_002 += 1
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  else
    @puts_num_array[9][2] = "[9-002] ×：ログアウト状態では、ログインページに遷移できない。"
    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}
  end

  if @flag_9_002 == 2
    @puts_num_array[9][2] = "[9-002] ◯：ログアウト状態のユーザーであっても、トップページ/プロトタイプ詳細ページ/ユーザー詳細ページ/ユーザー新規登録ページ/ログインページには遷移できること。"
  end
end
