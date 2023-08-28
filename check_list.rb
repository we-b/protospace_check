# 【1-003】メールアドレスは@を含む必要があること
def check_1_003
  # ＠を含まない値で確認
  randm_word = SecureRandom.hex(8)
  @check_email = "user_#{randm_word}co.jp"

  input_sign_up(@check_email, @password, @user_name, @user_profile, @user_occupation, @user_position)
  @d.find_element(:class,"form__btn").click
  @wait.until {/ユーザー新規登録/.match(@d.page_source) || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  if /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][3] = "[1-003] ◯：メールアドレスは@を含む必要がある。"
  else
    @puts_num_array[1][3] = "[1-003] ×：メールアドレスが@を含なくても新規登録できてしまう。"

    # 登録できてしまった場合、ログアウトしておく
    @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end

    @d.find_element(:link_text, "新規登録").click
    @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  end

  # 新規登録フォームの入力項目をクリア
  clear_sign_up
end


# 【1-005】パスワードは6文字以上であること
def check_1_005
  # 5文字の値で確認
  @check_password = "aaa11"

  input_sign_up(@user_email, @check_password, @user_name, @user_profile, @user_occupation, @user_position)
  @d.find_element(:class,"form__btn").click
  sleep 5
  @wait.until {/ユーザー新規登録/.match(@d.page_source) || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  if /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][5] = "[1-005] ◯：パスワードは6文字以上であること。"
  else
    @puts_num_array[1][5] = "[1-005] ×：パスワードが5文字以下でも新規登録できてしまう。"

    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end

    @d.find_element(:link_text, "新規登録").click
    @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  end
  # 新規登録フォームの入力項目をクリア
  clear_sign_up
end


