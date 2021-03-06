require 'spec_helper'

describe Tenon::ContactsController do
  routes { Tenon::Engine.routes }

  let(:user) do
    double(
      :staff? => true,
      :is_super_admin? => false,
      :is_admin? => true
    )
  end

  let(:contact) { double.as_null_object }

  before do
    controller.stub(:current_user) { user }
    controller.stub(:polymorphic_index_path) { '/tenon/contacts' }
  end

  describe 'GET index.html' do
    it 'should get the contact counts' do
      expect(Tenon::Contact).to receive(:count) { [] }
      expect(Tenon::Contact).to receive(:read) { [] }
      expect(Tenon::Contact).to receive(:unread) { [] }
      expect(Tenon::Contact).to receive(:replied) { [] }
      expect(Tenon::Contact).to receive(:unreplied) { [] }
      get :index, format: 'html'
    end

    it 'should assign the contact counts' do
      get :index, format: 'html'
      expect(assigns[:counts]).not_to be_nil
    end
  end

  describe 'GET index.json' do
    before do
      [:all, :where, :approved, :unapproved, :paginate].each do |query|
        Tenon::Contact.stub(query) { Tenon::Contact }
      end
    end

    context 'without params[:q] and without params[:type]' do
      it 'should find and paginate, and decorate the Comments' do
        expect(Tenon::Contact).to receive(:all) { Tenon::Contact }
        expect(Tenon::Contact).to receive(:paginate) { Tenon::Contact }
        expect(Tenon::PaginatingDecorator).to receive(:decorate).with(Tenon::Contact)
        get :index, format: 'json'
      end

      it "shouldn't search or sort the contacts by type" do
        expect(Tenon::Contact).not_to receive(:where)
        expect(Tenon::Contact).not_to receive(:approved)
        expect(Tenon::Contact).not_to receive(:unapproved)
        get :index, format: 'json'
      end
    end

    context 'with params[:q] = "search"' do
      it 'should search the contacts with the query' do
        args = [
          'name ILIKE :q OR email ILIKE :q OR phone ILIKE :q OR content ILIKE :q OR user_ip ILIKE :q',
          { q: '%search%' }
        ]
        expect(Tenon::Contact).to receive(:all) { Tenon::Contact }
        expect(Tenon::Contact).to receive(:where).with(args) { Tenon::Contact }
        get :index, format: 'json', q: 'search'
      end

      it 'should not sort the contacts by type' do
        expect(Tenon::Contact).not_to receive(:with_type)
        get :index, format: 'json', q: 'search'
      end
    end

    %w(read unread replied unreplied).each do |type|
      context "with params[:type] = #{type}" do
        it 'should search the contacts with the type' do
          expect(Tenon::Contact).to receive(type) { Tenon::Contact }
          get :index, format: 'json', type: type
        end

        it 'should not search the contacts by type' do
          expect(Tenon::Contact).not_to receive(:where)
          get :index, format: 'json', type: 'images'
        end
      end

      context "with params[:q] = 'search' and params[:type] = '#{type}'" do
        it 'should search the contacts and sort them by type' do
          args = [
            'name ILIKE :q OR email ILIKE :q OR phone ILIKE :q OR content ILIKE :q OR user_ip ILIKE :q',
            { q: '%search%' }
          ]
          expect(Tenon::Contact).to receive(:where).with(args) { Tenon::Contact }
          expect(Tenon::Contact).to receive(type) { Tenon::Contact }
          get :index, format: 'json', type: type, q: 'search'
        end
      end
    end
  end

  %w(toggle_read toggle_replied).each do |action|
    describe "GET #{action}.json" do
      let(:contact) { double }
      before { Tenon::Contact.stub(:find) { contact } }

      context 'when successful' do
        before do
          contact.stub("#{action}!") { true }
        end

        it 'should render the contact to json' do
          get action, id: 1, format: 'json'
          expect(response.body).to eq double.to_json
        end

        it 'should be successful' do
          get action, id: 1, format: 'json'
          expect(response).to be_success
        end
      end

      context 'when not successful' do
        before do
          contact.stub("#{action}!") { false }
        end

        it 'should return an error' do
          get action, id: 1, format: 'json'
          expect(response).not_to be_success
        end
      end
    end

    describe "GET #{action}.html" do
      let(:contact) { double }
      before { Tenon::Contact.stub(:find) { contact } }

      context 'when successful' do
        before do
          contact.stub("#{action}!") { true }
        end

        it 'should set the flash[:notice]' do
          get action, id: 1, format: 'html'
          expect(controller.flash[:notice]).not_to be_blank
        end

        it 'should redirect to index' do
          get action, id: 1, format: 'html'
          expect(response).to redirect_to '/tenon/contacts'
        end
      end

      context 'when not successful' do
        before do
          contact.stub("#{action}!") { false }
        end

        it 'should set the flash[:warning]' do
          get action, id: 1, format: 'html'
          expect(controller.flash[:warning]).not_to be_blank
        end

        it 'should redirect to index' do
          get action, id: 1, format: 'html'
          expect(response).to redirect_to '/tenon/contacts'
        end
      end
    end
  end
end
