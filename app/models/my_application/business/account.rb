module MyApplication
    module Business
        class Account < ApplicationRecord
          belongs_to :supplier,
            class_name: "MyApplication::Business::Supplier"
        end
    end
end
