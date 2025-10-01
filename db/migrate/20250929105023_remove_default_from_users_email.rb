class RemoveDefaultFromUsersEmail < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :email, nil
  end
end
