class FeedController < ShoutsController
  def index

    ShoutsController.list
  end
end