# 【1-006】パスワードは確認用を含めて2回入力する
def check_1_006
  # 「パスワード再入力」の項目は未入力で確認
  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').send_keys(@user_email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(@password)
  @wait.until {@d.find_element(:id, 'user_name').displayed?}
  @d.find_element(:id, 'user_name').send_keys(@user_name)
  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').send_keys(@user_profile)
  @wait.until {@d.find_element(:id, 'user_occupation').displayed?}
  @d.find_element(:id, 'user_occupation').send_keys(@user_occupation)
  @wait.until {@d.find_element(:id, 'user_position').displayed?}
  @d.find_element(:id, 'user_position').send_keys(@user_position)

  @d.find_element(:class,"form__btn").click
  sleep 5
  @wait.until {/ユーザー新規登録/.match(@d.page_source) || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  if /ユーザー新規登録/.match(@d.page_source)
    @puts_num_array[1][6] = "[1-006] ◯：パスワードは確認用を含めて2回入力すること。"
  else
    @puts_num_array[1][6] = "[1-006] ×：「パスワード再入力」の項目が未入力でも新規登録できてしまう。"

    # 登録できてしまった場合、ログアウトしておく
    display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end

    @d.find_element(:link_text, "新規登録").click
    @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  end

  # 新規登録フォームの入力項目をクリア
  clear_sign_up
end

# 【1-018】ユーザーの新規登録には、パスワードとパスワード確認用の値の一致が必須であること
def check_1_018
  # 「パスワード再入力」の項目の値を変更確認
  @wait.until {@d.find_element(:id, 'user_email').displayed?}
  @d.find_element(:id, 'user_email').send_keys(@user_email)
  @wait.until {@d.find_element(:id, 'user_password').displayed?}
  @d.find_element(:id, 'user_password').send_keys(@password)
  @wait.until {@d.find_element(:id, 'user_password_confirmation').displayed?}
  @d.find_element(:id, 'user_password_confirmation').send_keys(@password_dummy)
  @wait.until {@d.find_element(:id, 'user_name').displayed?}
  @d.find_element(:id, 'user_name').send_keys(@user_name)
  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').send_keys(@user_profile)
  @wait.until {@d.find_element(:id, 'user_occupation').displayed?}
  @d.find_element(:id, 'user_occupation').send_keys(@user_occupation)
  @wait.until {@d.find_element(:id, 'user_position').displayed?}
  @d.find_element(:id, 'user_position').send_keys(@user_position)

  @d.find_element(:class,"form__btn").click

  # 2023/8/26削除 バックアップとして
  # @wait.until { @d.execute_script('return document.readyState') == 'complete' }
  # @wait.until {/ユーザー新規登録/.match(@d.page_source) || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  # if /ユーザー新規登録/.match(@d.page_source)
  #   @puts_num_array[1][18] = "[1-018] ◯：ユーザーの新規登録には、パスワードとパスワード確認用の値の一致が必須であること"
  # else
  #   @puts_num_array[1][18] = "[1-018] ×：ユーザーの新規登録には、パスワードとパスワード確認用の値が不一致でも新規登録できてしまう。"

  #   # 登録できてしまった場合、ログアウトしておく
  #   display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
  #   if display_flag
  #     @d.find_element(:link_text, "ログアウト").click
  #     @d.get(@url)
  #   end

  #   @d.find_element(:link_text, "新規登録").click
  #   @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  # end

  begin
    @wait.until {@d.find_element(:class, "card__wrapper").displayed?}
    @puts_num_array[1][18] = "[1-018] ×：ユーザーの新規登録には、パスワードとパスワード確認用の値が不一致でも新規登録できてしまう。"
    @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end
    @d.find_element(:link_text, "新規登録").click
    @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  rescue Selenium::WebDriver::Error::TimeoutError
    @puts_num_array[1][18] = "[1-018] ◯：ユーザーの新規登録には、パスワードとパスワード確認用の値の一致が必須であること"
  end
  # 新規登録フォームの入力項目をクリア
  clear_sign_up
end

# 【1-008】プロフィールが必須であること
def check_1_008
  # 新規登録に必要な項目入力を行うメソッド
  input_sign_up(@user_email, @password, @user_name, @user_profile, @user_occupation, @user_position)

  @wait.until {@d.find_element(:id, 'user_profile').displayed?}
  @d.find_element(:id, 'user_profile').clear
  @d.find_element(:class, "form__btn").click
  # @wait.until { @d.execute_script('return document.readyState') == 'complete' }
  # @wait.until {/ユーザー新規登録/.match(@d.page_source) || @d.find_element(:class, "card__wrapper").displayed? rescue false}

  # if /ユーザー新規登録/.match(@d.page_source)
  #   @puts_num_array[1][8] = "[1-008] ◯：プロフィールが必須であること。"
  # else
  #   @puts_num_array[1][8] = "[1-008] ×：プロフィール未入力でも登録できてしまう。"

  #   # 登録できてしまった場合、ログアウトしておく
  #   display_flag = @d.find_element(:link_text, "ログアウト").displayed? rescue false
  #   if display_flag
  #     @d.find_element(:link_text, "ログアウト").click
  #     @d.get(@url)
  #   end

  #   @d.find_element(:link_text, "新規登録").click
  #   @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  # end

  begin
    @wait.until {@d.find_element(:class, "card__wrapper").displayed?}
    @puts_num_array[1][8] = "[1-008] ×：プロフィール未入力でも登録できてしまう。"
    @d.find_element(:link_text, "ログアウト").displayed? rescue false
    if display_flag
      @d.find_element(:link_text, "ログアウト").click
      @d.get(@url)
    end
    @d.find_element(:link_text, "新規登録").click
    @wait.until {/ユーザー新規登録/.match(@d.page_source) rescue false}
  rescue Selenium::WebDriver::Error::TimeoutError
    @puts_num_array[1][8] = "[1-008] ◯：プロフィールが必須であること。"
  end

  # 新規登録フォームの入力項目をクリア
  clear_sign_up
end


# 投稿した情報は、トップページに表示されること
def check_1
  check_detail = {"チェック番号"=> 1, "チェック合否"=> "", "チェック内容"=> "プロトタイプごとに、画像/プロトタイプ名/キャッチコピー/投稿者名の4つの情報が、表示できること", "チェック詳細"=> ""}

  begin
    check_flag = 0

    # トップ画面の表示内容をチェック
    if /#{@prototype_image_name}/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「画像」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「画像」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_img
    end

    if /#{@prototype_title}/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_title
    end

    if /#{@prototype_catch_copy}/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「キャッチコピー」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「キャッチコピー」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_catch_copy
    end

    if /#{@user_name}/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「投稿者名」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「投稿者名」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_user_name
    end

    check_detail["チェック合否"] = check_flag == 4 ? "◯" : "×"

    # トップ画面へ戻る
    @d.get(@url)

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end


# ログイン状態で、プロダクトの情報（プロトタイプ名・投稿者・画像・ キャッチコピー・コンセプト）が表示されていること
def check_2_login
  
  @check_2_detail = {"チェック番号"=> 2, "チェック合否"=> "", "チェック内容"=> "ログイン・ログアウトの状態に関わらず、プロダクトの情報（プロトタイプ名/投稿者/画像/キャッチコピー/コンセプト）が表示されていること", "チェック詳細"=> ""}
  @flag_check_2 = 0;

  # 【ログイン状態】Prototype詳細画面でのPrototype情報を取得
  @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}
  show_prototype_img = @d.find_element(:class, "prototype__image").find_element(:tag_name, "img").attribute("src") rescue "Error: [ログイン状態]class: prototype__image(画像)が見つかりません\n"
  show_prototype_title = @d.find_element(:class, "prototype__hedding").text rescue "Error: [ログイン状態]class: prototype__hedding(Prototype名)が見つかりません\n"
  show_prototype_details = @d.find_elements(:class, "prototype__body") rescue "Error: [ログイン状態]class: detail__message(Prototypeのキャッチコピーまたはコンセプト)が見つかりません\n"
  show_prototype_user_name = @d.find_element(:class, "prototype__user").text.delete("by ") rescue "Error: [ログイン状態]class: prototype__user(Prototypeの投稿者名)が見つかりません\n"

  # Prototype詳細画面の表示内容をチェック
  if show_prototype_img.include?(@prototype_image_name)
    @check_2_detail["チェック詳細"] << "◯：[ログイン状態]Prototype詳細画面にPrototypeの「画像」が表示されている。\n"
    @flag_check_2 += 1
  else
    @check_2_detail["チェック詳細"] << "×：[ログイン状態]Prototype詳細画面にPrototypeの「画像」が表示されていない。\n"
    @check_2_detail["チェック詳細"] << show_prototype_img
  end

  if show_prototype_title == @prototype_title
    @check_2_detail["チェック詳細"] << "◯：[ログイン状態]Prototype詳細画面にPrototypeの「タイトル」が表示されている。\n"
    @flag_check_2 += 1
  else
    @check_2_detail["チェック詳細"] << "×：[ログイン状態]Prototype詳細画面にPrototypeの「タイトル」が表示されていない。\n"
    @check_2_detail["チェック詳細"] << show_prototype_title
  end

  if show_prototype_user_name == @user_name
    @check_2_detail["チェック詳細"] << "◯：[ログイン状態]Prototype詳細画面にPrototypeの「投稿者名」が表示されている。\n"
    @flag_check_2 += 1
  else
    @check_2_detail["チェック詳細"] << "×：[ログイン状態]Prototype詳細画面にPrototypeの「投稿者名」が表示されていない。\n"
    @check_2_detail["チェック詳細"] << show_prototype_user_name
  end

  #  detail要素が文字列だったらエラー出力処理
  if show_prototype_details.is_a?(String)
    @check_2_detail["チェック詳細"] << show_prototype_details
  else
    prototype_detail_answers = { "キャッチコピー" => @prototype_catch_copy, "コンセプト" => @prototype_concept }
    prototype_details_text = show_prototype_details.map { |e| e.text }

    prototype_detail_answers.each{|k, v|
      if prototype_details_text.include?(v)
        @check_2_detail["チェック詳細"] << "◯：[ログイン状態]Prototype詳細画面にPrototypeの「#{k}」が表示されている。\n"
        @flag_check_2 += 1
      else
        @check_2_detail["チェック詳細"] << "×：[ログイン状態]Prototype詳細画面にPrototypeの「#{k}」情報が表示されていない。\n"
      end
    }
  end
