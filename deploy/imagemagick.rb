###
### IMAGEMAGICK
################################################################################

namespace :provision do
  desc "Install the imagemagick library"
  task :imagemagick do
    queue "sudo apt-get -y install libmagickwand-dev imagemagick"
    queue "sudo apt-get clean -y"
  end
end