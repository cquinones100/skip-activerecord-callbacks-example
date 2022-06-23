class WidgetCreateService
  attr_reader :user

  def initialize(user:)
    @user = user
  end

  def run
    Widget.create(user:)
  end
end
