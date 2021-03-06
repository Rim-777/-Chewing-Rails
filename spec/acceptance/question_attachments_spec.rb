require_relative 'acceptance_helper'

feature 'Add files to Question', %q{
In order to illustrate some details of my question
I want to be able to attach some files to my questions} do
  given(:author_of_question) { create(:user) }
  before do
    sign_in(author_of_question)
    visit new_question_path
  end

  scenario 'the user can attach file when he/she is asking question'  do
    fill_in 'question_title', with: 'Test question'
    fill_in 'question_body', with: 'Test question body'
    attach_file "question_attachments_attributes_0_file", "#{Rails.root}/spec/spec_helper.rb"
    click_on 'Create'
    expect(page).to have_link 'spec_helper.rb', href: '/uploads/test/attachment/file/1/spec_helper.rb'
  end

  scenario 'user is trying to add a few files to the question by a few file_fields', js: true do
    within '#question_form_new' do
      fill_in 'question_title', with: 'Question Title Test'
      fill_in 'question_body', with: 'Question Body Test'
    end

    within '.new_question' do
      expect(page).to have_link '[+]'
      click_on '[+]'
      add_inputs_type_files
    end

    click_on 'question_create_button'
      within '.question_existed_area' do
        expect(page).to have_link 'spec_helper.rb'
        expect(page).to have_link 'rails_helper.rb'
      end
  end

  scenario 'the user is trying top remove one of a few added file_fields', js: true do
    within '#question_form_new' do
      fill_in 'question_title', with: 'Question Title Test'
      fill_in 'question_body', with: 'Question Body Test'
    end

    within '.new_question' do
      click_on '[+]'
      add_inputs_type_files
      expect(page).to have_link '[-]'
      click_on '[-]',  match: :first
    end

    click_on 'question_create_button'
    within '.question_existed_area' do
      expect(page).to_not have_link 'spec_helper.rb'
      expect(page).to have_link 'rails_helper.rb'
    end
  end
end
