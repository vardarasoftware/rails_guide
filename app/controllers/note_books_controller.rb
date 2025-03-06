class NoteBooksController < ApplicationController
  require "csv"

  def upload_csv
    uploaded_file = params[:csv_file]
    if uploaded_file.present?
      csv_data = CSV.parse(uploaded_file.read, headers: true)
      csv_data.each do |row|
        NoteBook.create(title: row["Title"], description: row["Description"])
      end
      redirect_to note_books_path, notice: "CSV uploaded successfully!"
    else
      redirect_to note_books_path, alert: "Please select a file."
    end
  end

  def index
    @note_books = NoteBook.all
    if cookies[:last_opened_note_book]
      @last_opened_note_book = NoteBook.find_by(id: cookies[:last_opened_note_book])
    end
  end

  def new
    @note_book = NoteBook.new
    @authors = Author.all.pluck(:first_name, :last_name, :id)
    @categories = {
      "Fiction" => [ [ "Novel", "novel" ], [ "Poetry", "poetry" ] ],
      "Non-Fiction" => [ [ "Biography", "biography" ], [ "Science", "science" ] ]
    }
  end

  def create
    @note_book = NoteBook.new(note_book_params)
    if @note_book.save
      flash[:notice] = "Notebook created successfully!"
      redirect_to @note_book
    else
      flash[:alert] = "Error creating notebook."
      render :new
    end
  end

  def edit
    @note_book = NoteBook.find(params[:id])
  end

  def show
    @note_book = NoteBook.find(params[:id])
    session[:last_note_book_id] = @note_book.id
    render "note_books/show"
  end

  def last_opened
    if session[:last_note_book_id]
      @note_book = NoteBook.find(session[:last_note_book_id])
      redirect_to @note_book
    else
      redirect_to note_books_path, alert: "No note_book found."
    end
  end

  def update
    @note_book = NoteBook.find(params[:id])
    if @note_book.update(note_book_params)
      redirect_to @note_book
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @note_book.destroy
    redirect_to note_books_path, notice: "NoteBook deleted successfully."
  end

  def set_cookie
    cookies.signed[:user_id] = current_user.id
    cookies.encrypted[:last_opened] = DateTime.now
    redirect_to action: "show_cookie"
  end

  def show_cookie
    @user_id = cookies.signed[:user_id] # Get the user ID
    @last_opened = cookies.encrypted[:last_opened] # Get the last opened time
  end

  private

  def set_note_book
    @note_book = NoteBook.find(params[:id])
  end

  def note_book_params
    params.require(:note_book).permit(:title, :content, :author, :published_date, :reminder_time, :last_edited_at, :time_zone, tags: [])
  end
end
