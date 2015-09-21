class StaticPagesController < ApplicationController
  def home
  end

  def help
  end

  def about
  end
  
  def build_for_arena_xml
    send_file(
      "#{Rails.root}/public/downloads/build_for_arena.xml",
      filename: "build_for_arena.xml",
      type: "application/pdf"
    )
  end
end
