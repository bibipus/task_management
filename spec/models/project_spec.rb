# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Project, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:tasks).dependent(:destroy) }
  end

  describe 'validations' do
    subject { create(:project) }

    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:position) }
    it { should validate_uniqueness_of(:position).scoped_to(:user_id) }
  end

  describe 'scopes' do
    describe '.search_by_title' do
      let!(:project1) { create(:project, title: 'Práce') }
      let!(:project2) { create(:project, title: 'Osobní') }
      let!(:project3) { create(:project, title: 'Škola') }

      it 'returns projects matching the search query' do
        expect(Project.search_by_title('Práce')).to include(project1)
        expect(Project.search_by_title('Práce')).not_to include(project2, project3)
      end

      it 'returns empty when no match is found' do
        expect(Project.search_by_title('Neexistující')).to be_empty
      end

      it 'returns all records if search query is blank' do
        expect(Project.search_by_title(nil)).to match_array([project1, project2, project3])
      end
    end
  end

  describe '.update_positions' do
    let!(:user) { create(:user) }
    let!(:project1) { create(:project, user: user, position: 1) }
    let!(:project2) { create(:project, user: user, position: 2) }
    let!(:project3) { create(:project, user: user, position: 3) }

    it 'updates project positions correctly' do
      Project.update_positions([project3.id, project1.id, project2.id])

      expect(project3.reload.position).to eq(1)
      expect(project1.reload.position).to eq(2)
      expect(project2.reload.position).to eq(3)
    end

    it 'does not fail if project IDs are missing' do
      expect { Project.update_positions([]) }.not_to raise_error
    end
  end
end