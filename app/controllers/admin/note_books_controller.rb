require "prawn"
class Admin::NoteBooksController < ApplicationController
  http_basic_authenticate_with(
    name: Rails.application.credentials.dig(:basic_auth, :user),
    password: Rails.application.credentials.dig(:basic_auth, :password)
  )
  rescue_from ActiveRecord::RecordNotFound, with: :note_book_not_found

  def new
    @note_book = NoteBook.new
  end

  def index
    @note_books = NoteBook.all
  end

  def create
    @note_book = NoteBook.new(note_book_params)
    if @note_book.save
      redirect_to admin_note_books_path, notice: "Notebook created successfully!"
    else
      render :new
    end
  end

  def show
    @note_book = NoteBook.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf { render pdf: generate_pdf(@note_books) }
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

  def download
    @note_book = NoteBook.find(params[:id])
    send_data generate_pdf(@note_book),
              filename: "#{@note_book.title}.pdf",
              type: "application/pdf"
  end

  private

  def note_book_not_found
    render plain: "Notebook Not Found", status: 404
  end

  def note_book_params
    params.require(:note_book).permit(:title, :content, :author)
  end

  def generate_pdf(note_book)
    Prawn::Document.new do
      text "Notebook Details", align: :center, size: 20
      move_down 10
      text "Title: #{note_book.title}", size: 14
      text "Author: #{note_book.author}", size: 12
      text "Content:\n#{note_book.content}", size: 12
    end.render
  end
end
