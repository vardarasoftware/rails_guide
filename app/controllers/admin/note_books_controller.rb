class Admin::NoteBooksController < ApplicationController
  def new
    @note_book = NoteBook.new
  end
  
  def create
    @note_book = NoteBook.new(note_book_params)
    if @note_book.save
      redirect_to admin_note_books_path, notice: "Notebook created successfully!"
    else
      render :new
    end
  end
  
  def edit
    @note_book = NoteBook.find(params[:id])
  end
  
  def update
    @note_book = NoteBook.find(params[:id])
    if @note_book.update(note_book_params)
      redirect_to admin_note_books_path, notice: "Notebook updated successfully!"
    else
      render :edit
    end
  end
  
  private
  
  def note_book_params
    params.require(:note_book).permit(:title, :content, :author)
  end
end
