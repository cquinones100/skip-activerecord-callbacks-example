require 'rails_helper'

RSpec.describe User, type: :model do
  FactoryBot.define do
    factory :organization do
    end
  end

  it do
    expect { User.create(organization: create(:organization)) }
      .to change { User.count }
      .from(0)
      .to(1)
  end
end
