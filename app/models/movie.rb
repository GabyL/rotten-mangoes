class Movie < ActiveRecord::Base
  
  has_many :reviews

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  validates :release_date,
    presence: true

  validate :release_date_is_in_the_future

  mount_uploader :poster, AvatarUploader

  scope :runtime_greater_than, ->(min_time) { where("runtime_in_minutes > ?", min_time)}
  scope :runtime_less_than, ->(max_time) { where("runtime_in_minutes < ?", max_time)}

  scope :search_title_or_director, -> (title_or_director) { 
    where(("title like ? collate nocase or director like ? collate nocase"), "%#{title_or_director}%", "%#{title_or_director}%")
  }

  # scope :search_title, ->(movie_title) { where("title like ?", movie_title) }
  # scope :search_director, ->(director) { where("director like ?", director) }


  def review_average
    if reviews.size>0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      0
    end
  end


  class << self

    def search(title_or_director, run_time)

      found_movies = self.all

      case run_time
      when '1'
        found_movies = found_movies.runtime_less_than(90)
      when '2'
        found_movies = found_movies.runtime_greater_than(90).runtime_less_than(120)
      when '3'
        found_movies = found_movies.runtime_greater_than(120)
      when '4'
        found_movies
      end

      if title_or_director.present?
        found_movies = found_movies.search_title_or_director(title_or_director)
      end

      # if director.present?
      #   found_movies = found_movies.search_director(director)
      # end

      # if movie_title.present?
      #   found_movies = found_movies.search_title(movie_title)
      # end

      found_movies #is this necesssary???
    end


    #   if run_time
    #     case run_time
    #     when '1'
    #       found_runtimes = where("runtime_in_minutes < 90")
    #     when '2'
    #       found_runtimes = where("90 < runtime_in_minutes").where("runtime_in_minutes< 120")
    #     when '3'
    #       found_runtimes = where("runtime_in_minutes > 120")
    #     when '4'
    #       found_runtimes = where("runtime_in_minutes")
    #     end
    #     if director != ""
    #       found_directors = found_runtimes.where("director like ?", director)
    #       if movie_title != ""
    #         found_titles = found_directors.where("title like ?", movie_title)
    #       else
    #         found_directors
    #       end
    #     else
    #       found_titles = found_runtimes.where("title like ?", movie_title)
    #     end
    #   end
    # end
  end

  protected

  def release_date_is_in_the_future
    if release_date.present?
      errors.add(:release_date, "should probably be in the future") if release_date < Date.today
    end
  end

  # private

  # def poster_params
  #   params.require(:movie).permit(:image, :remote_image_url)
  # end

end