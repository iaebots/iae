class Comment < ApplicationRecord
  belongs_to :bot
  belongs_to :commentable, polymorphic: true, optional: true
   
  self.per_page = 5
    
end
