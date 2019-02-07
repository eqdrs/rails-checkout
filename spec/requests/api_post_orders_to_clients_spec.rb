require 'rails_helper'

describe 'Api post orders to clients' do
  it 'successfully' do
    allow(Net::HTTP).to receive(:post).and_return(http_status: :ok)
  end
end