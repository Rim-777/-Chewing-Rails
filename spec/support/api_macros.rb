module ApiMacros

  def un_authorized_request(uri)
    context 'un-authorized' do
      it 'return 401 status if there is no access_token' do
        get uri, format: :json
        expect(response.status).to eq 401
      end

      it 'return 401 status if there is invalid access_token' do
        get uri, format: :json, access_token: '1234'
        expect(response.status).to eq 401
      end
    end
  end

end