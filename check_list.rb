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

    # トップ画面でのPrototype情報を取得
    @wait.until {@d.find_element(:class, "card").displayed?}
    top_prototype_img = @d.find_element(:class,"card__img").attribute("src").to_s rescue "Error: class: card__img(画像)が見つかりません\n"
    top_prototype_title = @d.find_element(:class,"card__title").text rescue "Error: class: card__title(Prototype名)が見つかりません\n"
    top_prototype_catch_copy = @d.find_element(:class,"card__summary").text rescue "Error: class: card__summary(Prototypeのキャッチコピー)が見つかりません\n"
    top_prototype_user_name = @d.find_element(:class,"card__user").text.delete("by ") rescue "Error: class: card__user(Prototypeの投稿者名)が見つかりません\n"

    # トップ画面の表示内容をチェック
    if top_prototype_img&.include?(@prototype_image_name)
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「画像」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「画像」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_img
    end

    if top_prototype_title == @prototype_title
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「タイトル」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「タイトル」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_title
    end

    if top_prototype_catch_copy == @prototype_catch_copy
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「キャッチコピー」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「キャッチコピー」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_catch_copy
    end

    if top_prototype_user_name == @user_name
      check_detail["チェック詳細"] << "◯：トップ画面にPrototypeの「投稿者名」が表示されている。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：トップ画面にPrototypeの「投稿者名」が表示されていない。\n"
      check_detail["チェック詳細"] << top_prototype_user_name
    end

    # Prototype詳細画面へ遷移
    prototype_title_click_from_top(@prototype_title)

    # Prototype詳細画面でのPrototype情報を取得
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed?}
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
      # 文字列以外 = 配列だったら正常に情報が取得できた時の処理
      # prototype詳細情報の答えをハッシュに格納
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
    @wait.until {@d.find_element(:partial_link_text, "編集").displayed?}
    @d.find_element(:partial_link_text, "編集").click

    # Prototype編集画面でのPrototype情報を取得
    @wait.until {/プロトタイプ編集/.match(@d.page_source) rescue false}
    edit_prototype_title = @d.find_element(:id, "prototype_title").text rescue "Error: id: prototype_title(Prototype名)が見つかりません\n"
    edit_prototype_catch_copy = @d.find_element(:id, "prototype_catch_copy").text rescue "Error: id: prototype_catch_copy(Prototypeのキャッチコピー)が見つかりません\n"
    edit_prototype_concept = @d.find_element(:id, "prototype_concept").text rescue "Error: class: detail__message(Prototypeのコンセプト)が見つかりません\n"

    # Prototype編集画面の表示内容をチェック
    if edit_prototype_title == @prototype_title
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


# ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細ページへ遷移すること
# 現時点ではログインの場合のみの実装
def check_5
  check_detail = {"チェック番号"=> 5 , "チェック合否"=> "" , "チェック内容"=> "ログイン・ログアウトの状態に関わらず、一覧表示されている画像およびプロトタイプ名をクリックすると、該当するプロトタイプの詳細ページへ遷移すること" , "チェック詳細"=> ""}

  begin
    check_flag = 0

    # 画像をクリックして、Prototype詳細画面に遷移するか確認
    @d.find_element(:class,"card__img").click
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed?}

    if @d.find_element(:class, "prototype__wrapper").displayed?
      check_detail["チェック詳細"] << "◯：ログイン・ログアウトの状態に関わらず、一覧表示されている画像をクリックすると、該当するプロトタイプの詳細ページへ遷移する。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン・ログアウトの状態に関わらず、一覧表示されている画像をクリックしても、該当するプロトタイプの詳細ページへ遷移しない。\n"
    end

    # トップ画面へ戻る
    @d.get(@url)

    # Prototypeのタイトルをクリックして、Prototype詳細画面に遷移するか確認
    @d.find_element(:class,"card__title").click
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed?}

    if @d.find_element(:class, "prototype__wrapper").displayed?
      check_detail["チェック詳細"] << "◯：ログイン・ログアウトの状態に関わらず、一覧表示されているプロトタイプ名をクリックすると、該当するプロトタイプの詳細ページへ遷移する。\n"
      check_flag += 1
    else
      check_detail["チェック詳細"] << "×：ログイン・ログアウトの状態に関わらず、一覧表示されているプロトタイプ名をクリックしても、該当するプロトタイプの詳細ページへ遷移しない。\n"
    end

    check_detail["チェック合否"] = check_flag == 2 ? "◯" : "×"

    # トップ画面へ戻る
    @d.get(@url)

  # エラー発生有無にかかわらず実行
  ensure
    @check_log.push(check_detail)
  end
end


# コメントを投稿すると、投稿したコメントと投稿者名が、対象プロトタイプの詳細ページにのみ表示されること
def check_8
  check_detail = {"チェック番号"=> 8 , "チェック合否"=> "" , "チェック内容"=> "コメントを投稿すると、投稿したコメントとその投稿者名が、対象プロトタイプの詳細ページにのみ表示されること" , "チェック詳細"=> ""}

  begin
    check_flag = 0

    # prototype詳細画面でのコメント情報を取得
    @wait.until {@d.find_element(:class, "prototype__wrapper").displayed?}
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