end

# ログアウト状態で、プロダクトの情報（プロトタイプ名・投稿者・画像・ キャッチコピー・コンセプト）が表示されていること
def check_2_logout
  begin
    # 【ログイン状態】Prototype詳細画面でのPrototype情報を取得
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}
    show_prototype_img = @d.find_element(:class, "prototype__image").find_element(:tag_name, "img").attribute("src") rescue "Error: [ログアウト状態]class: prototype__image(画像)が見つかりません\n"
    show_prototype_title = @d.find_element(:class, "prototype__hedding").text rescue "Error: [ログアウト状態]class: prototype__hedding(Prototype名)が見つかりません\n"
    show_prototype_details = @d.find_elements(:class, "prototype__body") rescue "Error: [ログアウト状態]class: detail__message(Prototypeのキャッチコピーまたはコンセプト)が見つかりません\n"
    show_prototype_user_name = @d.find_element(:class, "prototype__user").text.delete("by ") rescue "Error: [ログアウト状態]class: prototype__user(Prototypeの投稿者名)が見つかりません\n"

    # Prototype詳細画面の表示内容をチェック
    if show_prototype_img.include?(@prototype_image_name)
      @check_2_detail["チェック詳細"] << "◯：[ログアウト状態]Prototype詳細画面にPrototypeの「画像」が表示されている。\n"
      @flag_check_2 += 1
    else
      @check_2_detail["チェック詳細"] << "×：[ログアウト状態]Prototype詳細画面にPrototypeの「画像」が表示されていない。\n"
      @check_2_detail["チェック詳細"] << show_prototype_img
    end

    if show_prototype_title == @prototype_title
      @check_2_detail["チェック詳細"] << "◯：[ログアウト状態]Prototype詳細画面にPrototypeの「タイトル」が表示されている。\n"
      @flag_check_2 += 1
    else
      @check_2_detail["チェック詳細"] << "×：[ログアウト状態]Prototype詳細画面にPrototypeの「タイトル」が表示されていない。\n"
      @check_2_detail["チェック詳細"] << show_prototype_title
    end

    if show_prototype_user_name == @user_name
      @check_2_detail["チェック詳細"] << "◯：[ログアウト状態]Prototype詳細画面にPrototypeの「投稿者名」が表示されている。\n"
      @flag_check_2 += 1
    else
      @check_2_detail["チェック詳細"] << "×：[ログアウト状態]Prototype詳細画面にPrototypeの「投稿者名」が表示されていない。\n"
      @check_2_detail["チェック詳細"] << show_prototype_user_name
    end

    #  detail要素が文字列だったらエラー出力処理
    if show_prototype_details.is_a?(String)
      @check_2_detail["チェック詳細"] << show_prototype_details
    else
      prototype_detail_answers = { "キャッチコピー" => @prototype_catch_copy, "コンセプト" => @prototype_concept }
      prototype_details_text = show_prototype_details.map { |e| e.text }

      prototype_detail_answers.each{|k, v|
        if prototype_details_text.include?(v)
          @check_2_detail["チェック詳細"] << "◯：[ログアウト状態]Prototype詳細画面にPrototypeの「#{k}」が表示されている。\n"
          @flag_check_2 += 1
        else
          @check_2_detail["チェック詳細"] << "×：[ログアウト状態]Prototype詳細画面にPrototypeの「#{k}」情報が表示されていない。\n"
        end
      }
    end

    @check_2_detail["チェック合否"] = @flag_check_2 == 10 ? "◯" : "×"

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(@check_2_detail)
  end
