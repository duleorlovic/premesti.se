class DeviseCreateUserConstraintsAndIndexes < Neo4j::Migrations::Base
  def up
    add_constraint :User, :email, force: true
    add_index :User, :remember_token, force: true
    add_index :User, :reset_password_token, force: true
    add_index :User, :confirmation_token, force: true
    # add_index :User, :unlock_token, force: true
    # add_index :User, :authentication_token, force: true
  end

  def down
    remove_index :User, :email, force: true
    remove_index :User, :remember_token, force: true
    remove_index :User, :reset_password_token, force: true
    remove_index :User, :confirmation_token, force: true
    # remove_index :User, :unlock_token, force: true
    # remove_index :User, :authentication_token, force: true
  end
end
