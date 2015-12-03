require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let(:answer_of_another_user) { create(:answer, question: question, user: another_user, body: "Another Users' Answer Body") }


  before do
    sign_in(user)
    answer
  end

  describe 'POST #create' do

    context 'with valid attributes' do

      it 'save new answer in database depending with question' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(question.answers, :count).by(1)
      end

      it 'save new answer in database depending with user' do
        expect { post :create, question_id: question, answer: attributes_for(:answer), format: :js
        }.to change(user.answers, :count).by(1)
      end

      it 'render template Answers/create.js view' do
        post :create, question_id: question, answer: attributes_for(:answer), format: :js
        expect(response).to render_template :create
      end
    end

    context 'with invalid attributes' do
      it 'does not save the answer' do
        expect { post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        }.to_not change(Answer, :count)
      end

      it 'render template Answers/create.js view' do
        post :create, question_id: question, answer: attributes_for(:invalid_answer), format: :js
        expect(response).to render_template :create

      end
    end
  end


  describe 'PATCH #update' do

    context 'User is trying to update his own Answer' do

      it 'assigns the requested answer to @answer' do
        patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer body' do
        patch :update, question_id: question, id: answer, answer: {body: 'new body'}, format: :js
        answer.reload
        expect(answer.body).to eq 'new body'
      end

    end

    context 'User is trying to update his not Answer' do

      it 'does not change answer attributes' do
        patch :update, question_id: question, id: answer_of_another_user, answer: {body: 'new body'}, format: :js
        answer_of_another_user.reload
        expect(answer_of_another_user.body).to eq "Another Users' Answer Body"
      end

    end

    it 'render template Answers/update.js view' do
      patch :update, question_id: question, id: answer, answer: attributes_for(:answer), format: :js
      expect(response).to render_template :update

    end


  end

  describe 'DELETE #destroy' do


    context 'User is trying to remove his own answer ' do
      it "remove an user's answer" do
        expect { delete :destroy, question_id: question, id: answer, format: :js }.to change(user.answers, :count).by(-1)
      end
    end

    context "User is trying to remove his not answer" do
      it 'does not remove a question' do
        sign_in(another_user)
        expect { delete :destroy, question_id: question, id: answer, format: :js  }.to_not change(Answer, :count)
      end
    end

    it 'redirect to  index view' do
      delete :destroy, question_id: question, id: answer, format: :js
      expect(response).to render_template :destroy
    end

  end

end
