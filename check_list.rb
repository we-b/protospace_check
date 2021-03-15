# パスワードは6文字以上であること
# check_1


# ログアウト状態では、ヘッダーに「新規登録」「ログイン」のリンクが表示されるよう実装しましょう
# check_3


# ログインのログアウトの状態に関わらず、プロトタイプ一覧を閲覧できること
# 現時点ではログインの場合のみの実装
def check_4
  check_detail = {"チェック番号"=> 4 , "チェック合否"=> "" , "チェック内容"=> "ログイン・ログアウトの状態に関わらず、プロトタイプ一覧を閲覧できること" , "チェック詳細"=> ""}

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

    # Prototype詳細画面へ遷移
    prototype_title_click_from_top(@prototype_title)

    # Prototype詳細画面でのPrototype情報を取得
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}
    show_prototype_img = @d.find_element(:class, "prototype__image").find_element(:tag_name, "img").attribute("src") rescue "Error: class: prototype__image(画像)が見つかりません\n"
    show_prototype_title = @d.find_element(:class, "prototype__hedding").text rescue "Error: class: prototype__hedding(Prototype名)が見つかりません\n"
    show_prototype_details = @d.find_elements(:class, "detail__message") rescue "Error: class: detail__message(Prototypeのキャッチコピーまたはコンセプト)が見つかりません\n"
    show_prototype_user_name = @d.find_element(:class, "prototype__user").text.delete("by ") rescue "Error: class: prototype__user(Prototypeの投稿者名)が見つかりません\n"

    # Prototype詳細画面の表示内容をチェック
    if show_prototype_img.include?(@prototype_image_name)
      check_detail["チェック詳細"] << "◯：Prototype詳細画面にPrototypeの「画像」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype詳細画面にPrototypeの「画像」が表示されていない。\n"
      check_detail["チェック詳細"] << show_prototype_img
    end

    if show_prototype_title == @prototype_title
      check_detail["チェック詳細"] << "◯：Prototype詳細画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype詳細画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << show_prototype_title
    end

    if show_prototype_user_name == @user_name
      check_detail["チェック詳細"] << "◯：Prototype詳細画面にPrototypeの「投稿者名」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：Prototype詳細画面にPrototypeの「投稿者名」が表示されていない。\n"
      check_detail["チェック詳細"] << show_prototype_user_name
    end

    #  detail要素が文字列だったらエラー出力処理
    if show_prototype_details.is_a?(String)
      check_detail["チェック詳細"] << show_prototype_details
    else
      prototype_detail_answers = { "キャッチコピー" => @prototype_catch_copy, "コンセプト" => @prototype_concept }
      prototype_details_text = show_prototype_details.map { |e| e.text }

      prototype_detail_answers.each{|k, v|
        if prototype_details_text.include?(v)
          check_detail["チェック詳細"] << "◯：Prototype詳細画面にPrototypeの「#{k}」が表示されている。\n"
          check_flag += 1
        else
          check_detail["チェック詳細"] << "×：Prototype詳細画面にPrototypeの「#{k}」情報が表示されていない。\n"
        end
      }
    end

    # Prototype編集画面へ遷移
    @d.find_element(:partial_link_text, "編集").click

    # Prototype編集画面でのPrototype情報を取得
    @wait.until {/プロトタイプ編集/.match(@d.page_source) rescue false}
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

    check_detail["チェック合否"] = check_flag == 12 ? "◯" : "×"

    # トップ画面へ戻る
    @d.get(@url)

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end


# ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細画面へ遷移すること
# 現時点ではログインの場合のみの実装
def check_5
  check_detail = {"チェック番号"=> 5 , "チェック合否"=> "" , "チェック内容"=> "ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細画面へ遷移すること" , "チェック詳細"=> ""}

  begin
    check_flag = 0

    # 画像をクリックして、Prototype詳細画面に遷移するか確認
    @d.find_element(:class,"card__img").click
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}

    if @d.find_element(:class, "prototype__wrapper").displayed?
      check_detail["チェック詳細"] << "◯：ログイン・ログアウトの状態に関わらず、一覧表示されている画像をクリックすると、該当するプロトタイプの詳細画面へ遷移する。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン・ログアウトの状態に関わらず、一覧表示されている画像をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
    end

    # トップ画面へ戻る
    @d.get(@url)

    # Prototypeのタイトルをクリックして、Prototype詳細画面に遷移するか確認
    @d.find_element(:class,"card__title").click
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed? rescue false}

    if @d.find_element(:class, "prototype__wrapper").displayed?
      check_detail["チェック詳細"] << "◯：ログイン・ログアウトの状態に関わらず、一覧表示されているプロトタイプ名をクリックすると、該当するプロトタイプの詳細画面へ遷移する。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン・ログアウトの状態に関わらず、一覧表示されているプロトタイプ名をクリックしても、該当するプロトタイプの詳細画面へ遷移しない。\n"
    end

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

    # トップ画面へ戻る
    @d.get(@url)

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end


