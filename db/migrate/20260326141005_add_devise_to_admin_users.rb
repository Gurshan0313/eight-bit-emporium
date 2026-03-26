# frozen_string_literal: true

class AddDeviseToAdminUsers < ActiveRecord::Migration[7.2]
  def self.up
    change_table :admin_users do |t|
      ## Database authenticatable
      unless column_exists?(:admin_users, :email)
        t.string :email, null: false, default: ""
      end

      unless column_exists?(:admin_users, :encrypted_password)
        t.string :encrypted_password, null: false, default: ""
      end

      ## Recoverable
      unless column_exists?(:admin_users, :reset_password_token)
        t.string :reset_password_token
      end

      unless column_exists?(:admin_users, :reset_password_sent_at)
        t.datetime :reset_password_sent_at
      end

      ## Rememberable
      unless column_exists?(:admin_users, :remember_created_at)
        t.datetime :remember_created_at
      end

      ## Trackable (uncomment if needed)
      # unless column_exists?(:admin_users, :sign_in_count)
      #   t.integer :sign_in_count, default: 0, null: false
      # end
      # unless column_exists?(:admin_users, :current_sign_in_at)
      #   t.datetime :current_sign_in_at
      # end
      # etc.

      ## Confirmable (uncomment if needed)
      # unless column_exists?(:admin_users, :confirmation_token)
      #   t.string :confirmation_token
      # end
      # etc.

      ## Lockable (uncomment if needed)
      # unless column_exists?(:admin_users, :failed_attempts)
      #   t.integer :failed_attempts, default: 0, null: false
      # end
      # unless column_exists?(:admin_users, :unlock_token)
      #   t.string :unlock_token
      # end
      # unless column_exists?(:admin_users, :locked_at)
      #   t.datetime :locked_at
      # end
    end

    # Add indexes only if they don't already exist
    unless index_exists?(:admin_users, :email, unique: true)
      add_index :admin_users, :email, unique: true
    end

    unless index_exists?(:admin_users, :reset_password_token, unique: true)
      add_index :admin_users, :reset_password_token, unique: true
    end

    # Uncomment if using confirmable or lockable
    # unless index_exists?(:admin_users, :confirmation_token, unique: true)
    #   add_index :admin_users, :confirmation_token, unique: true
    # end
    # unless index_exists?(:admin_users, :unlock_token, unique: true)
    #   add_index :admin_users, :unlock_token, unique: true
    # end
  end

  def self.down
    # Devise migrations are often irreversible; keep the original warning.
    raise ActiveRecord::IrreversibleMigration
  end
end