end



# プロトタイプ情報について、すでに登録されている情報は、編集画面を開いた時点で表示されること
def check_3
  check_detail = {"チェック番号"=> 3, "チェック合否"=> "", "チェック内容"=> "プロトタイプ情報について、すでに登録されている情報は、編集画面を開いた時点で表示されること", "チェック詳細"=> ""}

  begin
    check_flag = 0

    # Prototype編集画面でのPrototype情報を取得
    edit_prototype_title = @d.find_element(:id, "prototype_title").text rescue "Error: id: prototype_title(Prototype名)が見つかりません\n"
    edit_prototype_catch_copy = @d.find_element(:id, "prototype_catch_copy").text rescue "Error: id: prototype_catch_copy(Prototypeのキャッチコピー)が見つかりません\n"
    edit_prototype_concept = @d.find_element(:id, "prototype_concept").text rescue "Error: class: detail__message(Prototypeのコンセプト)が見つかりません\n"

    # Prototype編集画面の表示内容をチェック
    if /#{@prototype_title}/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：Prototype編集画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype編集画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << edit_prototype_title
    end

    if edit_prototype_catch_copy == @prototype_catch_copy
      check_detail["チェック詳細"] << "◯：Prototype編集画面にPrototypeの「キャッチコピー」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype編集画面にPrototypeの「キャッチコピー」が表示されていない。\n"
      check_detail["チェック詳細"] << edit_prototype_catch_copy
    end

    if edit_prototype_concept == @prototype_concept
      check_detail["チェック詳細"] << "◯：Prototype編集画面にPrototypeの「コンセプト」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype編集画面にPrototypeの「コンセプト」が表示されていない。\n"
      check_detail["チェック詳細"] << edit_prototype_concept
    end

    check_detail["チェック合否"] = check_flag == 3 ? "◯" : "×"

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end

