class NoteBooksController < ApplicationController
  def index
    @note_books = NoteBook.all
  end

  def new
    @note_book = NoteBook.new
    @authors = Author.all.pluck(:first_name, :last_name, :id)
    @categories = {
      "Fiction" => [["Novel", "novel"], ["Poetry", "poetry"]],
      "Non-Fiction" => [["Biography", "biography"], ["Science", "science"]]
    }
  end

  def create
    @note_book = NoteBook.new(note_book_params)
    if @note_book.save
      redirect_to @note_book, notice: "Notebook created successfully!"
    else
      render :new
    end
  end

  def edit
    @note_book = NoteBook.find(params[:id])
  end

  def show
    @note_book = NoteBook.find(params[:id])
    render "note_books/show"
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

  private

  def set_note_book
    @note_book = NoteBook.find(params[:id])
  end

  def note_book_params
    params.require(:note_book).permit(:title, :content, :author, :published_date, :reminder_time, :last_edited_at, :time_zone)
  end
end
