# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tag, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:task_taggings).dependent(:destroy) }
    it { should have_many(:tasks).through(:task_taggings) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  describe 'scopes' do
    describe '.search_by_title' do
      let!(:tag1) { create(:tag, title: 'Důležitý') }
      let!(:tag2) { create(:tag, title: 'Neodkladný') }
      let!(:tag3) { create(:tag, title: 'Osobní') }

      it 'returns tags matching the search query' do
        expect(Tag.search_by_title('Důležitý')).to include(tag1)
        expect(Tag.search_by_title('Důležitý')).not_to include(tag2, tag3)
      end

      it 'returns empty when no match is found' do
        expect(Tag.search_by_title('Neexistující')).to be_empty
      end

      it 'returns all records if search query is blank' do
        expect(Tag.search_by_title(nil)).to match_array([tag1, tag2, tag3])
      end
    end
  end
end