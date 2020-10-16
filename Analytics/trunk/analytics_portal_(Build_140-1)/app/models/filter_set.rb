class FilterSet < ActiveRecord::Base
  has_many :filter_prefs, :as => :optionable, :dependent => :destroy

  accepts_nested_attributes_for :filter_prefs, :allow_destroy => true

  attr_accessible :name, :description, :filter_prefs_attributes

  validates_presence_of :name

  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
end
