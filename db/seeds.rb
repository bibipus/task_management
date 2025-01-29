# Clearing old data
puts "🧹 Deleting old data..."
TaskTagging.destroy_all
Task.destroy_all
Tag.destroy_all
Project.destroy_all
User.destroy_all

# Creating users
puts "👤 Creating users..."
users = []
5.times do
  users << User.create!(
    email: Faker::Internet.unique.email,
    password: "password",
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name
  )
end

# Creating projects for each user
puts "📂 Creating projects..."
projects = []
users.each do |user|
  3.times do |i|
    projects << user.projects.create!(
      title: "Project ##{i + 1} - #{user.first_name}",
      position: i + 1
    )
  end
end

# Creating tags for users
puts "🏷️ Creating tags..."
tags = []
users.each do |user|
  5.times do
    tags << user.tags.create!(
      title: Faker::Hipster.word
    )
  end
end

# Creating tasks
puts "✅ Creating tasks..."
tasks = []
users.each do |user|
  user.projects.each do |project|
    5.times do
      task = project.tasks.create!(
        user: user,
        title: Faker::Lorem.sentence(word_count: 3),
        description: Faker::Lorem.paragraph(sentence_count: 2),
        is_done: [true, false].sample
      )

      # Assign random tags
      task.tags << tags.sample(rand(1..3))
      tasks << task
    end
  end
end

puts "🎉 Seeding completed successfully!"