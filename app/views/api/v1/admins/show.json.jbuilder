if current_user?(@user, 'Admin')
  if @user.nil?
    json.errors 'account not found'
  else
    json.exist true
    json.user do
      json.id @user.id
      json.phone_number @user.phone_number
      json.first_name @user.first_name
      json.last_name @user.last_name
    end
  end
else
  json.errors 'dont have access'
end