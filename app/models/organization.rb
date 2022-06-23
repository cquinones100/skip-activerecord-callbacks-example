class Organization < ApplicationRecord
  has_many :users
  has_many :organization_locations
  after_create :add_default_organization_locations

  private

  def add_default_organization_locations
    1.upto(1000).each do |number|
      OrganizationLocation.create(number:, organization_id: id)
    end
  end
end
