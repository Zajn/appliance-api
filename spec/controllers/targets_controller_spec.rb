require 'spec_helper'

describe TargetsController do
  describe 'GET index' do
    it 'renders the status view' do
      get :status
      expect(response).to render_template :status
    end

    # TODO: Test functionality of status method
  end
end
