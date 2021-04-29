json.array! @users do |user|
  json.super_user do
    json.id user.id
    json.phone_number = user.phone_number
    json.fisrt_name user.first_name
    json.last_name user.last_name
  end
end