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

  def review_average
    if reviews.size>0
      reviews.sum(:rating_out_of_ten)/reviews.size
    else
      0
    end
  end


  class << self

    def search(movie_title, director, run_time)

      if run_time
        case run_time
        when '1'
          found_runtimes = where("runtime_in_minutes < 90")
        when '2'
          found_runtimes = where("90 < runtime_in_minutes").where("runtime_in_minutes< 120")
        when '3'
          found_runtimes = where("runtime_in_minutes > 120")
        when '4'
          found_runtimes = where("runtime_in_minutes")
        end
        if director != ""
          found_directors = found_runtimes.where("director like ?", director)
          if movie_title != ""
            found_titles = found_directors.where("title like ?", movie_title)
          else
            found_directors
          end
        else
          found_titles = found_runtimes.where("title like ?", movie_title)
        end
      end
    end
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