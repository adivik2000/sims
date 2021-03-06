module CSVImporter
  class NewsAdmins < CSVImporter::BaseRoles
    FIELD_DESCRIPTIONS = { 
      :district_user_id =>"Key for user"
    }
    class << self
      def csv_headers
        [:district_user_id]
      end
      def description
        "List of users with access to the edit and create news entries."
      end

      def overwritten
      end

      def load_order
      end

      def removed
      end

#      def related
#      end

      def how_often
        "Start of school year, or handle manually."
      end

#      def alternate
#      end

      def upload_responses
        super
      end

      def how_many_rows
        "One row per user with this access."
      end
    end


  end
end