# コメントを投稿すると、投稿したコメントと投稿者名が、対象プロトタイプの詳細画面にのみ表示されること
def check_8
  check_detail = {"チェック番号"=> 8 , "チェック合否"=> "" , "チェック内容"=> "コメントを投稿すると、投稿したコメントとその投稿者名が、対象プロトタイプの詳細画面にのみ表示されること" , "チェック詳細"=> ""}

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


# ログイン・ログアウトの状態に関わらず、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること
def check_9
  check_detail = {"チェック番号"=> 9 , "チェック合否"=> "" , "チェック内容"=> "ログイン・ログアウトの状態に関わらず、ユーザーの詳細画面にユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されていること" , "チェック詳細"=> ""}

  begin
    check_flag = 0

    # ユーザー詳細画面でのユーザー情報を取得
    user_details = @d.find_elements(:class, "table__col2") rescue "Error: class: table__col2(ユーザーの詳細情報)が見つかりません\n"

    # ユーザー詳細画面の表示内容をチェック
    if user_details.is_a?(String)
      check_detail["チェック詳細"] << user_details
    else
      user_detail_answers = { "名前" => @user_name, "プロフィール" => @user_profile, "所属" => @user_position, "役職" => @user_occupation }
      user_details_text = user_details.map { |e| e.text }

      user_detail_answers.each{|k, v|
        if user_details_text.include?(v)
          check_detail["チェック詳細"] << "◯：ユーザー詳細画面にユーザーの「#{k}」が表示されている。\n"
          check_flag += 1
        else
          check_detail["チェック詳細"] << "×：ユーザー詳細画面にユーザーの「#{k}」情報が表示されていない。\n"
        end
      }
    end

    # ユーザー詳細画面でのPrototype情報を取得
    user_prototype_img = @d.find_element(:class, "card__img").attribute("src") rescue "Error: class: card__img(画像)が見つかりません\n"
    user_prototype_title = @d.find_element(:class, "card__title").text rescue "Error: class: card__title(Prototype名)が見つかりません\n"
    user_prototype_catch_copy = @d.find_element(:class, "card__summary").text rescue "Error: class: card__summary(Prototypeのキャッチコピー)が見つかりません\n"
    user_prototype_user_name = @d.find_element(:class, "card__user").text.delete("by ") rescue "Error: class: card__user(Prototypeの投稿者名)が見つかりません\n"

    # ユーザー詳細画面でのPrototype表示内容をチェック
    if user_prototype_img.include?(@prototype_image_name)
      check_detail["チェック詳細"] << "◯：ユーザー詳細画面にPrototypeの「画像」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ユーザー詳細画面にPrototypeの「画像」が表示されていない。\n"
      check_detail["チェック詳細"] << user_prototype_img
    end

    if user_prototype_title == @prototype_title
      check_detail["チェック詳細"] << "◯：ユーザー詳細画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ユーザー詳細画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << user_prototype_title
    end

    if user_prototype_catch_copy == @prototype_catch_copy
      check_detail["チェック詳細"] << "◯：ユーザー詳細画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ユーザー詳細画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << user_prototype_catch_copy
    end

    if user_prototype_user_name == @user_name
      check_detail["チェック詳細"] << "◯：ユーザー詳細画面にPrototypeの「投稿者名」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ユーザー詳細画面にPrototypeの「投稿者名」が表示されていない。\n"
      check_detail["チェック詳細"] << user_prototype_user_name
    end

    check_detail["チェック合否"] = check_flag == 8 ? "◯" : "×"

    # トップ画面へ戻る
    @d.get(@url)

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end


# ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされること
def check_10
  check_detail = {"チェック番号"=> 10 , "チェック合否"=> "" , "チェック内容"=> "ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集画面のURLを直接入力して遷移しようとすると、トップ画面にリダイレクトされること" , "チェック詳細"=> ""}
  check_flag = 0

  begin
    # user2ログイン状態でコート(user1出品)編集画面に直接遷移する
    @d.get(@edit_prototype_url)
    @wait.until {@d.find_element(:class, "card__wrapper").displayed? rescue false}

    # トップ画面に遷移であれば正解
    if @d.find_element(:class, "card__wrapper").displayed?
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


# ユーザー新規登録画面でのエラーハンドリングログを取得
def check_19_1
  #全項目未入力で「登録する」ボタンをクリック
  @d.find_element(:class, "form__btn").click
  @wait.until { /ユーザー新規登録/.match(@d.page_source) rescue false}

  #念の為登録できてしまわないかチェック
  if /ユーザー新規登録/.match(@d.page_source)
    @error_log_hash["新規登録"] = "◯：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すと、登録が完了せずエラーメッセージが出力される\n\n"
    @error_log_hash["新規登録"] << "↓↓↓ エラーログ全文(出力された内容) ↓↓↓\n"
  else
    #登録できてしまう場合
    @error_log_hash["新規登録"] = "×：【ユーザー新規登録画面】にて全項目未入力の状態で登録ボタンを押すと、リダイレクトせず登録画面以外の画面へ遷移してしまう(登録できてしまっている可能性あり)\n"

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