# 空の入力欄がある場合は、編集できずにそのページに留まること
def check_7
  check_detail = {"チェック番号"=> 7, "チェック合否"=> "", "チェック内容"=> "バリデーションによって投稿ができず、そのページに留まった場合でも、入力済みの項目（画像以外）は消えないこと", "チェック詳細"=> ""}

  begin
    check_flag = 0

    # Prototype編集画面でのPrototype情報を取得
    edit_prototype_title = @d.find_element(:id, "prototype_title").text rescue "Error: id: prototype_title(Prototype名)が見つかりません\n"
    edit_prototype_catch_copy = @d.find_element(:id, "prototype_catch_copy").text rescue "Error: id: prototype_catch_copy(Prototypeのキャッチコピー)が見つかりません\n"

    # Prototype編集画面の表示内容をチェック
    if /#{@prototype_title}/.match(@d.page_source)
      check_detail["チェック詳細"] << "◯：Prototype編集画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype編集画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << edit_prototype_title
    end

    if edit_prototype_catch_copy == @prototype_catch_copy
      check_detail["チェック詳細"] << "◯：Prototype編集画面にPrototypeの「キャッチコピー」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype編集画面にPrototypeの「キャッチコピー」が表示されていない。\n"
      check_detail["チェック詳細"] << edit_prototype_catch_copy
    end


    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end


# コメントを投稿すると、投稿したコメントと投稿者名が、対象プロトタイプの詳細画面にのみ表示されること
def check_4
  check_detail = {"チェック番号"=> 4, "チェック合否"=> "", "チェック内容"=> "コメントを投稿すると、投稿したコメントとその投稿者名が、対象プロトタイプの詳細画面にのみ表示されること", "チェック詳細"=> ""}

  begin
    check_flag = 0

    # prototype詳細画面でのコメント情報を取得
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}
    comment = @d.find_element(:class, "comments_list").text rescue "Error: class: comments_list(コメント)が見つかりません\n"
    comment_user = @d.find_element(:class, "comment_user").text rescue "Error: class: comment_user(コメント投稿者名)が見つかりません\n"

    #  prototype詳細画面でのコメント表示内容をチェック
    if comment.include?(@comment)
      check_detail["チェック詳細"] << "◯：prototype詳細画面に「コメント」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：prototype詳細画面に「コメント」が表示されていない。\n"
      check_detail["チェック詳細"] << comment
    end

    if comment_user.include?(@user_name2)
      check_detail["チェック詳細"] << "◯：prototype詳細画面に「コメント投稿者名」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：prototype詳細画面に「コメント投稿者名」が表示されていない。\n"
      check_detail["チェック詳細"] << comment_user
    end

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"
  ensure
    @check_log.push(check_detail)
  end
end


