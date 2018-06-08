class User < ApplicationRecord
  has_many :forum_posts

  def self.find_or_create_from_auth_hash(auth_hash)
    user = User.find_by(battletag: auth_hash["info"]["battletag"])
    if user.present?
      user.auth_hash = auth_hash
      user.save!
      user
    else
      User.create!({
        uid: auth_hash["uid"],
        battletag: auth_hash["info"]["battletag"],
        auth_hash: auth_hash
      })
    end
  end

  # {"provider"=>"bnet",
  # "uid"=>"12345",
  # "info"=>{"battletag"=>"battletag#1337", "id"=>12345},
  # "credentials"=>{"token"=>"11111", "expires_at"=>1531050531, "expires"=>true},
  # "extra"=>{}}
end
