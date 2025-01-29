require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:project).optional }
    it { should have_many(:task_taggings).dependent(:destroy) }
    it { should have_many(:tags).through(:task_taggings) }
    it { should have_one_attached(:attachment) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:description) }
    it { should validate_inclusion_of(:is_done).in_array([true, false]) }
  end

  describe 'scopes' do
    let(:user) { create(:user) }
    let!(:task_done) { create(:task, user: user, is_done: true) }
    let!(:task_not_done) { create(:task, user: user, is_done: false) }

    describe '.done' do
      it 'returns only completed tasks' do
        expect(Task.done).to include(task_done)
        expect(Task.done).not_to include(task_not_done)
      end
    end

    describe '.not_done' do
      it 'returns only incomplete tasks' do
        expect(Task.not_done).to include(task_not_done)
        expect(Task.not_done).not_to include(task_done)
      end
    end

    describe '.search_by_title' do
      let!(:task1) { create(:task, user: user, title: 'First Task') }
      let!(:task2) { create(:task, user: user, title: 'Second Task') }

      it 'finds tasks by title' do
        expect(Task.search_by_title('First')).to include(task1)
        expect(Task.search_by_title('First')).not_to include(task2)
      end

      it 'returns all tasks if query is empty' do
        expect(Task.search_by_title(nil)).to match_array([task_done, task_not_done, task1, task2])
      end
    end

    describe '.with_tags' do
      let!(:tag1) { create(:tag, user: user, title: 'Important') }
      let!(:tag2) { create(:tag, user: user, title: 'Urgent') }
      let!(:task1) { create(:task, user: user, tags: [tag1]) }
      let!(:task2) { create(:task, user: user, tags: [tag1, tag2]) }
      let!(:task3) { create(:task, user: user, tags: [tag2]) }
      let!(:task_without_tags) { create(:task, user: user) }

      it 'returns tasks that have all given tags' do
        expect(Task.with_tags([tag1.id])).to match_array([task1, task2])
        expect(Task.with_tags([tag2.id])).to match_array([task2, task3])
        expect(Task.with_tags([tag1.id, tag2.id])).to match_array([task2])
      end

      it 'returns an empty array if no tasks match' do
        tag3 = create(:tag, user: user, title: 'Nonexistent')
        expect(Task.with_tags([tag3.id])).to be_empty
      end

      it 'returns an empty relation if tag_ids are blank' do
        expect(Task.with_tags([])).to be_empty
        expect(Task.with_tags(nil)).to be_empty
      end
    end
  end
end