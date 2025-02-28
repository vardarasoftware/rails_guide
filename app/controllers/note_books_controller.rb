class NoteBooksController < ApplicationController
  def index
    @note_books = NoteBook.all
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
  
  private

  def note_book_params
    params.require(:note_book).permit(:title, :content)  # Add other permitted fields here
  end
end
