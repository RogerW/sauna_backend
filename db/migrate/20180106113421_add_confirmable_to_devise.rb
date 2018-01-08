class AddConfirmableToDevise < ActiveRecord::Migration[5.1]
  def change
    User.all.update_all confirmed_at: DateTime.now
    # All existing user accounts should be able to log in after this.
  end
end
