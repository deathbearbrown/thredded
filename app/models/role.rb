class Role
  include Mongoid::Document
  field :level, :type => Symbol

  referenced_in :messageboard
  references_many :users, :stored_as => :array, :inverse_of => :roles

  ROLES = [:superadmin, :admin, :moderator, :member]
  validates_presence_of   :level
  validates_inclusion_of  :level, :in => ROLES

  scope :for, lambda { |messageboard| where(:messageboard_id => messageboard.id) }
  scope :as,  lambda { |roles| any_in(:level => roles) }
end