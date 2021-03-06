class User < ActiveRecord::Base
  has_many :interests
  def self.find_or_create_from_auth_hash(auth_hash)
    find_by_github_id(auth_hash["uid"]) || create_with_omniauth(auth_hash)
  end

  def self.create_with_omniauth(oauth)
    # auth情報登録
    user = User.new
    user.github_id      = oauth["uid"]

    if oauth["info"].present?
      user.name       = oauth["info"]["name"]
      user.image      = oauth["info"]["image"]
      user.email      = oauth["info"]["email"]
      user.nickname   = oauth["info"]["nickname"]
      user.location   = oauth["info"]["location"]
      user.github_url = oauth["info"]["urls"]["GitHub"]
      user.blog       = oauth["info"]["urls"]["Blog"]
    end

    # if oauth["credentials"].present?
    #   user.token  = oauth['credentials']['token']
    #   user.secret = oauth['credentials']['secret']
    # end
    #
    # if oauth["extra"].present? and oauth["extra"]["raw_info"].present?
    #   user.gender   = oauth["extra"]["raw_info"]["gender"]
    #   user.location = oauth["extra"]["raw_info"]["location"] if user.location.blank?
    # end

    user.save!

    return user
  end

  def self.search(query)
    if query
      User.where(['name like ?', "%#{query}%"])
    else
      User.all
    end
  end
end
