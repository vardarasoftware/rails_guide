class FileDestroyerCallback
    def after_commit(file)
      if File.exist?(file.filepath)
        File.delete(file.filepath)
      end
    end
end
  