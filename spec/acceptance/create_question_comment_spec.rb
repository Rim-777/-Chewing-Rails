require_relative 'acceptance_helper'

feature 'Create Comment', %q{
In order to comment  questions as an authenticated user
I want to be able to create comments } do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'the authenticated user is trying to add a comment to the question', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question_existed_area .question_comments' do
      expect(page).to have_field "question_#{question.id}_comment_add_area"
      fill_in "question_#{question.id}_comment_add_area", with: ''
      expect(page).to_not have_field "question_#{question.id}_comment_add_area"
      expect(page).to have_field "question_#{question.id}_comment_body_area"
      expect(page).to have_button "question_#{question.id}_add_comment_button"
      fill_in "question_#{question.id}_comment_body_area", with: 'some comment text'
      click_on "question_#{question.id}_add_comment_button"
      expect(page).to have_content 'some comment text'
      expect(page).to_not have_field "question_#{question.id}_comment_body_area"
      expect(page).to_not have_button "question_#{question.id}_add_comment_button"
      expect(page).to have_field "question_#{question.id}_comment_add_area"
    end
  end

  scenario 'some unauthenticate user is trying to add a comment to the question', js: true do
    visit question_path(question)
    within '.question_existed_area .question_comments' do
      fill_in "question_#{question.id}_comment_add_area", with: ''
      fill_in "question_#{question.id}_comment_body_area", with: 'some comment text'
      click_on "question_#{question.id}_add_comment_button"
      expect(page).to_not have_content 'some comment text'
      expect(page).to have_field "question_#{question.id}_comment_body_area"
      expect(page).to have_button "question_#{question.id}_add_comment_button"
      expect(page).to_not have_field "question_#{question.id}_add_area"
    end
  end

  scenario 'the user is trying create an invalid comment', js: true do
    sign_in(user)
    visit question_path(question)
    within '.question_existed_area .question_comments' do
      fill_in "question_#{question.id}_comment_add_area", with: ''
      click_on "question_#{question.id}_add_comment_button"
      expect(page).to have_field "question_#{question.id}_comment_body_area"
      expect(page).to have_button "question_#{question.id}_add_comment_button"
      expect(page).to_not have_field "question_#{question.id}_add_area"
    end
  end
end