# ログイン状態で、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること
def check_5_login
  @check_5_detail = {"チェック番号"=> 5, "チェック合否"=> "", "チェック内容"=> "ログイン・ログアウトの状態に関わらず、ユーザーの詳細画面にユーザーの詳細情報（名前/プロフィール/所属/役職）と、そのユーザーが投稿したプロトタイプが表示されていること", "チェック詳細"=> ""}
  @flag_check_5 = 0;

  # ユーザー詳細画面でのユーザー情報を取得
  user_details = @d.find_elements(:class, "table__col2") rescue "Error: [ログイン状態]class: table__col2(ユーザーの詳細情報)が見つかりません\n"

  # ユーザー詳細画面の表示内容をチェック
  if user_details.is_a?(String)
    @check_5_detail["チェック詳細"] << user_details
  else
    user_detail_answers = { "名前" => @user_name, "プロフィール" => @user_profile, "所属" => @user_position, "役職" => @user_occupation }
    user_details_text = user_details.map { |e| e.text }

    user_detail_answers.each{|k, v|
      if user_details_text.include?(v)
        @check_5_detail["チェック詳細"] << "◯：[ログイン状態]ユーザー詳細画面にユーザーの「#{k}」が表示されている。\n"
        @flag_check_5 += 1
      else
        @check_5_detail["チェック詳細"] << "×：[ログイン状態]ユーザー詳細画面にユーザーの「#{k}」情報が表示されていない。\n"
      end
    }
  end

  # ユーザー詳細画面でのPrototype情報を取得
  user_prototype_img = @d.find_element(:class, "card__img").attribute("src") rescue "Error: [ログイン状態]class: card__img(画像)が見つかりません\n"
  user_prototype_title = @d.find_element(:class, "card__title").text rescue "Error: [ログイン状態]class: card__title(Prototype名)が見つかりません\n"
  user_prototype_catch_copy = @d.find_element(:class, "card__summary").text rescue "Error: [ログイン状態]class: card__summary(Prototypeのキャッチコピー)が見つかりません\n"
  user_prototype_user_name = @d.find_element(:class, "card__user").text.delete("by ") rescue "Error: [ログイン状態]class: card__user(Prototypeの投稿者名)が見つかりません\n"

  # ユーザー詳細画面でのPrototype表示内容をチェック
  if user_prototype_img.include?(@prototype_image_name)
    @check_5_detail["チェック詳細"] << "◯：[ログイン状態]ユーザー詳細画面にPrototypeの「画像」が表示されている。\n"
    @flag_check_5 += 1
  else
    @check_5_detail["チェック詳細"] << "×：[ログイン状態]ユーザー詳細画面にPrototypeの「画像」が表示されていない。\n"
    @check_5_detail["チェック詳細"] << user_prototype_img
  end

  if user_prototype_title == @prototype_title
    @check_5_detail["チェック詳細"] << "◯：[ログイン状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されている。\n"
    @flag_check_5 += 1
  else
    @check_5_detail["チェック詳細"] << "×：[ログイン状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されていない。\n"
    @check_5_detail["チェック詳細"] << user_prototype_title
  end

  if user_prototype_catch_copy == @prototype_catch_copy
    @check_5_detail["チェック詳細"] << "◯：[ログイン状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されている。\n"
    @flag_check_5 += 1
  else
    @check_5_detail["チェック詳細"] << "×：[ログイン状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されていない。\n"
    @check_5_detail["チェック詳細"] << user_prototype_catch_copy
  end

  if user_prototype_user_name == @user_name
    @check_5_detail["チェック詳細"] << "◯：[ログイン状態]ユーザー詳細画面にPrototypeの「投稿者名」が表示されている。\n"
    @flag_check_5 += 1
  else
    @check_5_detail["チェック詳細"] << "×：[ログイン状態]ユーザー詳細画面にPrototypeの「投稿者名」が表示されていない。\n"
    @check_5_detail["チェック詳細"] << user_prototype_user_name
  end

  # ユーザー詳細画面でのpage-heading表示内容をチェック
  if /#{@user_name}さんのプロトタイプ/.match(@d.page_source) && /#{@user_name}さんの情報/.match(@d.page_source)
    @check_5_detail["チェック詳細"] << "◯：[ログイン状態]ユーザー詳細画面で「〇〇さんの情報」「〇〇さんのプロトタイプ」が正しく表示されている。\n"
    @flag_check_5 += 1
  else
    @check_5_detail["チェック詳細"] << "×：[ログイン状態]ユーザー詳細画面で「〇〇さんの情報」「〇〇さんのプロトタイプ」が正しく表示されていない。\n"
  end
end


