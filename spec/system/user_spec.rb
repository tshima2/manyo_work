require 'rails_helper'
# require 'helpers/basic_auth_helper.rb'

RSpec.describe 'ユーザ登録のテスト', type: :system do

  before do
    #それぞれの権限をもつユーザを作成する
    @user=FactoryBot.create(:user)
    @admin=FactoryBot.create(:user_admin)

    #ラベルをあらかじめ取得
    @label_sessions_title_new=I18n.t('sessions.label_title_new')
    @label_sessions_email=I18n.t('sessions.label_email')
    @label_sessions_password=I18n.t('sessions.label_password')
    @label_sessions_password_confirmation=I18n.t('sessions.label_password_confirmation')
    @label_sessions_submit_login=I18n.t('sessions.label_submit_login')

    @notice_login_needed=I18n.t('notice.login_needed')
    @notice_other_users_mypage=I18n.t('notice.other_users_mypage')
    @msg_logout_success=I18n.t('application.msg_logout_success')
    @msg_admin_priv_denied_to_access=I18n.t('application.msg_admin_priv_denied_to_access')

    @label_users_title_signup=I18n.t('users.label_title_signup')
    @label_users_title_mypage=I18n.t('users.label_title_mypage')
    @label_users_name=I18n.t('users.label_name')
    @label_users_email=I18n.t('users.label_email')
    @label_users_password=I18n.t('users.label_password')
    @label_users_submit_new=I18n.t('admin.users.label_submit_new')
    @label_users_submit_signup=I18n.t('users.label_submit_signup')

    @label_tasks_index=I18n.t('tasks.label_index')

    @label_admin_users_title_index=I18n.t('admin.users.label_title_index')
    @label_admin_users_link_new=I18n.t('admin.users.label_link_new')
    @label_admin_users_title_new=I18n.t('admin.users.label_title_new')
    @label_admin_users_link_show=I18n.t('admin.users.label_link_show')
    @label_admin_users_link_edit=I18n.t('admin.users.label_link_edit')
    @label_admin_users_link_destroy=I18n.t('admin.users.label_link_destroy')

    @label_admin_users_name=I18n.t('admin.users.label_name')
    @label_admin_users_email=I18n.t('admin.users.label_email')
    @label_admin_users_admin=I18n.t('admin.users.label_admin')
    
    #@msg_admin_users_confirm_destroy=I18n.t('admin.users.msg_confirm_destroy')    
  end


  describe 'ユーザ登録のテスト' do
    before do
    end

    context 'ユーザの新規登録ができること' do
      it 'ログインしていない状態で, Signup画面から新規ユーザ登録する' do

        #Sign Up 画面に遷移
        visit new_user_path
        sleep(0.5)

        expect(page).to have_content @label_users_title_signup
        expect(page).to have_content @label_users_name
        expect(page).to have_content @label_users_email
        expect(page).to have_content @label_users_password

        #新規ユーザ名, メール, パスワード, 確認用パスワードを打ち込み, "Create my accoun"ボタン押下
        fill_in "user_name", with: 'test99'
        fill_in "user_email", with: 'test99@example.com'
        fill_in "user_password", with: 'test99'
        fill_in "user_password_confirmation", with: 'test99'

        click_on "new_user_submit"
        sleep(0.5)

        #マイページに遷移し, 先に打ち込んだメールアドレスが表示されていることを確認
        expect(page).to have_content 'test99@example.com'

      end
    end
    context 'ユーザがログインせずタスク一覧画面に飛ぼうとしたとき、ログイン画面に遷移すること' do
      it 'ユーザがログインせずタスク一覧画面に飛ぼうとしたとき、ログイン画面に遷移すること' do
        # タスク一覧画面をリクエスト
        visit tasks_path
        sleep(0.5)

        # ログイン画面に遷移していることを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

      end
    end
  end

  describe 'セッション機能のテスト' do
    before do
    end

    context 'ログインができること' do
      it '一般ユーザがログインに成功すると自分の詳細画面（マイページ）に飛んでいること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にてemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @user.email
        fill_in "session_password", with: @user.password
        fill_in "session_password_confirmation", with: @user.password
        click_on "new_session_submit"
        sleep(0.5)

        # マイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @user.email

      end
    end
    context '一般ユーザが他人の詳細画面に飛ぶとタスク一覧画面に遷移すること' do
      it '一般ユーザがログインした後に、登録済みの他人の詳細ページをリクエストするとタスク一覧に遷移すること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にてemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @user.email
        fill_in "session_password", with: @user.password
        fill_in "session_password_confirmation", with: @user.password
        click_on "new_session_submit"
        sleep(0.5)

        # マイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @user.email

        # 登録済み@adminのマイページをリクエスト
        visit user_path(@admin.id)
        sleep(0.5)

        # タスク一覧画面に遷移することを確認
        expect(page).to have_content @notice_other_users_mypage
        expect(page).to have_content @label_tasks_index
      end
    end
    context 'ログアウトができること' do
      it '一般ユーザがログインした後に、ログアウトのリンクからログアウトできること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にてemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @user.email
        fill_in "session_password", with: @user.password
        fill_in "session_password_confirmation", with: @user.password
        click_on "new_session_submit"
        sleep(0.5)

        # マイページに遷移することを確認
        expect(page).to have_content "Logout"
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @user.email

        # 画面上部のログアウトリンクをクリック
        click_on "application_logout"
        sleep(0.5)

        # ログイン画面への遷移を確認
        expect(page).to have_content @msg_logout_success
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

      end
    end
  end

  describe '管理画面のテスト' do
    before do
    end

    context '管理ユーザは管理画面にアクセスできること' do
      it '管理ユーザは管理画面にアクセスできること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にて管理ユーザ@adminのemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @admin.email
        fill_in "session_password", with: @admin.password
        fill_in "session_password_confirmation", with: @admin.password
        click_on "new_session_submit"
        sleep(0.5)

        # 管理ユーザのマイページに遷移, 管理者メニューが表示されていることを確認
        expect(page).to have_content "Admin"
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @admin.email

        # 管理者メニューのリンクをクリック
        click_on "application_admin"
        sleep(0.5)

        # 管理者メニューへ遷移していることを確認
        expect(page).to have_content @label_admin_users_title_index

      end
    end
    context '一般ユーザは管理画面にアクセスできないこと' do
      it '一般ユーザがログインした管理者メニューへのリンクが表示されていないこと' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にて一般ユーザ@userのemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @user.email
        fill_in "session_password", with: @user.password
        fill_in "session_password_confirmation", with: @user.password
        click_on "new_session_submit"
        sleep(0.5)

        # ログインユーザのマイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @user.email

        # 管理者メニューのリンクが表示されていないことを確認
        expect(page).not_to have_content "Admin"

        # 管理者画面をリクエストしたらタスク一覧に遷移することを確認
        visit admin_users_path
        sleep(0.5)

        expect(page).to have_content @msg_admin_priv_denied_to_access
        expect(page).to have_content @label_tasks_index

      end
    end
    context '管理ユーザはユーザの新規登録ができること' do
      it '管理ユーザはユーザの新規登録ができること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にて管理ユーザ@adminのemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @admin.email
        fill_in "session_password", with: @admin.password
        fill_in "session_password_confirmation", with: @admin.password
        click_on "new_session_submit"
        sleep(0.5)

        # 管理ユーザのマイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @admin.email

        # 管理者メニューのリンクをクリック
        click_on "application_admin"
        sleep(0.5)

        # 管理者メニューへ遷移していることを確認
        expect(page).to have_content @label_admin_users_title_index

        # 新規作成リンク押下
        click_link @label_admin_users_link_new
        sleep(0.5)

        # 新規作成画面へ遷移することを確認
        expect(page).to have_content @label_admin_users_title_new

        # 名前、メール、パスワード、確認用パスワード、admin権限を入力し「更新する」ボタン押下
        fill_in "user_name", with: 'test99'
        fill_in "user_email", with: 'test99@example.com'
        fill_in "user_password", with: 'test99'
        fill_in "user_password_confirmation", with: 'test99'
        click_on "new_user_submit"
        sleep(0.5)

        # 入力したユーザが出来ていることを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content 'test99@example.com'

      end
    end
    context '管理ユーザはユーザの詳細画面にアクセスできること' do
      it '管理ユーザはユーザの詳細画面にアクセスできること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にて管理ユーザ@adminのemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @admin.email
        fill_in "session_password", with: @admin.password
        fill_in "session_password_confirmation", with: @admin.password
        click_on "new_session_submit"
        sleep(0.5)

        # 管理ユーザのマイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @admin.email

        # 管理者メニューのリンクをクリック
        click_on "application_admin"
        sleep(0.5)

        # 管理者メニューへ遷移していることを確認
        expect(page).to have_content @label_admin_users_title_index

        user_list_name = all('.user_row_name'); _name = user_list_name[0].text
        user_list_email = all('.user_row_email'); _email = user_list_email[0].text
        user_list_admin = all('.user_row_admin'); _admin = user_list_admin[0].text

        # リスト内「詳細」リンク押下
        first(:link, @label_admin_users_link_show).click
        sleep(0.5)

        # 選択したユーザのマイページに遷移していることを確認
        @label_admin_users_title_mypage = I18n.t('admin.users.label_title_mypage', name: _name)
        expect(page).to have_content @label_admin_users_title_mypage
        expect(page).to have_content _name
        expect(page).to have_content _email
        expect(page).to have_content _admin

      end
    end

    context '管理ユーザはユーザの編集画面からユーザを編集できること' do
      it '管理ユーザはユーザの編集画面からユーザを編集できること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にて管理ユーザ@adminのemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @admin.email
        fill_in "session_password", with: @admin.password
        fill_in "session_password_confirmation", with: @admin.password
        click_on "new_session_submit"
        sleep(0.5)

        # 管理ユーザのマイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @admin.email

        # 管理者メニューのリンクをクリック
        click_on "application_admin"
        sleep(0.5)

        # 管理者メニューへ遷移していることを確認
        expect(page).to have_content @label_admin_users_title_index

        user_list_name = all('.user_row_name'); _name = user_list_name[0].text
        user_list_email = all('.user_row_email'); _email = user_list_email[0].text

        # リスト内「編集」ボタン押下
        first(:link, @label_admin_users_link_edit).click
        sleep(0.5)

        # 選択したユーザの編集ページに遷移していることを確認
        @label_admin_users_title_edit = I18n.t('admin.users.label_title_edit', name: _name)
        expect(page).to have_content @label_admin_users_title_edit
        expect(page).to have_field 'user[name]', with: _name
        expect(page).to have_field 'user[email]', with: _email

        # 編集ページ内の名前に変更後の名前を入力し、「更新する」ボタン押下
        fill_in "user_name", with: '_changed_name_'
        click_on "admin_new_user_submit"
        sleep(0.5)

        # 該当ユーザの詳細ページにて変更後の名前が入力されていることを確認
        expect(page).to have_content @label_admin_users_mypage
        expect(page).to have_content '_changed_name_'
      end
    end
    context '管理ユーザはユーザの削除をできること' do
      it '管理ユーザはユーザの削除をできること' do
        # ルート画面をリクエスト
        visit root_path
        sleep(0.5)

        # ログイン画面に遷移することを確認
        expect(page).to have_content @notice_login_needed
        expect(page).to have_content @label_sessions_title_new
        expect(page).to have_content @label_sessions_email
        expect(page).to have_content @label_sessions_password
        expect(page).to have_content @label_sessions_password_confirmation

        # ログイン画面にて管理ユーザ@adminのemail, パスワード, 確認用パスワードを打ち込んで"Log in"ボタン押下
        fill_in "session_email", with: @admin.email
        fill_in "session_password", with: @admin.password
        fill_in "session_password_confirmation", with: @admin.password
        click_on "new_session_submit"
        sleep(0.5)

        # 管理ユーザのマイページに遷移することを確認
        expect(page).to have_content @label_users_title_mypage
        expect(page).to have_content @label_users_email
        expect(page).to have_content @admin.email

        # 管理者メニューのリンクをクリック
        click_on "application_admin"
        sleep(0.5)

        # 管理者メニューへ遷移し、削除対象の先頭ユーザが表示されていることを確認
        expect(page).to have_content @label_admin_users_title_index
        expect(page).to have_content @user.name
        expect(page).to have_content @user.email

        # リスト内で作成済み一般ユーザ@userの「削除」ボタン押下
        # 削除しますか？ダイアログでＯＫボタン押下
        page.accept_confirm do
          first(:link, @label_admin_users_link_destroy).click
        end
        sleep(0.5)

        # 遷移したユーザリスト内で該当ユーザが削除されていることを確認
        expect(page).to have_content @label_admin_users_title_index
        expect(page).not_to have_content @user.name
        expect(page).not_to have_content @user.email
      end
    end
  end

end
