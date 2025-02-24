module FindRecentExtension
    def find_recent
      where("created_at > ?", 5.days.ago)
    end
end