# ログアウト状態で、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること
def check_5_logout
  begin
    # ユーザー詳細画面でのユーザー情報を取得
    user_details = @d.find_elements(:class, "table__col2") rescue "Error: [ログアウト状態]class: table__col2(ユーザーの詳細情報)が見つかりません\n"

    # ユーザー詳細画面の表示内容をチェック
    if user_details.is_a?(String)
      @check_5_detail["チェック詳細"] << user_details
    else
      user_detail_answers = { "名前" => @user_name, "プロフィール" => @user_profile, "所属" => @user_position, "役職" => @user_occupation }
      user_details_text = user_details.map { |e| e.text }

      user_detail_answers.each{|k, v|
        if user_details_text.include?(v)
          @check_5_detail["チェック詳細"] << "◯：[ログアウト状態]ユーザー詳細画面にユーザーの「#{k}」が表示されている。\n"
          @flag_check_5 += 1
        else
          @check_5_detail["チェック詳細"] << "×：[ログアウト状態]ユーザー詳細画面にユーザーの「#{k}」情報が表示されていない。\n"
        end
      }
    end

    # ユーザー詳細画面でのPrototype情報を取得
    user_prototype_img = @d.find_element(:class, "card__img").attribute("src") rescue "Error: [ログアウト状態]class: card__img(画像)が見つかりません\n"
    user_prototype_title = @d.find_element(:class, "card__title").text rescue "Error: [ログアウト状態]class: card__title(Prototype名)が見つかりません\n"
    user_prototype_catch_copy = @d.find_element(:class, "card__summary").text rescue "Error: [ログアウト状態]class: card__summary(Prototypeのキャッチコピー)が見つかりません\n"
    user_prototype_user_name = @d.find_element(:class, "card__user").text.delete("by ") rescue "Error: [ログアウト状態]class: card__user(Prototypeの投稿者名)が見つかりません\n"

    # ユーザー詳細画面でのPrototype表示内容をチェック
    if user_prototype_img.include?(@prototype_image_name)
      @check_5_detail["チェック詳細"] << "◯：[ログアウト状態]ユーザー詳細画面にPrototypeの「画像」が表示されている。\n"
      @flag_check_5 += 1
    else
      @check_5_detail["チェック詳細"] << "×：[ログアウト状態]ユーザー詳細画面にPrototypeの「画像」が表示されていない。\n"
      @check_5_detail["チェック詳細"] << user_prototype_img
    end

    if user_prototype_title == @prototype_title
      @check_5_detail["チェック詳細"] << "◯：[ログアウト状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されている。\n"
      @flag_check_5 += 1
    else
      @check_5_detail["チェック詳細"] << "×：[ログアウト状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されていない。\n"
      @check_5_detail["チェック詳細"] << user_prototype_title
    end

    if user_prototype_catch_copy == @prototype_catch_copy
      @check_5_detail["チェック詳細"] << "◯：[ログアウト状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されている。\n"
      @flag_check_5 += 1
    else
      @check_5_detail["チェック詳細"] << "×：[ログアウト状態]ユーザー詳細画面にPrototypeの「タイトル」が表示されていない。\n"
      @check_5_detail["チェック詳細"] << user_prototype_catch_copy
    end

    if user_prototype_user_name == @user_name
      @check_5_detail["チェック詳細"] << "◯：[ログアウト状態]ユーザー詳細画面にPrototypeの「投稿者名」が表示されている。\n"
      @flag_check_5 += 1
    else
      @check_5_detail["チェック詳細"] << "×：[ログアウト状態]ユーザー詳細画面にPrototypeの「投稿者名」が表示されていない。\n"
      @check_5_detail["チェック詳細"] << user_prototype_user_name
    end

  # ユーザー詳細画面のpage-headingの表示内容をチェック

  # ユーザー詳細画面でのpage-heading表示内容をチェック
  if /#{@user_name}さんのプロトタイプ/.match(@d.page_source) && /#{@user_name}さんの情報/.match(@d.page_source)
    @check_5_detail["チェック詳細"] << "◯：[ログアウト状態]ユーザー詳細画面で「〇〇さんの情報」「〇〇さんのプロトタイプ」が正しく表示されている。\n"
    @flag_check_5 += 1
  else
    @check_5_detail["チェック詳細"] << "×：[ログアウト状態]ユーザー詳細画面で「〇〇さんの情報」「〇〇さんのプロトタイプ」が正しく表示されていない。\n"
  end

    @check_5_detail["チェック合否"] = @flag_check_5 == 18 ? "◯" : "×"

  ensure
    @check_log.push(@check_5_detail)
  end
end


# ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされること
def check_6
  check_detail = {"チェック番号"=> 6, "チェック合否"=> "", "チェック内容"=> "ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされること", "チェック詳細"=> ""}
  check_flag = 0

  begin
    # user2ログイン状態でコート(user1出品)編集画面に直接遷移する
    @d.get(@edit_prototype_url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

    # トップ画面に遷移であれば正解
    display_flag = @d.find_element(:class, "card__wrapper").displayed? rescue false
    if display_flag
      check_detail["チェック詳細"] << "◯：ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされる。\n"
      check_flag += 1
    elsif /ユーザー新規登録/.match(@d.page_source)
      check_detail["チェック詳細"] << "×：ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、ログイン画面に遷移してしまう。\n"
    else
      check_detail["チェック詳細"] << "×：ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面/ログイン画面以外に遷移してしまう。\n"
    end

    @d.get(@url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

    check_detail["チェック合否"] = check_flag == 1 ? "◯" : "×"
  ensure
    @check_log.push(check_detail)
  end
end
