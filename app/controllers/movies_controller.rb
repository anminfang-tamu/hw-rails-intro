class MoviesController < ApplicationController

    def show
      id = params[:id] # retrieve movie ID from URI route
      @movie = Movie.find(id) # look up movie by unique ID
      # will render app/views/movies/show.<extension> by default
    end
  
    def index
      
      session[:rating] = params[:rating] unless params[:rating].nil?
      session[:sort] = params[:sort] unless params[:sort].nil?
      
      puts "------------------------"
      p params[:rating]
      p session[:rating]
      
      @params_rating = params[:rating]
      @params_sort = params[:sort]
      @session_rating = session[:rating]
      @session_sort = session[:sort]
      @sort = ""
      @css_title = ""
      @css_release_date = ""
      
      if ((@params_rating.nil? && !@session_rating.nil?) || (@params_sort.nil? && !@session_sort.nil?))
        redirect_to movies_path("rating" => @session_rating, "sort" => @session_sort)
      elsif !@params_rating.nil? || !@params_sort.nil?
        if !params[:ratings].nil?
          array_ratings = params[:rating].keys
          @movies = Movie.where(rating: array_ratings).order(@session_sort)
          # @movies = Movie.filter(@params_rating).order(@session_sort)
        else
          @movies = Movie.all.order(@session_sort)
        end
      elsif !@session_rating.nil? || !@session_sort.nil?
        redirect_to movies_path("rating" => @session_rating, "sort" => @session_sort)
      else
        @movies = Movie.all
      end
      
      @movies = if params[:rating]
                  Movie.filter(params[:rating])
                else
                  Movie.order(params[:sort])
                end
      
      
      if params[:sort]
        @sort = params[:sort]
      else
        @sort = nil
      end
      
      if @sort == 'title'
        @css_title = "bg-warning"
        @css_release_date = ""
      elsif @sort == 'release_date'
        @css_title = ""
        @css_release_date = "bg-warning"
      end

    end
    
    # def filtering_params(params)
    #   if params
    #     params.slice(:rating_g, :rating_pg, :rating_nc_17, :rating_pg_13, :rating_r)
    #   end
    # end
  
    def new
      # default: render 'new' template
    end
  
    def create
      @movie = Movie.create!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully created."
      redirect_to movies_path
    end
  
    def edit
      @movie = Movie.find params[:id]
    end
  
    def update
      @movie = Movie.find params[:id]
      @movie.update_attributes!(movie_params)
      flash[:notice] = "#{@movie.title} was successfully updated."
      redirect_to movie_path(@movie)
    end
  
    def destroy
      @movie = Movie.find(params[:id])
      @movie.destroy
      flash[:notice] = "Movie '#{@movie.title}' deleted."
      redirect_to movies_path
    end
  
    private
    # Making "internal" methods private is not required, but is a common practice.
    # This helps make clear which methods respond to requests, and which ones do not.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end

    def change_background(id)
      case id
        when "title_header"
          "bg-yellow"
        when "release_date_header"
          "bg-yellow"
        else
          ""
      end
    end
end