class ReceipeInfo < ApplicationRecord
  attr_accessor :remove_main_image

  belongs_to :recipe

  has_rich_text :content

  has_one_attached :main_image do |attachable|
    attachable.variant :thumb, resize: '100x100'
    attachable.variant :medium, resize: '300x300', monochrome: true
  end

  has_many_attached :other_images do |attachable|
    attachable.variant :thumb, resize: '100x100'
    attachable.variant :medium, resize: '300x300', monochrome: true
  end
end
