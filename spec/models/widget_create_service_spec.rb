require 'rails_helper'

class CreateWithoutCallbacksStrategy
  def initialize
    # model this strategy after the factory bot 'create' factory
    @strategy = FactoryBot.strategy_by_name(:create).new
  end

  # FactoryBot will call #association on the strategy instance. We don't want
  # to change the implementation from the 'create' strategy
  delegate :association, to: :@strategy

  # FactoryBot will call #result on this strategy instance. This skips callbacks
  # before the 'create' strategy is executed and resets the callbacks to the defined
  # state after executing the 'create' strategy
  def result(evaluation)
    callback_manager = CallbackManager.new(evaluation.object)

    callback_manager.skip_callbacks

    @strategy.result(evaluation).tap do
      callback_manager.reset_callbacks
    end
  end
end

class CallbackManager
  attr_reader :instance

  def initialize(instance)
    @instance = instance
  end

  def callbacks
    @callbacks ||= instance.class._create_callbacks.to_a.reject do |callback|
      is_association_callback?(callback)
    end
  end

  def skip_callbacks
    callbacks.each do |callback|
      instance.class.skip_callback callback.name, callback.kind, callback.filter
    end
  end

  def reset_callbacks
    callbacks.each do |callback|
      instance.class.send("_#{callback.name}_callbacks").append(callback)
    end
  end

  def is_association_callback?(callback)
    # ActiveRecord defines some callbacks to properly associate this instance to models
    # defined with `has_many`, `belongs_to`, etc. configuration. We don't
    # skip those callbacks
    filter = callback.filter

    filter.to_s.include?('autosave_associated_records_for') ||
      filter.to_s.include?('after_save_collection_association') ||
      filter.to_s.include?('before_save_collection_association')
  end
end


RSpec.describe WidgetCreateService do
  FactoryBot.register_strategy(:create_without_callbacks, CreateWithoutCallbacksStrategy)

  FactoryBot.define do
    factory :organization do
    end

    factory :user do
      organization { create(:organization) }
    end
  end

  let(:user) { create(:user, organization: create_without_callbacks(:organization)) }

  it 'creates a widget' do
    expect { WidgetCreateService.new(user:).run }
      .to change { Widget.count }
      .from(0)
      .to(1)
  end
end
