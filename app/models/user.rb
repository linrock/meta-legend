class User < ApplicationRecord
  BNET_REGIONS = %w( US EU SEA CN )

  has_many :liked_replays
  has_many :forum_posts

  validates :forum_username, format: { with: /\A[a-zA-Z0-9_]{4,25}\z/ }, allow_blank: true
  validates :twitch_username, format: { with: /\A[a-zA-Z0-9_]{4,25}\z/ }, allow_blank: true
  validates :region, inclusion: BNET_REGIONS, allow_blank: true

  validate :ensure_format_of_usernames
  validate :forum_username_cannot_change

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

  def find_by_battletag(battletag)
    find_by("LOWER(battletag) = ?", battletag.downcase)
  end

  def forum_name
    forum_username || name
  end

  def name
    battletag&.split("#")[0]
  end

  private

  def ensure_format_of_usernames
    if forum_username and forum_username[0] == '_'
      errors.add(:forum_username, "can't start with an underscore")
    end
  end

  def forum_username_cannot_change
    return unless forum_username.present?
    if changed_attributes[:forum_username].present?
      errors.add(:forum_username, "has already been set")
    end
  end
end
