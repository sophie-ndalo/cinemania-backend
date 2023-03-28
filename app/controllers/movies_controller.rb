class MoviesController < ApplicationController

  def index
    @movies = Movie.with_attached_video.all

    render json: @movies.map { |movie|
      {
        id: movie.id,
        title: movie.title,
        description: movie.description,
        duration: movie.duration,
        video_url: movie.video.attached? ? url_for(movie.video) : nil
      }
    }
  end

  def show
    render json: @movie
  end

  def latest
    latest_movie = Movie.last

    if latest_movie
      render json: movie_attributes(latest_movie)
    else
      render json: { error: "No movies found" }, status: :not_found
    end
  end

  def create
    movie = Movie.new(movie_params)

    if movie.save
      movie.video.attach(params[:video]) if params[:video].present?

      render json: {
        movie: movie,
        video_url: movie.video.attached? ? url_for(movie.video) : nil
      }, status: :created, location: movie
    else
      render json: movie.errors, status: :unprocessable_entity
    end
  end

  private

  def movie_params
    params.permit(:title, :description, :duration, :video)
  end
end
