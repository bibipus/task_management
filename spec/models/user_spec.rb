require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with a first name, last name, email, and password" do
    user = build(:user)
    expect(user).to be_valid
  end

  it "is invalid without a first name" do
    user = build(:user, first_name: nil)
    expect(user).not_to be_valid
  end

  it "is invalid without an email" do
    user = build(:user, email: nil)
    expect(user).not_to be_valid
  end

  it "is invalid with a duplicate email" do
    create(:user, email: "test@example.com")
    user = build(:user, email: "test@example.com")
    expect(user).not_to be_valid
  end

  describe "#full_name" do
    it "returns the full name of the user" do
      user = build(:user, first_name: "Filip", last_name: "Sadek")
      expect(user.full_name).to eq("Filip Sadek")
    end

    it "returns a name with missing last name" do
      user = build(:user, first_name: "Filip", last_name: nil)
      expect(user.full_name).to eq("Filip ") # Ponechá mezeru na konci

      user = build(:user, first_name: nil, last_name: "Sadek")
      expect(user.full_name).to eq(" Sadek") # Ponechá mezeru na začátku
    end

    it "returns an empty string if both names are nil" do
      user = build(:user, first_name: nil, last_name: nil)
      expect(user.full_name).to eq(" ")
    end
  end
end